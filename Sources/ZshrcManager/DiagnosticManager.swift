import Foundation

enum DiagnosticSeverity: String, Codable {
    case critical, warning, info
}

struct DiagnosticIssue: Identifiable, Codable {
    let id: UUID
    let ruleId: String
    let category: String
    let title: String
    let description: String
    let severity: DiagnosticSeverity
    let suggestion: String
    var canFixAutomatically: Bool
    var targetLine: Int? // 关联的行号 (可选)
}

class DiagnosticManager: ObservableObject {
    @Published var issues: [DiagnosticIssue] = []
    @Published var isRunning: Bool = false
    @Published var healthScore: Int = 100
    
    private let fileManager = FileManager.default
    
    func runDiagnostics(shellManager: ShellManager, pathManager: PathManager, aliasManager: AliasManager, lang: LanguageManager) {
        DispatchQueue.main.async {
            self.isRunning = true
            self.issues = []
        }
        
        // 1. 检查环境变量重复导出 (PATH)
        checkDuplicatePaths(shellManager.configLines, lang: lang)
        
        // 2. 检查 .zshrc 注入状态
        checkZshrcInjection(shellManager.configLines, lang: lang)
        
        // 3. 检查 Homebrew 多次初始化 (性能杀手)
        checkMultipleBrewEnv(shellManager.configLines, lang: lang)
        
        // 4. 验证路径是否真的存在
        validatePaths(pathManager: pathManager, lang: lang)
        
        // 5. 检查启动阻塞模式 (如 curl/wget 在启动脚本中)
        checkSlowPatterns(shellManager.configLines, lang: lang)
        
        // 6. 启动耗时静态分析
        checkStartupPerformance(shellManager.configLines, lang: lang)
        
        // 7. 敏感信息扫描
        checkSecrets(shellManager: shellManager, lang: lang)
        
        // 模拟扫描动效
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.calculateScore()
            self.isRunning = false
        }
    }
    
    private func calculateScore() {
        var score = 100
        for issue in issues {
            switch issue.severity {
            case .critical: score -= 20
            case .warning: score -= 10
            case .info: score -= 2
            }
        }
        self.healthScore = max(0, score)
    }
    
    // --- 规则实现 ---
    
    private func checkDuplicatePaths(_ lines: [ConfigLine], lang: LanguageManager) {
        var pathsFound = Set<String>()
        for (index, line) in lines.enumerated() where !line.isCommented {
            if line.content.contains("export PATH=") && line.content.contains("/") {
                let parts = line.content.components(separatedBy: "=")
                if parts.count > 1 {
                    let pathValue = parts[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: "")
                    if pathsFound.contains(pathValue) {
                        issues.append(DiagnosticIssue(
                            id: UUID(),
                            ruleId: "PATH_DUP",
                            category: "Path",
                            title: lang.t("Diag_PathDup_Title"),
                            description: lang.t("Diag_PathDup_Desc") + pathValue,
                            severity: .warning,
                            suggestion: lang.t("Diag_PathDup_Sugg"),
                            canFixAutomatically: true,
                            targetLine: index
                        ))
                    }
                    pathsFound.insert(pathValue)
                }
            }
        }
    }
    
    private func checkZshrcInjection(_ lines: [ConfigLine], lang: LanguageManager) {
        let isManaged = lines.contains { $0.content.contains("zsh_manager/main.zsh") && !$0.isCommented }
        if !isManaged {
            issues.append(DiagnosticIssue(
                id: UUID(),
                ruleId: "NO_INJECTION",
                category: "Zshrc",
                title: lang.t("Diag_EngineOff_Title"),
                description: lang.t("Diag_EngineOff_Desc"),
                severity: .critical,
                suggestion: lang.t("Diag_EngineOff_Sugg"),
                canFixAutomatically: false
            ))
        }
    }
    
    private func checkMultipleBrewEnv(_ lines: [ConfigLine], lang: LanguageManager) {
        let brewEnvLines = lines.filter { !$0.isCommented && $0.content.contains("brew shellenv") }
        if brewEnvLines.count > 1 {
            issues.append(DiagnosticIssue(
                id: UUID(),
                ruleId: "BREW_ENV_MULT",
                category: "Performance",
                title: lang.t("Diag_BrewMult_Title"),
                description: lang.t("Diag_BrewMult_Desc"),
                severity: .critical,
                suggestion: lang.t("Diag_BrewMult_Sugg"),
                canFixAutomatically: true
            ))
        }
    }
    
    private func validatePaths(pathManager: PathManager, lang: LanguageManager) {
        let invalidPaths = pathManager.paths.filter { !$0.isValid && !($0.isDynamic ?? false) }
        for entry in invalidPaths {
            issues.append(DiagnosticIssue(
                id: UUID(),
                ruleId: "MISSING_DIR",
                category: "Path",
                title: lang.t("Diag_MissingDir_Title"),
                description: lang.t("Diag_MissingDir_Desc") + entry.path,
                severity: .warning,
                suggestion: lang.t("Diag_MissingDir_Sugg"),
                canFixAutomatically: true
            ))
        }
    }
    
    private func checkStartupPerformance(_ lines: [ConfigLine], lang: LanguageManager) {
        // 检查 NVM 这种极其缓慢的加载项
        let slowLoaders = [
            (pattern: "nvm.sh", name: "Node Version Manager (NVM)", suggestion: "Diag_Nvm_Sugg"),
            (pattern: "rbenv", name: "Ruby Environment (rbenv)", suggestion: "Diag_Rbenv_Sugg"),
            (pattern: "pyenv init", name: "Pyenv Initialization", suggestion: "Diag_Pyenv_Sugg")
        ]
        
        for (index, line) in lines.enumerated() where !line.isCommented {
            for loader in slowLoaders {
                if line.content.contains(loader.pattern) {
                    issues.append(DiagnosticIssue(
                        id: UUID(),
                        ruleId: "SLOW_INIT",
                        category: "Performance",
                        title: "\(lang.t("Slow Command Found")): \(loader.name)",
                        description: lang.t("Diag_SlowCmd_Desc"),
                        severity: .warning,
                        suggestion: lang.t(loader.suggestion),
                        canFixAutomatically: false,
                        targetLine: index
                    ))
                }
            }
        }
    }
    
    private func checkSlowPatterns(_ lines: [ConfigLine], lang: LanguageManager) {
        for (index, line) in lines.enumerated() where !line.isCommented {
            if (line.content.contains("curl") || line.content.contains("wget")) && !line.isManagerInjected {
                issues.append(DiagnosticIssue(
                    id: UUID(),
                    ruleId: "SLOW_IO",
                    category: "Performance",
                    title: lang.t("Diag_StartupBlock_Title"),
                    description: lang.t("Diag_StartupBlock_Desc"),
                    severity: .warning,
                    suggestion: lang.t("Diag_StartupBlock_Sugg"),
                    canFixAutomatically: false,
                    targetLine: index
                ))
            }
        }
    }
    
    private func checkSecrets(shellManager: ShellManager, lang: LanguageManager) {
        let configPath = shellManager.currentShellPath
        var findings: [SecretFinding] = []
        
        if !configPath.isEmpty {
            findings.append(contentsOf: SecretScanner.shared.scanFile(path: configPath))
        }
        findings.append(contentsOf: SecretScanner.shared.scanManagerDirectory())
        
        let grouped = Dictionary(grouping: findings, by: { $0.filePath })
        for (file, items) in grouped {
            let count = items.count
            let sample = items.prefix(3).map { f in
                if let line = f.lineNumber {
                    return "L\(line): \(f.preview)"
                }
                return f.preview
            }.joined(separator: "\n")
            
            issues.append(DiagnosticIssue(
                id: UUID(),
                ruleId: "SECRET_SCAN",
                category: "Security",
                title: lang.t("Privacy Risk Found"),
                description: "\(file)\n\n\(sample)\n\n\(lang.t("Detected Secrets")): \(count)",
                severity: .critical,
                suggestion: lang.t("Migrate to Keychain"),
                canFixAutomatically: false
            ))
        }
    }
    
    // --- Phase 3.0: 修复逻辑 ---
    
    func applyFix(for issue: DiagnosticIssue, shellManager: ShellManager) {
        guard issue.canFixAutomatically else { return }
        
        switch issue.ruleId {
        case "PATH_DUP", "BREW_ENV_MULT", "MISSING_DIR":
            if let lineIndex = issue.targetLine {
                shellManager.commentLine(at: lineIndex)
            }
        default:
            break
        }
    }
}
