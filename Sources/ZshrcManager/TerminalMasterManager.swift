import Foundation
import Combine
import SwiftShell

class TerminalMasterManager: ObservableObject {
    @Published var isP10kInstalled: Bool = false
    @Published var isOMZInstalled: Bool = false
    @Published var isFontInstalled: Bool = false
    
    @Published var showSuccess: Bool = false
    @Published var lastResultTitle: String = ""
    @Published var lastResultMessage: String = ""
    
    private let fileManager = FileManager.default
    private let homeDir = FileManager.default.homeDirectoryForCurrentUser
    
    init() {
        checkStatus()
    }
    
    func checkStatus() {
        let omzPath = homeDir.appendingPathComponent(".oh-my-zsh").path
        let p10kPath = homeDir.appendingPathComponent(".oh-my-zsh/custom/themes/powerlevel10k").path
        
        isOMZInstalled = fileManager.fileExists(atPath: omzPath)
        isP10kInstalled = fileManager.fileExists(atPath: p10kPath)
        
        // Font check: Very basic check for MesloLGS in ~/Library/Fonts
        let fontPath = homeDir.appendingPathComponent("Library/Fonts")
        if let fonts = try? fileManager.contentsOfDirectory(atPath: fontPath.path) {
            isFontInstalled = fonts.contains { $0.contains("MesloLGS") }
        }
    }
    
