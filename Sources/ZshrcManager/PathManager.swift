import Foundation
import SwiftShell

enum PathSource: String, Codable {
    case system  // 来自 /etc/paths 或系统默认
    case managed // 本工具管理 (~/.zsh_manager/paths.zsh)
    case user    // 用户在 .zshrc 或其他地方手动定义
}

struct PathEntry: Identifiable, Codable {
    var id: String { "\(source.rawValue):\(path)" }
    let path: String
    var isValid: Bool = true
    var isEnabled: Bool = true
    var isDynamic: Bool? = false
    var source: PathSource = .managed
    var isShadowed: Bool = false // 是否被更高优先级的路径覆盖
    var sourceFile: String?    // 来源文件路径（如果有）
}

class PathManager: ObservableObject {
    @Published var paths: [PathEntry] = [] // 用户通过 UI 管理的路径
    @Published var sessionPaths: [PathEntry] = [] // 实时从会话中解析出的全量路径
    private let fileManager = FileManager.default
    private var pathsZshPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/paths.zsh")
    }
    
    private var pathsJsonPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/paths.json")
    }

    init() {}

    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.load()
            // self.syncWithSession()
            self.checkValidity()
        }
    }

    func syncWithSession() {
        // Run echo $PATH in a shell to get the actual session state
        let pathString = SwiftShell.run("bash", "-c", "echo $PATH").stdout
        let sessionPaths = pathString.split(separator: ":").map { String($0) }
        
        var newEntries: [PathEntry] = []
        for path in sessionPaths {
            if path.isEmpty { continue }
            
            // Check if we already manage this path
            if !paths.contains(where: { $0.path == path }) {
                // If it's not managed, it's a "System" or externally defined path
                newEntries.append(PathEntry(path: path, isValid: true, isEnabled: true, isDynamic: true))
            }
        }
        
        if !newEntries.isEmpty {
            DispatchQueue.main.async {
                self.paths.append(contentsOf: newEntries)
            }
        }
    }

    func load() {
        if fileManager.fileExists(atPath: pathsJsonPath.path) {
            do {
                let data = try Data(contentsOf: pathsJsonPath)
                paths = try JSONDecoder().decode([PathEntry].self, from: data)
            } catch {
                print("Failed to load paths metadata: \(error)")
            }
        }
    }

    /// 实时分析当前会话的 PATH 状态
    func refreshLivePath() {
        DispatchQueue.global(qos: .userInitiated).async {
            // 1. 获取系统默认路径 (来自 /etc/paths)
            let systemPaths = self.getSystemPaths()
            
            // 2. 获取当前会话的真实 PATH
            let pathString = SwiftShell.run("zsh", "-f", "-c", "echo $PATH").stdout
            let sessionRawPaths = pathString.split(separator: ":").map { String($0) }.filter { !$0.isEmpty }
            
            var analyzedPaths: [PathEntry] = []
            var seenPaths: Set<String> = []
            
            for rawPath in sessionRawPaths {
                let resolved = self.resolvePath(rawPath)
                let exists = FileManager.default.fileExists(atPath: resolved)
                let isShadowed = seenPaths.contains(resolved)
                
                // 识别来源
                var source: PathSource = .user
                if systemPaths.contains(rawPath) {
                    source = .system
                } else if self.paths.contains(where: { $0.path == rawPath }) {
                    source = .managed
                }
                
                analyzedPaths.append(PathEntry(
                    path: rawPath,
                    isValid: exists,
                    isEnabled: true,
                    isDynamic: rawPath.contains("$") || rawPath.contains("`"),
                    source: source,
                    isShadowed: isShadowed
                ))
                
                if exists {
                    seenPaths.insert(resolved)
                }
            }
            
            DispatchQueue.main.async {
                self.sessionPaths = analyzedPaths
            }
        }
    }
    
    private func getSystemPaths() -> [String] {
        let etcPaths = "/etc/paths"
        if let content = try? String(contentsOfFile: etcPaths) {
            return content.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespaces) }
        }
        return ["/usr/bin", "/bin", "/usr/sbin", "/sbin"]
    }

    /// 增强型路径解析：支持递归展开常用的环境变量
    private func resolvePath(_ path: String) -> String {
        var resolved = path
        let home = fileManager.homeDirectoryForCurrentUser.path
        resolved = resolved.replacingOccurrences(of: "$HOME", with: home)
        resolved = resolved.replacingOccurrences(of: "~", with: home)
        
        // 如果是相对路径
        if !resolved.hasPrefix("/") && !resolved.contains("$") {
            // 尝试在当前目录下查找（虽然在 PATH 中通常不推荐，但为了准确性）
        }
        
        return (resolved as NSString).expandingTildeInPath
    }

    func checkValidity() {
        // 更新用户管理的路径状态
        var updatedPaths = paths
        for index in updatedPaths.indices {
            let resolved = resolvePath(updatedPaths[index].path)
            updatedPaths[index].isValid = fileManager.fileExists(atPath: resolved)
        }
        
        DispatchQueue.main.async {
            self.paths = updatedPaths
        }
        
        // 同时刷新实时分析
        refreshLivePath()
    }

    func save() {
        // Ensure directory exists
        let dir = pathsJsonPath.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        
        do {
            let data = try JSONEncoder().encode(paths)
            try data.write(to: pathsJsonPath, options: .atomic)
            
            // Generate robust PATH script
            var lines: [String] = ["# Managed by Zshrc Manager - PATH"]
            
            let enabledPaths = paths.filter { $0.isEnabled }.map { $0.path }
            if !enabledPaths.isEmpty {
                let joinedPaths = enabledPaths.joined(separator: ":")
                lines.append("export PATH=\"\(joinedPaths):$PATH\"")
            }
            
            let shellScript = lines.joined(separator: "\n")
            try shellScript.write(to: pathsZshPath, atomically: true, encoding: .utf8)
            
        } catch {
            print("Failed to save paths: \(error)")
        }
    }

    func addPath(_ path: String) {
        if !paths.contains(where: { $0.path == path }) {
            let isDynamic = path.contains("$(") || path.contains("`")
            let resolved = resolvePath(path)
            let entry = PathEntry(
                path: path, 
                isValid: isDynamic ? true : fileManager.fileExists(atPath: resolved),
                isDynamic: isDynamic
            )
            paths.append(entry)
            save()
        }
    }

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        paths.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func removePath(_ path: String) {
        paths.removeAll { $0.path == path }
        save()
    }
}
