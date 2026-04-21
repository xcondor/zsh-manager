import Foundation
import SwiftShell

struct AliasDefinition: Identifiable, Codable {
    var id: String { name }
    let name: String
    let command: String
    var description: String?
}

class AliasManager: ObservableObject {
    @Published var aliases: [AliasDefinition] = []
    
    private let fileManager = FileManager.default
    private var aliasesZshPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/aliases.zsh")
    }
    
    // We'll store a JSON sidecar to preserve descriptions/metadata
    private var aliasesJsonPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/aliases.json")
    }

    init() {}

    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.load()
            // self.syncWithSession()
        }
    }

    func syncWithSession() {
        // Run alias in a shell to get the actual session state
        // The output format is usually: alias name='command'
        let aliasesString = SwiftShell.run("bash", "-c", "alias").stdout
        let lines = aliasesString.components(separatedBy: .newlines)
        
        var newAliases: [AliasDefinition] = []
        for line in lines {
            if line.isEmpty || !line.hasPrefix("alias ") { continue }
            
            // Clean the "alias " prefix
            let cleanLine = line.replacingOccurrences(of: "alias ", with: "")
            
            // Split by "="
            guard let eqIndex = cleanLine.firstIndex(of: "=") else { continue }
            let name = String(cleanLine[..<eqIndex]).trimmingCharacters(in: .whitespaces)
            let command = String(cleanLine[cleanLine.index(after: eqIndex)...])
                .trimmingCharacters(in: CharacterSet(charactersIn: "'\""))
            
            // Don't add if we already manage this name or it looks like a system one we don't want to mess with
            if !aliases.contains(where: { $0.name == name }) {
                newAliases.append(AliasDefinition(name: name, command: command, description: "System Detected"))
            }
        }
        
        if !newAliases.isEmpty {
            DispatchQueue.main.async {
                self.aliases.append(contentsOf: newAliases)
            }
        }
    }

    func load() {
        if fileManager.fileExists(atPath: aliasesJsonPath.path) {
            do {
                let data = try Data(contentsOf: aliasesJsonPath)
                let decoded = try JSONDecoder().decode([AliasDefinition].self, from: data)
                DispatchQueue.main.async {
                    self.aliases = decoded
                }
            } catch {
                print("Failed to load aliases metadata: \(error)")
            }
        }
    }

    func save() {
        // Ensure directory exists
        let dir = aliasesJsonPath.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        
        do {
            // 1. Save JSON sidecar
            let data = try JSONEncoder().encode(aliases)
            try data.write(to: aliasesJsonPath, options: .atomic)
            
            // 2. Compile to .zsh script
            let shellScript = aliases.map { alias in
                let desc = alias.description != nil ? "# \(alias.description!)\n" : ""
                return "\(desc)alias \(alias.name)='\(alias.command)'"
            }.joined(separator: "\n")
            
            let header = "# Managed by Zshrc Manager - Aliases\n\n"
            try (header + shellScript).write(to: aliasesZshPath, atomically: true, encoding: .utf8)
            
            // Trigger Cloud Sync if enabled
            CloudSyncManager.shared.syncUp()
            
        } catch {
            print("Failed to save aliases: \(error)")
        }
    }

    func addAlias(name: String, command: String, description: String? = nil) {
        let newAlias = AliasDefinition(name: name, command: command, description: description)
        if let index = aliases.firstIndex(where: { $0.name == name }) {
            aliases[index] = newAlias
        } else {
            aliases.append(newAlias)
        }
        save()
    }
    
    func updateAlias(oldName: String, name: String, command: String, description: String? = nil) {
        if oldName != name {
            // Remove the old entry if the name changed
            aliases.removeAll { $0.name == oldName }
        }
        addAlias(name: name, command: command, description: description)
    }

    func removeAlias(name: String) {
        aliases.removeAll { $0.name == name }
        save()
    }
}
