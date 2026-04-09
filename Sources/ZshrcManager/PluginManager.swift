import Foundation
import SwiftShell

struct PluginDefinition: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let brewName: String?
    let gitUrl: String?
    let initLine: String
    var isEnabled: Bool = false
    var isInstalled: Bool = false
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
    }
    
    func loadPresets() {
        self.plugins = [
            PluginDefinition(
                id: "autosuggestions",
                name: "zsh-autosuggestions",
                description: "基于历史记录的实时补全建议",
                brewName: "zsh-autosuggestions",
                gitUrl: "https://github.com/zsh-users/zsh-autosuggestions",
                initLine: "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
            ),
            PluginDefinition(
                id: "syntax-highlighting",
                name: "zsh-syntax-highlighting",
                description: "终端命令实时合法性高亮 (绿色/红色)",
                brewName: "zsh-syntax-highlighting",
                gitUrl: "https://github.com/zsh-users/zsh-syntax-highlighting",
                initLine: "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
            ),
            PluginDefinition(
                id: "fzf-tab",
                name: "fzf-tab",
                description: "将 Tab 补全菜单替换为模糊搜索界面",
                brewName: "fzf-tab",
                gitUrl: "https://github.com/Aloxaf/fzf-tab",
                initLine: "source $(brew --prefix)/share/fzf-tab/fzf-tab.plugin.zsh"
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
        checkInstallation()
    }
    
    func checkInstallation() {
        for i in 0..<plugins.count {
            if let brewName = plugins[i].brewName {
                let check = SwiftShell.run("brew", "list", brewName).exitcode == 0
                plugins[i].isInstalled = check
            }
        }
    }
    
    func togglePlugin(_ id: String) {
        if let index = plugins.firstIndex(where: { $0.id == id }) {
            plugins[index].isEnabled.toggle()
            save()
        }
    }
    
    func installPlugin(_ id: String, completion: @escaping (Bool) -> Void) {
        guard let index = plugins.firstIndex(where: { $0.id == id }),
              let brewName = plugins[index].brewName else { return }
        
        isInstalling = true
        DispatchQueue.global(qos: .userInitiated).async {
            let result = SwiftShell.run("brew", "install", brewName)
            DispatchQueue.main.async {
                self.isInstalling = false
                if result.exitcode == 0 {
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
