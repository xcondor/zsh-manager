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
                description: "基于历史记录的实时补全建议",
                brewName: "zsh-autosuggestions",
                gitUrl: "https://github.com/zsh-users/zsh-autosuggestions",
                initLine: "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh",
                usage: "直接输入命令即可看到灰色建议，按 → 键采纳",
                testCommand: "echo \"zsh-autosuggestions 需要交互式终端：打开真实 Terminal/iTerm2，输入你历史用过的命令即可看到灰色建议。\""
            ),
            PluginDefinition(
                id: "syntax-highlighting",
                name: "zsh-syntax-highlighting",
                description: "终端命令实时合法性高亮 (绿色/红色)",
                brewName: "zsh-syntax-highlighting",
                gitUrl: "https://github.com/zsh-users/zsh-syntax-highlighting",
                initLine: "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh",
                usage: "命令合法显示为绿色，非法显示为红色",
                testCommand: "echo \"zsh-syntax-highlighting 需要交互式终端：打开真实 Terminal/iTerm2，输入 ls 与 invalidcommand 观察高亮颜色变化。\""
            ),
            PluginDefinition(
                id: "thefuck",
                name: "thefuck",
                description: "神奇的命令纠错工具，如果你敲错了，输入 fuck 自动修复",
                brewName: "thefuck",
                gitUrl: "https://github.com/nvbn/thefuck",
                initLine: "eval \"$(thefuck --alias)\"",
                usage: "输入错命令后，输入 fuck 即可获得修改建议并自动执行",
                testCommand: "thefuck --version"
            ),
            PluginDefinition(
                id: "zoxide",
                name: "zoxide (z)",
                description: "更高级的 cd 方式，智能跳转到你常用的目录",
                brewName: "zoxide",
                gitUrl: "https://github.com/ajeetdsouza/zoxide",
                initLine: "eval \"$(zoxide init zsh)\"",
                usage: "输入 z 目录名 即可极速跳转，无需输入完整路径",
                testCommand: "zoxide --help | head -n 20"
            ),
            PluginDefinition(
                id: "tldr",
                name: "tldr",
                description: "最实用的命令说明书，直接给你看案例而不是冗长的文档",
                brewName: "tldr",
                gitUrl: "https://github.com/tldr-pages/tldr",
                initLine: "alias help=\"tldr\"",
                usage: "输入 help 命令 (如 help tar) 快速查看最常用的示例",
                testCommand: "tldr tar | head -n 30"
            ),
            PluginDefinition(
                id: "extract",
                name: "extract",
                description: "万用解压工具，无论是 zip, tar 还是 gz，一键解压",
                brewName: nil, // Built-in OMZ plugin
                gitUrl: nil,
                initLine: "plugins+=(extract)",
                usage: "输入 x 文件名 即可解压任何类型的压缩包",
                testCommand: "echo \"extract 需要实际压缩包文件：打开真实终端并执行 x your.zip（或 x your.tar.gz）。\""
            ),
            PluginDefinition(
                id: "sudo",
                name: "sudo",
                description: "快速补齐 sudo，双击 ESC 即可让上条命令获得管理员权限",
                brewName: nil, // Built-in OMZ plugin
                gitUrl: nil,
                initLine: "plugins+=(sudo)",
                usage: "命令权限不足？双击 ESC 键自动在行首添加 sudo",
                testCommand: "echo \"sudo 插件是按键绑定：打开真实终端，输入任意命令后双击 ESC 观察是否自动补齐 sudo。\""
            ),
            PluginDefinition(
                id: "eza",
                name: "eza (Modern ls)",
                description: "现代版 ls，带图标、色彩和更好的格式展示",
                brewName: "eza",
                gitUrl: "https://github.com/eza-community/eza",
                initLine: "alias ls=\"eza --icons --group-directories-first\"; alias ll=\"eza -lbF --icons\"; alias la=\"eza -lbhHigUmuSa --icons\"",
                usage: "输入 ls 查看整洁的图标列表，输入 ll 查看详细信息",
                testCommand: "eza --version"
            ),
            PluginDefinition(
                id: "bat",
                name: "bat (Modern cat)",
                description: "现代版 cat，带语法高亮、行号和 Git 状态集成",
                brewName: "bat",
                gitUrl: "https://github.com/sharkdp/bat",
                initLine: "alias cat=\"bat\"",
                usage: "输入 cat 文件名 享受代码高亮般的阅读体验",
                testCommand: "bat --version"
            ),
            PluginDefinition(
                id: "fzf-tab",
                name: "fzf-tab",
                description: "将 Tab 补全菜单替换为强大的模糊搜索界面",
                brewName: "fzf-tab",
                gitUrl: "https://github.com/Aloxaf/fzf-tab",
                initLine: "source $(brew --prefix)/share/fzf-tab/fzf-tab.plugin.zsh",
                usage: "按 Tab 键开启增强型模糊搜索列表",
                testCommand: "echo \"fzf-tab 需要交互式终端：打开真实 Terminal/iTerm2，输入 cd 然后按 TAB 触发 fzf 补全菜单。\""
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
