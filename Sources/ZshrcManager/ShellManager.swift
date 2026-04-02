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
            // Looking for script in project structure
            let scriptPath = "/Users/xingyc/PROJECTS/zshrc-manager/scripts/check_config.sh"
            let run = SwiftShell.run("/bin/bash", scriptPath)
            
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
    
    func toggleLine(id: UUID) {
        if let index = configLines.firstIndex(where: { $0.id == id }) {
            configLines[index].isCommented.toggle()
            saveConfigLines()
            self.insights = ConfigAnalyzer.shared.analyze(lines: self.configLines)
            self.conflicts = ConfigAnalyzer.shared.detectConflicts(lines: self.configLines)
            refreshShell()
        }
    }
    
    func migrateAll() {
        // Ensure modular directory exists before migration
        if !fileManager.fileExists(atPath: managerDirPath.path) {
            try? fileManager.createDirectory(at: managerDirPath, withIntermediateDirectories: true)
        }
        
        var newLines = configLines
        var migratedCount = 0
        var steps: [MigrationStep] = []
        
        // Map insights to lines to ensure consistency between UI and migration
        for insight in insights {
            guard let lineIndex = newLines.firstIndex(where: { $0.id == insight.id }) else { continue }
            let line = newLines[lineIndex]
            
            // Skip already commented or previously moved items
            if line.isCommented || line.isManagerInjected { continue }
            
            var targetPath: URL? = nil
            // Use category-based routing
            switch insight.category {
            case "Alias", "Shortcut":
                targetPath = aliasesZshPath
            case "PATH":
                targetPath = pathsZshPath
            default:
                // Everything else (Environment, Development, Package Manager, Database, etc.)
                // Go into the environment bootstrap file
                targetPath = envZshPath
            }
            
            if let path = targetPath {
                do {
                    let entry = "\n# Migrated on \(Date())\n\(line.content)\n"
                    if fileManager.fileExists(atPath: path.path) {
                        let handle = try FileHandle(forWritingTo: path)
                        handle.seekToEndOfFile()
                        handle.write(entry.data(using: .utf8)!)
                        handle.closeFile()
                    } else {
                        try entry.write(to: path, atomically: true, encoding: .utf8)
                    }
                    
                    newLines[lineIndex].isCommented = true
                    migratedCount += 1
                    steps.append(MigrationStep(content: line.content, category: insight.category))
                } catch {
                    print("Migration failed for: \(line.content)")
                }
            }
        }
        
        if migratedCount > 0 {
            self.lastMigration = steps
            self.configLines = newLines
            saveConfigLines()
            refreshShell()
            loadConfigLines() 
        }
    }
    
    func undoMigration() {
        // Simple undo: uncomment all migrated lines in the current list
        // Note: This doesn't remove from modular files yet, but it restores functionality in .zshrc
        // For a full undo, we'd need to prune those files too. 
        // But for MVP, restoring visibility in .zshrc and clearing the log is safer.
        var newLines = configLines
        for step in lastMigration {
            if let index = newLines.firstIndex(where: { $0.content == step.content }) {
                newLines[index].isCommented = false
            }
        }
        
        self.configLines = newLines
        self.lastMigration = []
        saveConfigLines()
        refreshShell()
        loadConfigLines()
    }
    
    func saveConfigLines() {
        let content = configLines.map { line in
            if line.isCommented {
                return "# " + line.content
            } else {
                return line.content
            }
        }.joined(separator: "\n")
        
        do {
            try content.write(to: URL(fileURLWithPath: currentShellPath), atomically: true, encoding: .utf8)
            checkInstallationStatus()
        } catch {
            print("Failed to save config lines: \(error)")
        }
    }
    
    func refreshShell() {
        // Runs 'source' in the background. While it doesn't affect other windows, 
        // it verifies the config is valid and ensures the process environment is updated.
        let shell = currentShellPath.contains("zsh") ? "/bin/zsh" : "/bin/bash"
        _ = SwiftShell.run(shell, "-c", "source \(currentShellPath)")
    }

    func install() {
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
                """
                try initialContent.write(to: mainZshPath, atomically: true, encoding: .utf8)
            }
            
            let injectionLine = "source ~/.zsh_manager/main.zsh"
            var lines = configLines
            if !lines.contains(where: { $0.content.contains(injectionLine) }) {
                lines.append(ConfigLine(content: "", isCommented: false, isManagerInjected: true))
                lines.append(ConfigLine(content: "# Added by Zshrc Manager", isCommented: false, isManagerInjected: true))
                lines.append(ConfigLine(content: injectionLine, isCommented: false, isManagerInjected: true))
                self.configLines = lines
                saveConfigLines()
                refreshShell()
            }
            
            statusMessage = "Status_Success"
            isInstalled = true
        } catch {
            statusMessage = "Status_Failed"
        }
    }
    
    func uninstall() {
        configLines.removeAll { $0.isManagerInjected }
        saveConfigLines()
        refreshShell()
        statusMessage = "Status_Uninstall"
        isInstalled = false
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
