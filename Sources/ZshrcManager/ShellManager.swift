import SwiftUI
import SwiftShell

struct ConfigLine: Identifiable, Codable {
    let id: UUID
    var content: String
    var isCommented: Bool
    var isManagerInjected: Bool
    
    init(id: UUID = UUID(), content: String, isCommented: Bool, isManagerInjected: Bool) {
        self.id = id
        self.content = content
        self.isCommented = isCommented
        self.isManagerInjected = isManagerInjected
    }
}

class ShellManager: ObservableObject {
    private let fileManager = FileManager.default
    
    @Published var isInstalled: Bool = false
    @Published var statusMessage: String = "Ready"
    @Published var configLines: [ConfigLine] = []
    @Published var currentShellPath: String = ""
    @Published var checkConfigOutput: String = ""
    @Published var isCheckingConfig: Bool = false
    @Published var detectedConfigPath: String = ""
    @Published var insights: [ConfigInsight] = []
    @Published var conflicts: [ConfigConflict] = []
    @Published var lastMigration: [MigrationStep] = []
    
    struct MigrationStep: Identifiable, Codable {
        var id = UUID()
        let content: String
        let category: String
    }
    
    var detectedConfigFileName: String {
        return detectedConfigPath.replacingOccurrences(of: "~/", with: "")
    }
    
    private var homeDir: URL { fileManager.homeDirectoryForCurrentUser }
    private var managerDirPath: URL { homeDir.appendingPathComponent(".zsh_manager") }
    private var mainZshPath: URL { managerDirPath.appendingPathComponent("main.zsh") }
    private var aliasesZshPath: URL { managerDirPath.appendingPathComponent("aliases.zsh") }
    private var envZshPath: URL { managerDirPath.appendingPathComponent("env.zsh") }
    private var pathsZshPath: URL { managerDirPath.appendingPathComponent("paths.zsh") }
    
    init() {}

    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            let path = self.detectShellSynchronously()
            
            // Now load using the determined path
            self.checkInstallationStatus(at: path)
            self.loadConfigLines(at: path)
            
