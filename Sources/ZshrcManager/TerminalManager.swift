import Foundation
import Combine

class TerminalManager: ObservableObject {
    @Published var output: String = ""
    @Published var isRunning: Bool = false
    
    // Virtual Prompt for UX
    private let prompt = "zsh-lab % "
    private let fileManager = FileManager.default
    
    init() {
        // Initial welcome message
        self.output = "--- Welcome to Zshrc Manager Test Lab ---\n"
        self.output += "Commands run in a clean login shell environment.\n\n"
        self.output += prompt
    }
    
    /// Executes a command in a new login shell (Stateless mode)
    func sendInput(_ input: String) {
        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        DispatchQueue.main.async {
            self.isRunning = true
            // Echo command to output if it's not already there (UX)
            if !self.output.hasSuffix(self.prompt) {
                self.output += "\n" + self.prompt
            }
            self.output += input + "\n"
        }
        
        // Execute on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            let pipe = Pipe()
            
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            // -l: login shell (to source .zprofile/.zshrc)
            // -c: run command
            process.arguments = ["-lc", input]
            
            // Environment Bootstrap
            var env = ProcessInfo.processInfo.environment
            env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:" + (env["PATH"] ?? "")
            process.environment = env
            
            process.standardOutput = pipe
            process.standardError = pipe
            
            let handle = pipe.fileHandleForReading
            
            do {
                try process.run()
                
                let data = handle.readDataToEndOfFile()
                if let str = String(data: data, encoding: .utf8) {
                    let cleanStr = str.removingANSIEscapeCodes()
                    DispatchQueue.main.async {
                        self.output += cleanStr
                    }
                }
                
                process.waitUntilExit()
                
                DispatchQueue.main.async {
                    self.isRunning = false
                    if !self.output.hasSuffix("\n") { self.output += "\n" }
                    self.output += self.prompt
                    
                    // Rolling Window: Keep last 10,000 characters
                    if self.output.count > 10000 {
                        self.output = String(self.output.suffix(8000))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isRunning = false
                    self.output += "Execution error: \(error.localizedDescription)\n"
                    self.output += self.prompt
                }
            }
        }
    }
    
    /// Executes a command in the background (used by Wizards/Detectors)
    func runCommand(_ command: String, silent: Bool = false, completion: ((String) -> Void)? = nil) {
        if !silent {
            DispatchQueue.main.async {
                self.output += "\n" + self.prompt + command + "\n"
                self.isRunning = true
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            let pipe = Pipe()
            
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = ["-lc", command]
            
            var env = ProcessInfo.processInfo.environment
            env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:" + (env["PATH"] ?? "")
            process.environment = env
            
            process.standardOutput = pipe
            process.standardError = pipe
            
            do {
                try process.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let result = String(data: data, encoding: .utf8)?.removingANSIEscapeCodes() ?? ""
                
                process.waitUntilExit()
                
                DispatchQueue.main.async {
                    if !silent {
                        self.output += result
                        if !self.output.hasSuffix("\n") { self.output += "\n" }
                        self.output += self.prompt
                        self.isRunning = false
                    }
                    completion?(result.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            } catch {
                DispatchQueue.main.async {
                    if !silent {
                        self.output += "Error: \(error.localizedDescription)\n"
                        self.output += self.prompt
                        self.isRunning = false
                    }
                    completion?("")
                }
            }
        }
    }
    func addOutput(_ text: String) {
        DispatchQueue.main.async {
            self.output += text
        }
    }
    
    func startSession() {
        // No-op for stateless mode
    }

    func clear() {
        self.output = prompt
    }
}
