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
                            title: lang.t("发现重复的 PATH 导出"),
                            description: "系统正在多次导出相同的路径段：\(pathValue)",
                            severity: .warning,
                            suggestion: lang.t("考虑移除冗余项以缩短 PATH 长度。"),
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
                title: lang.t("管理引擎未启用"),
                description: "您的 .zshrc 尚未引用 Zshrc Manager 的核心加载器。",
                severity: .critical,
                suggestion: lang.t("前往首页点击“一键接管”以开启完整功能。"),
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
                title: lang.t("Homebrew 多次初始化"),
                description: "检测到多次调用 'brew shellenv'。这会显著减慢终端启动速度。",
                severity: .critical,
                suggestion: lang.t("合并为单次调用以提升速度。"),
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
                title: lang.t("失效的搜索路径"),
                description: "目录不存在：\(entry.path)",
                severity: .warning,
                suggestion: lang.t("请移除该路径或确认目录是否已删除。"),
                canFixAutomatically: true
            ))
        }
    }
    
    private func checkSlowPatterns(_ lines: [ConfigLine], lang: LanguageManager) {
        for (index, line) in lines.enumerated() where !line.isCommented {
            if (line.content.contains("curl") || line.content.contains("wget")) && !line.isManagerInjected {
                issues.append(DiagnosticIssue(
                    id: UUID(),
                    ruleId: "SLOW_IO",
                    category: "Performance",
                    title: lang.t("潜在的启动阻塞"),
                    description: "启动脚本中包含同步网络请求，可能导致终端启动卡顿。",
                    severity: .warning,
                    suggestion: lang.t("建议将请求改为异步执行。"),
                    canFixAutomatically: false,
                    targetLine: index
                ))
            }
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
