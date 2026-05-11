import Foundation
import SwiftShell

struct PluginDefinition: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let brewName: String?
    let gitUrl: String?
    let initLine: String
    let usage: String
    let testCommand: String
    var isEnabled: Bool = false
    var isInstalled: Bool = false
    var isInstalling: Bool = false
}

class PluginManager: ObservableObject {
    @Published var plugins: [PluginDefinition] = []
    @Published var isInstalling: Bool = false
    
    private let fileManager = FileManager.default
    private var pluginsZshPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/plugins.zsh")
    }
    
    private var configPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/plugins.json")
    }
    
    init() {
        loadPresets()
        loadState()
        // CRITICAL BUG FIX: checkInstallation() removed from init() to prevent main thread crash
    }
    
    func start() {
        // Run initial check on background thread
        DispatchQueue.global(qos: .background).async {
            self.checkInstallation()
        }
    }
    
    func loadPresets() {
        self.plugins = [
            PluginDefinition(
                id: "autosuggestions",
                name: "zsh-autosuggestions",
                description: "Plugin_Autosuggestions_Desc",
                brewName: "zsh-autosuggestions",
                gitUrl: "https://github.com/zsh-users/zsh-autosuggestions",
                initLine: "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh",
                usage: "Plugin_Autosuggestions_Usage",
                testCommand: "Plugin_Autosuggestions_Test"
            ),
            PluginDefinition(
                id: "syntax-highlighting",
                name: "zsh-syntax-highlighting",
                description: "Plugin_SyntaxHighlighting_Desc",
                brewName: "zsh-syntax-highlighting",
                gitUrl: "https://github.com/zsh-users/zsh-syntax-highlighting",
                initLine: "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh",
                usage: "Plugin_SyntaxHighlighting_Usage",
                testCommand: "Plugin_SyntaxHighlighting_Test"
            ),
            PluginDefinition(
                id: "thefuck",
                name: "thefuck",
                description: "Plugin_TheFuck_Desc",
                brewName: "thefuck",
                gitUrl: "https://github.com/nvbn/thefuck",
                initLine: "eval \"$(thefuck --alias)\"",
                usage: "Plugin_TheFuck_Usage",
                testCommand: "thefuck --version"
            ),
            PluginDefinition(
                id: "zoxide",
                name: "zoxide (z)",
                description: "Plugin_Zoxide_Desc",
                brewName: "zoxide",
                gitUrl: "https://github.com/ajeetdsouza/zoxide",
                initLine: "eval \"$(zoxide init zsh)\"",
                usage: "Plugin_Zoxide_Usage",
                testCommand: "zoxide --help | head -n 20"
            ),
            PluginDefinition(
                id: "tldr",
                name: "tldr",
                description: "Plugin_Tldr_Desc",
                brewName: "tldr",
                gitUrl: "https://github.com/tldr-pages/tldr",
                initLine: "alias help=\"tldr\"",
                usage: "Plugin_Tldr_Usage",
                testCommand: "tldr tar | head -n 30"
            ),
            PluginDefinition(
                id: "extract",
                name: "extract",
                description: "Plugin_Extract_Desc",
                brewName: nil, // Built-in OMZ plugin
                gitUrl: nil,
                initLine: "plugins+=(extract)",
                usage: "Plugin_Extract_Usage",
                testCommand: "Plugin_Extract_Test"
            ),
            PluginDefinition(
                id: "sudo",
                name: "sudo",
                description: "Plugin_Sudo_Desc",
                brewName: nil, // Built-in OMZ plugin
                gitUrl: nil,
                initLine: "plugins+=(sudo)",
                usage: "Plugin_Sudo_Usage",
                testCommand: "Plugin_Sudo_Test"
            ),
            PluginDefinition(
                id: "eza",
                name: "eza (Modern ls)",
                description: "Plugin_Eza_Desc",
                brewName: "eza",
                gitUrl: "https://github.com/eza-community/eza",
                initLine: "alias ls=\"eza --icons --group-directories-first\"; alias ll=\"eza -lbF --icons\"; alias la=\"eza -lbhHigUmuSa --icons\"",
                usage: "Plugin_Eza_Usage",
                testCommand: "eza --version"
            ),
            PluginDefinition(
                id: "bat",
                name: "bat (Modern cat)",
                description: "Plugin_Bat_Desc",
                brewName: "bat",
                gitUrl: "https://github.com/sharkdp/bat",
                initLine: "alias cat=\"bat\"",
                usage: "Plugin_Bat_Usage",
                testCommand: "bat --version"
            ),
            PluginDefinition(
                id: "fzf-tab",
                name: "fzf-tab",
                description: "Plugin_FzfTab_Desc",
                brewName: "fzf-tab",
                gitUrl: "https://github.com/Aloxaf/fzf-tab",
                initLine: "source $(brew --prefix)/share/fzf-tab/fzf-tab.plugin.zsh",
                usage: "Plugin_FzfTab_Usage",
                testCommand: "Plugin_FzfTab_Test"
            )
        ]
    }

    
    func loadState() {
        if fileManager.fileExists(atPath: configPath.path) {
            if let data = try? Data(contentsOf: configPath),
               let saved = try? JSONDecoder().decode([String: Bool].self, from: data) {
                for i in 0..<plugins.count {
                    plugins[i].isEnabled = saved[plugins[i].id] ?? false
                }
            }
        }
    }
    
    func checkInstallation() {
        // Find brew binary first to avoid relying on generic PATH
        let brewPaths = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew", "/usr/bin/brew"]
        var brewBinary: String? = nil
        for path in brewPaths {
            if FileManager.default.fileExists(atPath: path) {
                brewBinary = path
                break
            }
        }
        
        guard let brew = brewBinary else {
            print("⚠️ [PluginManager] Homebrew not found, skipping installation check.")
            return
        }
        
        var updatedPlugins = self.plugins
        for i in 0..<updatedPlugins.count {
            if let brewName = updatedPlugins[i].brewName {
                let check = SwiftShell.run(brew, "list", brewName).exitcode == 0
                updatedPlugins[i].isInstalled = check
            }
        }
        
        DispatchQueue.main.async {
            self.plugins = updatedPlugins
        }
    }
    
    func togglePlugin(_ id: String) {
        if let index = plugins.firstIndex(where: { $0.id == id }) {
            plugins[index].isEnabled.toggle()
            save()
        }
    }
    
    func installPlugin(_ id: String, onOutput: @escaping (String) -> Void, completion: @escaping (Bool) -> Void) {
        guard let index = plugins.firstIndex(where: { $0.id == id }),
              let brewName = plugins[index].brewName else { return }
        
        DispatchQueue.main.async {
            self.plugins[index].isInstalling = true
            self.isInstalling = true
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Find brew binary again to be safe
            let brew = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew", "/usr/bin/brew"].first { FileManager.default.fileExists(atPath: $0) } ?? "brew"
            
            let command = CustomContext(main).runAsync(brew, "install", brewName)
            
            command.stdout.onOutput { stream in
                let out = stream.read()
                DispatchQueue.main.async { onOutput(out) }
            }
            
            command.stderror.onOutput { stream in
                let out = stream.read()
                DispatchQueue.main.async { onOutput(out) }
            }
            
            command.onCompletion { res in
                DispatchQueue.main.async {
                    self.isInstalling = false
                    self.plugins[index].isInstalling = false
                    if res.exitcode() == 0 {
                        self.plugins[index].isInstalled = true
                        self.plugins[index].isEnabled = true
                        self.save()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func save() {
        // 保存状态到 JSON
        var state: [String: Bool] = [:]
        for p in plugins { state[p.id] = p.isEnabled }
        if let data = try? JSONEncoder().encode(state) {
            try? data.write(to: configPath)
        }
        
        // 生成 plugins.zsh
        var lines = ["# Managed by Zshrc Manager - Plugins"]
        for p in plugins where p.isEnabled && p.isInstalled {
            lines.append(p.initLine)
        }
        
        let content = lines.joined(separator: "\n")
        try? content.write(to: pluginsZshPath, atomically: true, encoding: .utf8)
    }
}
