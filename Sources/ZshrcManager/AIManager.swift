import Foundation
import Combine

enum AIProvider: String, Codable, CaseIterable {
    case gemini = "Google Gemini"
    case openai = "OpenAI"
    case claude = "Anthropic Claude"
    case deepseek = "DeepSeek"
    case custom = "OpenAI Compatible"
}

class AIManager: ObservableObject {
    @Published var apiKey: String = ""
    @Published var provider: AIProvider = .gemini
    @Published var customEndpoint: String = ""
    @Published var modelName: String = ""
    @Published var isProcessing: Bool = false
    @Published var testResult: String? = nil
    
    init() {
        self.apiKey = UserDefaults.standard.string(forKey: "ai_api_key") ?? ""
        self.customEndpoint = UserDefaults.standard.string(forKey: "ai_endpoint") ?? ""
        self.modelName = UserDefaults.standard.string(forKey: "ai_model_name") ?? ""
        if let savedProvider = UserDefaults.standard.string(forKey: "ai_provider"),
           let p = AIProvider(rawValue: savedProvider) {
            self.provider = p
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(apiKey, forKey: "ai_api_key")
        UserDefaults.standard.set(customEndpoint, forKey: "ai_endpoint")
        UserDefaults.standard.set(modelName, forKey: "ai_model_name")
        UserDefaults.standard.set(provider.rawValue, forKey: "ai_provider")
    }
    
    private func getBaseURL() -> String {
        switch provider {
        case .gemini:
            return "https://generativelanguage.googleapis.com/v1beta/models/\(modelName.isEmpty ? "gemini-pro" : modelName):generateContent?key=\(apiKey)"
        case .openai:
            return "https://api.openai.com/v1/chat/completions"
        case .claude:
            return "https://api.anthropic.com/v1/messages"
        case .deepseek:
            return "https://api.deepseek.com/chat/completions"
        case .custom:
            return customEndpoint
        }
    }
    
    private func getModel() -> String {
        if !modelName.isEmpty { return modelName }
        switch provider {
        case .gemini: return "gemini-pro"
        case .openai: return "gpt-3.5-turbo"
        case .claude: return "claude-3-sonnet-20240229"
        case .deepseek: return "deepseek-chat"
        case .custom: return "gpt-3.5-turbo"
        }
    }
    
    func testConnection(completion: @escaping (Bool, String) -> Void) {
        generateCommand(from: "echo hello") { result in
            switch result {
            case .success:
                completion(true, "Connection Successful!")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func generateCommand(from prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        if apiKey.isEmpty {
            completion(.failure(NSError(domain: "AIManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "API Key Is Missing"])))
            return
        }
        
        isProcessing = true
        
        let systemPrompt = """
        You are a Zsh/Unix command expert. Convert the user's natural language request into a single precise shell command.
        Rules:
        1. Output ONLY the command code. No explanations, no markdown blocks.
        2. Ensure the command is safe for macOS.
        3. If multiple steps are needed, use && or pipes.
        """
        
        guard let url = URL(string: getBaseURL()) else {
            DispatchQueue.main.async { 
                self.isProcessing = false
                completion(.failure(NSError(domain: "AIManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])))
            }
            return 
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any]
        let currentModel = getModel()
        
        switch provider {
        case .gemini:
            body = [
                "contents": [[
                    "role": "user",
                    "parts": [["text": "\(systemPrompt)\n\nUser Request: \(prompt)"]]
                ]]
            ]
        case .claude:
            request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
            request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
            body = [
                "model": currentModel,
                "max_tokens": 1024,
                "system": systemPrompt,
                "messages": [
                    ["role": "user", "content": prompt]
                ]
            ]
        default: // OpenAI, DeepSeek, Custom
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            body = [
                "model": currentModel,
                "messages": [
                    ["role": "system", "content": systemPrompt],
                    ["role": "user", "content": prompt]
                ]
            ]
        }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isProcessing = false }
            
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "AIManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty response"]))) }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                // Error handling
                if let errorObj = json?["error"] as? [String: Any], let msg = errorObj["message"] as? String {
                    throw NSError(domain: "API", code: 1, userInfo: [NSLocalizedDescriptionKey: msg])
                }
                
                var resultText = ""
                if self.provider == .gemini {
                    if let candidates = json?["candidates"] as? [[String: Any]],
                       let first = candidates.first,
                       let content = first["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]],
                       let text = parts.first?["text"] as? String {
                        resultText = text
                    }
                } else if self.provider == .claude {
                    if let content = json?["content"] as? [[String: Any]],
                       let text = content.first?["text"] as? String {
                        resultText = text
                    }
                } else { // OpenAI Compatible
                    if let choices = json?["choices"] as? [[String: Any]],
                       let first = choices.first,
                       let message = first["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        resultText = text
                    }
                }
                
                if resultText.isEmpty {
                    throw NSError(domain: "Parse", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not parse AI response"])
                }
                
                let cleanCommand = resultText.trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "```bash", with: "")
                    .replacingOccurrences(of: "```zsh", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                DispatchQueue.main.async { completion(.success(cleanCommand)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
