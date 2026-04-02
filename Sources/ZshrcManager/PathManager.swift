import Foundation
import SwiftShell

struct PathEntry: Identifiable, Codable {
    var id: String { path }
    let path: String
    var isValid: Bool = true
    var isEnabled: Bool = true
    var isDynamic: Bool? = false // Optional to handle migration from old JSON
}

class PathManager: ObservableObject {
    @Published var paths: [PathEntry] = []
    
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

    /// Smart Resolver: Expands $HOME and ~ for validation purposes
    private func resolvePath(_ path: String) -> String {
        var resolved = path
        let home = fileManager.homeDirectoryForCurrentUser.path
        resolved = resolved.replacingOccurrences(of: "$HOME", with: home)
        return (resolved as NSString).expandingTildeInPath
    }

    func checkValidity() {
        var updatedPaths = paths
        for index in updatedPaths.indices {
            let original = updatedPaths[index].path
            
            // 1. Identify dynamic shell expressions (e.g. $(...) or `...`)
            if original.contains("$(") || original.contains("`") {
                updatedPaths[index].isDynamic = true
                updatedPaths[index].isValid = true // We assume dynamic paths are valid for the UI (trusting the user)
                continue
            }
            
            // 2. Expand and check literal paths
            let resolved = resolvePath(original)
            updatedPaths[index].isDynamic = false
            updatedPaths[index].isValid = fileManager.fileExists(atPath: resolved)
        }
        
        DispatchQueue.main.async {
            self.paths = updatedPaths
        }
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
