import Foundation
import Combine

enum AIProvider: String, Codable, CaseIterable {
    case gemini = "Google Gemini"
    case openai = "OpenAI / Compatible"
}

class AIManager: ObservableObject {
    @Published var apiKey: String = ""
    @Published var provider: AIProvider = .gemini
    @Published var customEndpoint: String = ""
    @Published var isProcessing: Bool = false
    
    // 从 AppStorage 或 UserDefaults 加载配置
    init() {
        self.apiKey = UserDefaults.standard.string(forKey: "ai_api_key") ?? ""
        self.customEndpoint = UserDefaults.standard.string(forKey: "ai_endpoint") ?? ""
        if let savedProvider = UserDefaults.standard.string(forKey: "ai_provider"),
           let p = AIProvider(rawValue: savedProvider) {
            self.provider = p
        }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(apiKey, forKey: "ai_api_key")
        UserDefaults.standard.set(customEndpoint, forKey: "ai_endpoint")
        UserDefaults.standard.set(provider.rawValue, forKey: "ai_provider")
    }
    
    func generateCommand(from prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !apiKey.isEmpty else {
            completion(.failure(NSError(domain: "AIManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "API Key Is Missing"])))
            return
        }
        
        isProcessing = true
        
        // 构建 System Prompt
        let systemPrompt = """
        You are a Zsh/Unix command expert. Convert the user's natural language request into a single precise shell command.
        Rules:
        1. Output ONLY the command code. No explanations, no markdown blocks unless specified.
        2. Ensure the command is safe for macOS.
        3. If multiple steps are needed, use && or pipes.
        4. If the request is ambiguous, pick the most common/standard way.
        """
        
        // 此处为简化版的 API 请求逻辑（以 Gemini 为例，实际开发中会根据提供者切换 URL）
        let urlString = provider == .gemini ? 
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=\(apiKey)" :
            (customEndpoint.isEmpty ? "https://api.openai.com/v1/chat/completions" : customEndpoint)
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 构建请求体 (根据 Provider 不同而异，此处示意)
        let body: [String: Any]
        if provider == .gemini {
            body = [
                "contents": [[
                    "role": "user",
                    "parts": [["text": "\(systemPrompt)\n\nUser Request: \(prompt)"]]
                ]]
            ]
        } else {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            body = [
                "model": "gpt-3.5-turbo",
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
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 解析逻辑 (简化处理)
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    var resultText = ""
                    if self.provider == .gemini {
                        if let candidates = json["candidates"] as? [[String: Any]],
                           let first = candidates.first,
                           let content = first["content"] as? [String: Any],
                           let parts = content["parts"] as? [[String: Any]],
                           let text = parts.first?["text"] as? String {
                            resultText = text
                        }
                    } else {
                        if let choices = json["choices"] as? [[String: Any]],
                           let first = choices.first,
                           let message = first["message"] as? [String: Any],
                           let text = message["content"] as? String {
                            resultText = text
                        }
                    }
                    
                    let cleanCommand = resultText.trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: "```bash", with: "")
                        .replacingOccurrences(of: "```zsh", with: "")
                        .replacingOccurrences(of: "```", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    DispatchQueue.main.async { completion(.success(cleanCommand)) }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