    /// Full beautify sequence coordination
    func runBoostSequence(serviceManager: ServiceManager) {
        self.showSuccess = false
        serviceManager.beginGlobalTask()
        checkStatus()
        
        let iterm2 = serviceManager.services.first(where: { $0.id == "iterm2" })
        let omz = serviceManager.services.first(where: { $0.id == "omz" })
        let font = serviceManager.services.first(where: { $0.id == "nerd-font" })
        
        func finishSequence(success: Bool = true) {
            // Ensure the loading state is visible for at least a moment even if everything is already done
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                serviceManager.endGlobalTask()
                self.checkStatus()
                
                // Show result
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.lastResultTitle = success ? "Success!" : "Done"
                    self.lastResultMessage = success ? "Terminal is now fully optimized." : "Process completed with some steps skipped."
                    self.showSuccess = true
                }
            }
        }
        
        func stepP10k() {
            self.applyBeautify(serviceManager: serviceManager) {
                finishSequence()
            }
        }
        
        func stepFont() {
            if !isFontInstalled, let s = font {
                serviceManager.install(service: s) { stepP10k() }
            } else {
                stepP10k()
            }
        }
        
        func stepOMZ() {
            if !isOMZInstalled, let s = omz {
                serviceManager.install(service: s) { stepFont() }
            } else {
                stepFont()
            }
        }
        
        func stepITerm() {
            let itermInstalled = serviceManager.installedIds.contains("iterm2")
            if !itermInstalled, let s = iterm2 {
                serviceManager.install(service: s) { stepOMZ() }
            } else {
                stepOMZ()
            }
        }
        
        stepITerm()
    }
    
    /// One-click beautify logic for theme and config
    func applyBeautify(serviceManager: ServiceManager, completion: (() -> Void)? = nil) {
        self.checkStatus()
        
        // 1. Install P10k if missing
        if !isP10kInstalled && isOMZInstalled {
            serviceManager.currentlyInstallingName = "Powerlevel10k"
            serviceManager.installationOutput += "Cloning Powerlevel10k theme...\n"
            
            DispatchQueue.global(qos: .userInitiated).async {
                let p10kRepo = "https://github.com/romkatv/powerlevel10k.git"
                let targetPath = self.homeDir.appendingPathComponent(".oh-my-zsh/custom/themes/powerlevel10k").path
                
                // Ensure parent directory exists
                let customThemesPath = self.homeDir.appendingPathComponent(".oh-my-zsh/custom/themes").path
                if !self.fileManager.fileExists(atPath: customThemesPath) {
                    try? self.fileManager.createDirectory(atPath: customThemesPath, withIntermediateDirectories: true)
                }
                
                let command = "export PATH=\"/opt/homebrew/bin:/usr/local/bin:$PATH\" && git clone --depth=1 \(p10kRepo) \"\(targetPath)\""
                
                let process = SwiftShell.runAsync("/bin/bash", "-c", command)
                
                process.stdout.onOutput { stream in
                    let out = stream.read()
                    DispatchQueue.main.async { serviceManager.installationOutput += out }
                }
                
                process.stderror.onOutput { stream in
                    let out = stream.read()
                    DispatchQueue.main.async { serviceManager.installationOutput += out }
                }

                process.onCompletion { res in
                    DispatchQueue.main.async {
                        if res.exitcode() == 0 {
                            serviceManager.installationOutput += "P10k cloned successfully.\n"
                            self.updateZshrc {
                                serviceManager.installationOutput += "Applied configurations to .zshrc\n"
                                self.checkStatus()
                                completion?()
                            }
                        } else {
                            serviceManager.installationOutput += "Failed to clone P10k. Exit code: \(res.exitcode())\n"
                            self.checkStatus()
                            completion?()
                        }
                    }
                }
            }
        } else if isOMZInstalled {
            // Already installed, just update config
            serviceManager.installationOutput += "Applying configurations to .zshrc...\n"
            self.updateZshrc {
                serviceManager.installationOutput += "Applied configurations to .zshrc\n"
                self.checkStatus()
                completion?()
            }
        } else {
            serviceManager.installationOutput += "Skipping P10k: Oh My Zsh not found.\n"
            completion?()
        }
    }
    
    private func updateZshrc(completion: @escaping () -> Void) {
        let zshrcPath = homeDir.appendingPathComponent(".zshrc")
        let beforeText = (try? String(contentsOf: zshrcPath, encoding: .utf8)) ?? ""
        var content = beforeText
        
        // Change ZSH_THEME
        if content.contains("ZSH_THEME=") {
            let regex = try? NSRegularExpression(pattern: "ZSH_THEME=\".*\"", options: [])
            content = regex?.stringByReplacingMatches(in: content, options: [], range: NSRange(location: 0, length: content.count), withTemplate: "ZSH_THEME=\"powerlevel10k/powerlevel10k\"") ?? content
        } else {
            content = "ZSH_THEME=\"powerlevel10k/powerlevel10k\"\n" + content
        }
        
        // Add P10k instant prompt if not present
        if !content.contains("p10k-instant-prompt") {
            let p10kHeader = """
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

"""
            content = p10kHeader + content
        }
        
        // If content didn't change, skip review
        if content == beforeText {
            completion()
            return
        }
        
        Task {
            let approved = await ChangeReviewManager.shared.requestApproval(title: "Terminal Master Update", filePath: zshrcPath.path, beforeText: beforeText, afterText: content)
            if approved {
                _ = try? SafeFileWriter.shared.writeFile(filePath: zshrcPath.path, newContent: content, operation: "Terminal Master Update")
            }
            await MainActor.run {
                completion()
            }
        }
    }
    /// Revert beautify changes
    func revertBeautify(serviceManager: ServiceManager, completion: (() -> Void)? = nil) {
        let zshrcPath = homeDir.appendingPathComponent(".zshrc")
        let beforeText = (try? String(contentsOf: zshrcPath, encoding: .utf8)) ?? ""
        var content = beforeText
        
        // Restore default theme
        if content.contains("ZSH_THEME=") {
            let regex = try? NSRegularExpression(pattern: "ZSH_THEME=\".*\"", options: [])
            content = regex?.stringByReplacingMatches(in: content, options: [], range: NSRange(location: 0, length: content.count), withTemplate: "ZSH_THEME=\"robbyrussell\"") ?? content
        }
        
        // Remove P10k instant prompt block
        let p10kPattern = "(?s)# Enable Powerlevel10k instant prompt.*?fi\\n\\n"
        if let regex = try? NSRegularExpression(pattern: p10kPattern, options: []) {
            content = regex.stringByReplacingMatches(in: content, options: [], range: NSRange(location: 0, length: content.count), withTemplate: "")
        }
        
        if content == beforeText {
            completion?()
            return
        }
        
        Task {
            let approved = await ChangeReviewManager.shared.requestApproval(title: "Revert Terminal Master", filePath: zshrcPath.path, beforeText: beforeText, afterText: content)
            if approved {
                _ = try? SafeFileWriter.shared.writeFile(filePath: zshrcPath.path, newContent: content, operation: "Revert Terminal Master")
            }
            await MainActor.run {
                self.checkStatus()
                completion?()
            }
        }
    }
}
