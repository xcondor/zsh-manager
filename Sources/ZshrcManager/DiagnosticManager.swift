import Foundation

enum DiagnosticSeverity {
    case error, warning, info
}

struct DiagnosticIssue: Identifiable {
    let id = UUID()
    let category: String
    let message: String
    let severity: DiagnosticSeverity
    let suggestion: String?
}

class DiagnosticManager: ObservableObject {
    @Published var issues: [DiagnosticIssue] = []
    @Published var isRunning: Bool = false
    
    private let fileManager = FileManager.default
    
    func runDiagnostics(aliasManager: AliasManager, pathManager: PathManager, lang: LanguageManager) {
        isRunning = true
        issues = []
        
        // 1. Check .zshrc injection
        checkZshrc(lang: lang)
        
        // 2. Validate Paths (Detailed)
        validatePaths(pathManager: pathManager, lang: lang)
        
        // 3. Check for API Key placeholders
        checkApiKeys(aliasManager: aliasManager, lang: lang)
        
        // Simulating scan delay for smoother UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isRunning = false
        }
    }
    
    private func checkZshrc(lang: LanguageManager) {
        let zshrcPath = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(".zshrc").path
        if !fileManager.fileExists(atPath: zshrcPath) {
            issues.append(DiagnosticIssue(
                category: "Zshrc",
                message: ".zshrc file not found",
                severity: .error,
                suggestion: "Create ~/.zshrc if it's missing."
            ))
            return
        }
        
        do {
            let content = try String(contentsOfFile: zshrcPath)
            if !content.contains("zsh_manager/main.zsh") {
                issues.append(DiagnosticIssue(
                    category: "Zshrc", 
                    message: "Manager entry not found in .zshrc",
                    severity: .warning,
                    suggestion: "Go to Overview and click 'Inject' to enable management."
                ))
            }
        } catch {
            print("Failed to read .zshrc: \(error)")
        }
    }
    
    private func validatePaths(pathManager: PathManager, lang: LanguageManager) {
        let invalidPaths = pathManager.paths.filter { !$0.isValid && !($0.isDynamic ?? false) }
        
        for entry in invalidPaths {
            issues.append(DiagnosticIssue(
                category: "Path",
                message: "Missing directory: \(entry.path)",
                severity: .error,
                suggestion: "Verify the folder exists or remove it from Path Manager."
            ))
        }
        
        if pathManager.paths.count > 20 {
            issues.append(DiagnosticIssue(
                category: "Path",
                message: "High number of search paths (\(pathManager.paths.count))",
                severity: .info,
                suggestion: "Consider cleaning up unused paths to improve shell performance."
            ))
        }
    }
    
    private func checkApiKeys(aliasManager: AliasManager, lang: LanguageManager) {
        let placeholders = aliasManager.aliases.filter { $0.command.contains("YOUR_KEY_HERE") }
        
        for alias in placeholders {
            issues.append(DiagnosticIssue(
                category: "Environment",
                message: "API Key placeholder detected for [\(alias.name)]",
                severity: .warning,
                suggestion: "Fill in your real API Key in the Aliases page to use this tool."
            ))
        }
    }
}
