import Foundation
import SwiftShell

enum DevEnvironment: String, CaseIterable, Identifiable {
    case homebrew = "Homebrew"
    case python = "Python"
    case node = "Node.js"
    case go = "Go"
    case rust = "Rust"
    case java = "Java"
    case gcc = "GCC"
    case flutter = "Flutter"
    case ruby = "Ruby"
    case php = "PHP"
    
    var id: String { rawValue }
    
    var binaryName: String {
        switch self {
        case .homebrew: return "brew"
        case .python: return "python3"
        case .node: return "node"
        case .go: return "go"
        case .rust: return "rustc"
        case .java: return "java"
        case .gcc: return "gcc"
        case .flutter: return "flutter"
        case .ruby: return "ruby"
        case .php: return "php"
        }
    }
}

struct EnvDetectionResult: Identifiable {
    let env: DevEnvironment
    let isInstalled: Bool
    let path: String?
    let version: String?
    
    var id: String { env.rawValue }
}

class EnvironmentDetector: ObservableObject {
    @Published var results: [EnvDetectionResult] = []
    @Published var isScanning = false
    @Published var fullScriptOutput = ""
    @Published var isRunningScript = false
    
    func runFullCheckScript() {
        isRunningScript = true
        fullScriptOutput = "Running analysis...\n"
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Dynamically resolve script path: try Bundle resources first (for released .app), 
            // then fallback to local relative path (for dev environment)
            var scriptPath: String? = nil
            
            if let bundledURL = Bundle.main.url(forResource: "check_env", withExtension: "sh", subdirectory: "scripts") {
                scriptPath = bundledURL.path
            } else {
                // Fallback for development/testing
                let devPath = "scripts/check_env.sh"
                if FileManager.default.fileExists(atPath: devPath) {
                    scriptPath = (devPath as NSString).expandingTildeInPath
                }
            }
            
            guard let actualPath = scriptPath else {
                DispatchQueue.main.async {
                    self.fullScriptOutput = "Error: check_env.sh not found in bundle or project root."
                    self.isRunningScript = false
                }
                return
            }
            
            // Set executable permission just in case
            _ = SwiftShell.run("/bin/chmod", "+x", actualPath)
            
            // Run script
            let scriptRes = SwiftShell.run("/bin/bash", actualPath, "--non-interactive", "--no-color")
            
            DispatchQueue.main.async {
                self.fullScriptOutput = scriptRes.stdout
                self.isRunningScript = false
            }
        }
    }

    func scan() {
        isScanning = true
        results = []
        
        let dispatchGroup = DispatchGroup()
        
        let commonPaths = [
            "/opt/homebrew/bin",
            "/usr/local/bin",
            "/usr/bin",
            "/bin",
            FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".nvm/versions/node").path,
            FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".fnm/bin").path,
            "/usr/local/share/npm/bin"
        ]
        
        for env in DevEnvironment.allCases {
            dispatchGroup.enter()
            
            DispatchQueue.global().async {
                // 1. Try 'which' first
                let pathRes = SwiftShell.run("/usr/bin/which", env.binaryName)
                var path = pathRes.succeeded ? pathRes.stdout.trimmingCharacters(in: .whitespacesAndNewlines) : nil
                
                // 2. If skip, search common paths
                if path == nil || path!.isEmpty {
                    for base in commonPaths {
                        // For NVM, we need to glob version folders
                        if base.contains(".nvm/versions/node") {
                            let enumerator = FileManager.default.enumerator(atPath: base)
                            while let folder = enumerator?.nextObject() as? String {
                                let fullPath = "\(base)/\(folder)/bin/\(env.binaryName)"
                                if FileManager.default.fileExists(atPath: fullPath) {
                                    path = fullPath
                                    break
                                }
                            }
                        } else {
                            let fullPath = "\(base)/\(env.binaryName)"
                            if FileManager.default.fileExists(atPath: fullPath) {
                                path = fullPath
                                break
                            }
                        }
                        if path != nil { break }
                    }
                }
                
                let isInstalled = path != nil
                var version: String? = nil
                
                if isInstalled {
                    // Use absolute path for version check to avoid shell issues
                    let versionRes = SwiftShell.run(path!, "--version")
                    version = versionRes.stdout.components(separatedBy: .newlines).first?.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if version == nil || version!.isEmpty {
                        let shortVersionRes = SwiftShell.run(path!, "-v")
                        version = shortVersionRes.stdout.components(separatedBy: .newlines).first?.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                
                DispatchQueue.main.async {
                    self.results.append(EnvDetectionResult(env: env, isInstalled: isInstalled, path: path, version: version))
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isScanning = false
            self.results.sort { $0.env.rawValue < $1.env.rawValue }
        }
    }
}
