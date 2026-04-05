import Foundation
import Combine

class TerminalManager: ObservableObject {
    @Published var output: String = ""
    @Published var isRunning: Bool = false
    
    private var process: Process?
    private var stdinPipe = Pipe()
    private var stdoutPipe = Pipe()
    
    private let fileManager = FileManager.default
    
    init() {
    }
    
    deinit {
        stop()
    }
    
    /// Starts a persistent zsh session
    func startSession() {
        guard !isRunning else { return }
        
        let newProcess = Process()
        stdinPipe = Pipe()
        stdoutPipe = Pipe()
        
        newProcess.executableURL = URL(fileURLWithPath: "/bin/zsh")
        newProcess.arguments = ["-i", "-l"] // Interactive, Login shell
        
        // --- ENVIRONMENT BOOTSTRAP ---
        var environment = ProcessInfo.processInfo.environment
        let bootstrapPaths = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        if let current = environment["PATH"] {
            environment["PATH"] = "\(bootstrapPaths):\(current)"
        }
        newProcess.environment = environment
        // -----------------------------
        
        newProcess.standardInput = stdinPipe
        newProcess.standardOutput = stdoutPipe
        newProcess.standardError = stdoutPipe
        
        let handle = stdoutPipe.fileHandleForReading
        handle.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let str = String(data: data, encoding: .utf8), !str.isEmpty {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.output += str
                    
                    // Rolling Window: Keep last 10,000 characters
                    if self.output.count > 10000 {
                        self.output = String(self.output.suffix(8000))
                    }
                }
            }
        }
        
        newProcess.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.output += "\n[Session Terminated]\n"
            }
        }
        
        do {
            try newProcess.run()
            self.process = newProcess
            self.isRunning = true
            
            // Auto-source manager config
            let managerPath = fileManager.homeDirectoryForCurrentUser
                .appendingPathComponent(".zsh_manager/main.zsh").path
            if fileManager.fileExists(atPath: managerPath) {
                sendInput("source \(managerPath)")
            }
            
        } catch {
            output += "Failed to start shell: \(error.localizedDescription)\n"
        }
    }
    
    /// Sends a command to the running persistent shell
    func sendInput(_ input: String) {
        guard isRunning else {
            startSession()
            // Wait a bit and retry
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.sendInput(input)
            }
            return
        }
        
        let command = input + "\n"
        if let data = command.data(using: .utf8) {
            try? stdinPipe.fileHandleForWriting.write(contentsOf: data)
        }
    }
    
    /// Legacy support for one-off commands (used by Wizard)
    func runCommand(_ command: String, silent: Bool = false, completion: ((String) -> Void)? = nil) {
        // For background detection, we still use a one-off process to avoid polluting the persistent shell
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        
        var env = ProcessInfo.processInfo.environment
        env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:" + (env["PATH"] ?? "")
        task.environment = env
        
        task.arguments = ["-ilc", command]
        task.standardOutput = pipe
        task.standardError = pipe
        
        if !silent { DispatchQueue.main.async { self.output += "\n> \(command)\n" } }
        
        let handle = pipe.fileHandleForReading
        var result = ""
        handle.readabilityHandler = { handle in
            let data = handle.availableData
            if let str = String(data: data, encoding: .utf8) {
                result += str
            }
        }
        
        task.terminationHandler = { _ in
            completion?(result.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        try? task.run()
    }
    
    func stop() {
        if let proc = process, proc.isRunning {
            proc.terminate()
        }
        stdoutPipe.fileHandleForReading.readabilityHandler = nil
        process = nil
        isRunning = false
    }
    
    func clear() {
        output = ""
    }
}