            // Finally update UI properties
            DispatchQueue.main.async {
                self.currentShellPath = path
                self.detectedConfigPath = "~/" + (URL(fileURLWithPath: path).lastPathComponent)
            }
        }
    }
    
    private func detectShellSynchronously() -> String {
        let zshrc = homeDir.appendingPathComponent(".zshrc")
        let bashProfile = homeDir.appendingPathComponent(".bash_profile")
        let bashrc = homeDir.appendingPathComponent(".bashrc")
        
        if fileManager.fileExists(atPath: zshrc.path) {
            return zshrc.path
        } else if fileManager.fileExists(atPath: bashProfile.path) {
            return bashProfile.path
        } else if fileManager.fileExists(atPath: bashrc.path) {
            return bashrc.path
        } else {
            return zshrc.path
        }
    }

    func runCheckConfig() {
        isCheckingConfig = true
        checkConfigOutput = ""
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Dynamically resolve script path: try Bundle resources first (for released .app), 
            // then fallback to local relative path (for dev environment)
            var scriptPath: String? = nil
            
            if let bundledURL = Bundle.main.url(forResource: "check_config", withExtension: "sh", subdirectory: "scripts") {
                scriptPath = bundledURL.path
            } else {
                // Fallback for development/testing
                let devPath = "/Users/xingyc/PROJECTS/zshrc-manager/scripts/check_config.sh"
                if FileManager.default.fileExists(atPath: devPath) {
                    scriptPath = devPath
                }
            }
            
            guard let actualPath = scriptPath else {
                DispatchQueue.main.async {
                    self.checkConfigOutput = "Error: check_config.sh not found in bundle or project root."
                    self.isCheckingConfig = false
                }
                return
            }
            
            let run = SwiftShell.run("/bin/bash", actualPath)
            
            DispatchQueue.main.async {
                self.checkConfigOutput = run.stdout.removingANSIEscapeCodes()
                self.isCheckingConfig = false
                
                // Extra logic to extract file name from script conclusion if possible, 
                // but we already use detectShell() which is robust.
            }
        }
    }
    
    func checkInstallationStatus(at path: String? = nil) {
        let actualPath = path ?? currentShellPath
        guard !actualPath.isEmpty, fileManager.fileExists(atPath: mainZshPath.path) else {
            DispatchQueue.main.async { self.isInstalled = false }
            return
        }
        
        do {
            let content = try String(contentsOf: URL(fileURLWithPath: actualPath), encoding: .utf8)
            let installed = content.contains("source ~/.zsh_manager/main.zsh")
            DispatchQueue.main.async { self.isInstalled = installed }
        } catch {
            DispatchQueue.main.async { self.isInstalled = false }
        }
    }
    
    func loadConfigLines(at path: String? = nil) {
        let actualPath = path ?? currentShellPath
        guard !actualPath.isEmpty, fileManager.fileExists(atPath: actualPath) else { return }
        
        do {
            let content = try String(contentsOf: URL(fileURLWithPath: actualPath), encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            let configLines = lines.map { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                let isCommented = trimmed.hasPrefix("#")
                let isManaged = line.contains("source ~/.zsh_manager/main.zsh") || line.contains("# Added by Zshrc Manager")
                
                var cleanContent = line
                if isCommented {
                    cleanContent = line.replacingFirstOccurrence(of: "# ", with: "").replacingFirstOccurrence(of: "#", with: "")
                }
                
                return ConfigLine(content: cleanContent, isCommented: isCommented, isManagerInjected: isManaged)
            }
            
            let insights = ConfigAnalyzer.shared.analyze(lines: configLines)
            let conflicts = ConfigAnalyzer.shared.detectConflicts(lines: configLines)
            
            DispatchQueue.main.async {
                self.configLines = configLines
                self.insights = insights
                self.conflicts = conflicts
            }
        } catch {
            print("Failed to load config lines: \(error)")
        }
    }
    
    // --- Phase 3.0: 自动修复能力 ---
    
    func commentLine(at index: Int) {
        Task {
            await applyConfigMutation(operation: "Comment Line") { lines in
                guard index >= 0 && index < lines.count else { return }
                lines[index].isCommented = true
            }
        }
    }
    
    func appendLine(_ content: String, isManaged: Bool = true) {
        Task {
            await applyConfigMutation(operation: "Append Line") { lines in
                let newLine = ConfigLine(content: content, isCommented: false, isManagerInjected: isManaged)
                lines.append(newLine)
            }
        }
    }
    
    func saveConfig() {
        Task { await persistCurrentConfig(operation: "Save Config") }
    }
    
    func toggleLine(id: UUID) {
        Task {
            await applyConfigMutation(operation: "Toggle Line") { lines in
                if let index = lines.firstIndex(where: { $0.id == id }) {
                    lines[index].isCommented.toggle()
                }
            }
        }
    }
    
    func migrateAll() {
        Task { await migrateAllAsync() }
    }
    
    func undoMigration() {
        Task {
            let oldSteps = await MainActor.run { self.lastMigration }
            await applyConfigMutation(operation: "Undo Migration") { lines in
                for step in oldSteps {
                    if let index = lines.firstIndex(where: { $0.content == step.content }) {
                        lines[index].isCommented = false
                    }
                }
            }
            await MainActor.run { self.lastMigration = [] }
        }
    }
    
    func saveConfigLines() {
        Task { await persistCurrentConfig(operation: "Save Config Lines") }
    }
    
    func refreshShell() {
        // Runs 'source' in the background to verify the config is valid and 
        // ensure the process environment is updated without blocking the UI.
        let shell = currentShellPath.contains("zsh") ? "/bin/zsh" : "/bin/bash"
        let path = currentShellPath
        
        DispatchQueue.global(qos: .background).async {
            _ = SwiftShell.run(shell, "-c", "source \(path)")
        }
    }

    func install() {
        Task { await installAsync() }
    }
    
    func uninstall() {
        Task { await uninstallAsync() }
    }
    
    private func serialize(_ lines: [ConfigLine]) -> String {
        lines.map { line in
            line.isCommented ? "# " + line.content : line.content
        }.joined(separator: "\n")
    }
    
    private func persistCurrentConfig(operation: String) async {
        let lines = await MainActor.run { self.configLines }
        _ = await commitConfigLines(operation: operation, proposedLines: lines, title: operation)
    }
    
    private func applyConfigMutation(operation: String, mutate: (inout [ConfigLine]) -> Void) async {
        let existing = await MainActor.run { self.configLines }
        var updated = existing
        mutate(&updated)
        let path = await MainActor.run { self.currentShellPath }
        if path.isEmpty { return }
        _ = await commitConfigLines(operation: operation, proposedLines: updated, title: operation)
    }
    
    private func commitConfigLines(operation: String, proposedLines: [ConfigLine], title: String) async -> Bool {
        let path = await MainActor.run { self.currentShellPath }
        guard !path.isEmpty else { return false }
        
        let beforeText = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
        let afterText = serialize(proposedLines)
        
        let approved = await ChangeReviewManager.shared.requestApproval(title: title, filePath: path, beforeText: beforeText, afterText: afterText)
        guard approved else { return false }
        
        do {
            _ = try SafeFileWriter.shared.writeFile(filePath: path, newContent: afterText, operation: operation)
            await MainActor.run {
                self.configLines = proposedLines
                self.insights = ConfigAnalyzer.shared.analyze(lines: proposedLines)
                self.conflicts = ConfigAnalyzer.shared.detectConflicts(lines: proposedLines)
                self.checkInstallationStatus(at: path)
            }
            refreshShell()
            return true
        } catch {
            await MainActor.run { self.statusMessage = "Status_Failed" }
            return false
        }
    }
    
    private func installAsync() async {
        do {
            if !fileManager.fileExists(atPath: managerDirPath.path) {
                try fileManager.createDirectory(at: managerDirPath, withIntermediateDirectories: true)
            }
            
            if !fileManager.fileExists(atPath: mainZshPath.path) {
                let initialContent = """
                # Zshrc Manager Main Loader
                # This file is managed by Zshrc Manager App.
                [[ -f ~/.zsh_manager/aliases.zsh ]] && source ~/.zsh_manager/aliases.zsh
                [[ -f ~/.zsh_manager/env.zsh ]] && source ~/.zsh_manager/env.zsh
                [[ -f ~/.zsh_manager/paths.zsh ]] && source ~/.zsh_manager/paths.zsh
                [[ -f ~/.zsh_manager/plugins.zsh ]] && source ~/.zsh_manager/plugins.zsh
                """
                try initialContent.write(to: mainZshPath, atomically: true, encoding: .utf8)
            }
            
            let injectionLine = "source ~/.zsh_manager/main.zsh"
            let existing = await MainActor.run { self.configLines }
            var updated = existing
            if !updated.contains(where: { $0.content.contains(injectionLine) }) {
                updated.append(ConfigLine(content: "", isCommented: false, isManagerInjected: true))
                updated.append(ConfigLine(content: "# Added by Zshrc Manager", isCommented: false, isManagerInjected: true))
                updated.append(ConfigLine(content: injectionLine, isCommented: false, isManagerInjected: true))
            }
            
            let ok = await commitConfigLines(operation: "Install Injection", proposedLines: updated, title: "Install Injection")
            if ok {
                await MainActor.run { self.statusMessage = "Status_Success" }
            }
        } catch {
            await MainActor.run { self.statusMessage = "Status_Failed" }
        }
    }
    
    private func uninstallAsync() async {
        let existing = await MainActor.run { self.configLines }
        let updated = existing.filter { !$0.isManagerInjected }
        let ok = await commitConfigLines(operation: "Uninstall Injection", proposedLines: updated, title: "Uninstall Injection")
        if ok {
            await MainActor.run { self.statusMessage = "Status_Uninstall" }
        }
    }
    
    private func migrateAllAsync() async {
        if !fileManager.fileExists(atPath: managerDirPath.path) {
            try? fileManager.createDirectory(at: managerDirPath, withIntermediateDirectories: true)
        }
        
        let existing = await MainActor.run { self.configLines }
        let snapshotInsights = await MainActor.run { self.insights }
        
        var newLines = existing
        var migratedCount = 0
        var steps: [MigrationStep] = []
        
        var fileEdits: [URL: String] = [:]
        let stamp = ISO8601DateFormatter().string(from: Date())
        
        for insight in snapshotInsights {
            guard let lineIndex = newLines.firstIndex(where: { $0.id == insight.id }) else { continue }
            let line = newLines[lineIndex]
            if line.isCommented || line.isManagerInjected { continue }
            
            let targetPath: URL
            switch insight.category {
            case "Alias", "Shortcut":
                targetPath = aliasesZshPath
            case "PATH":
                targetPath = pathsZshPath
            default:
                targetPath = envZshPath
            }
            
            let before = fileEdits[targetPath] ?? (try? String(contentsOf: targetPath, encoding: .utf8)) ?? ""
            let entry = "\n# Migrated on \(stamp)\n\(line.content)\n"
            fileEdits[targetPath] = before + entry
            
            newLines[lineIndex].isCommented = true
            migratedCount += 1
            steps.append(MigrationStep(content: line.content, category: insight.category))
        }
        
        if migratedCount == 0 { return }
        
        let path = await MainActor.run { self.currentShellPath }
        let beforeText = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
        let afterText = serialize(newLines)
        
        let approved = await ChangeReviewManager.shared.requestApproval(title: "Migrate to Modules", filePath: path, beforeText: beforeText, afterText: afterText)
        guard approved else { return }
        
        var backups: [(file: String, backup: String)] = []
        do {
            for (url, after) in fileEdits {
                let backup = try SafeFileWriter.shared.writeFile(filePath: url.path, newContent: after, operation: "Migrate Module")
                backups.append((file: url.path, backup: backup))
            }
            
            let mainBackup = try SafeFileWriter.shared.writeFile(filePath: path, newContent: afterText, operation: "Migrate Main Config")
            backups.append((file: path, backup: mainBackup))
            
            await MainActor.run {
                self.lastMigration = steps
                self.configLines = newLines
                self.insights = ConfigAnalyzer.shared.analyze(lines: newLines)
                self.conflicts = ConfigAnalyzer.shared.detectConflicts(lines: newLines)
                self.checkInstallationStatus(at: path)
            }
            refreshShell()
        } catch {
            for item in backups.reversed() {
                try? SafeFileWriter.shared.restore(filePath: item.file, backupPath: item.backup)
            }
            await MainActor.run { self.statusMessage = "Status_Failed" }
        }
    }
}

extension String {
    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = self.range(of: target) else { return self }
        return self.replacingCharacters(in: range, with: replacement)
    }
    
    func removingANSIEscapeCodes() -> String {
        let pattern = #"[\u{001B}\u{009B}]\[[0-9;]*[mGKF]"#
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }
}
