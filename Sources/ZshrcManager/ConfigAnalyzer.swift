import Foundation

struct ConfigInsight: Identifiable {
    let id: UUID // Maps to the ConfigLine.id
    let category: String
    let content: String
    let description: String
    let icon: String
    var isEnabled: Bool
}

struct ConfigConflict: Identifiable {
    let id = UUID()
    let type: ConflictType
    let key: String
    let lineIds: [UUID]
    let message: String
    
    enum ConflictType: String {
        case duplicateExport = "Duplicate Variable"
        case duplicateAlias = "Duplicate Alias"
        case redundantPath = "Redundant PATH"
    }
}

class ConfigAnalyzer {
    static let shared = ConfigAnalyzer()
    
    private let ruleMap: [String: (category: String, desc: String, icon: String)] = [
        "oh-my-zsh": ("Framework", "Terminal Framework: Oh My Zsh for themes and plugins", "terminal.fill"),
        "nvm": ("Development", "Node.js Management: Version control for JavaScript runtime", "node_logo"), // Note: icon names simplified
        "flutter": ("Development", "Mobile SDK: Flutter cross-platform app development", "iphone"),
        "openjdk": ("Development", "Java Environment: JDK support for JVM applications", "cup.and.saucer.fill"),
        "JAVA_HOME": ("Environment", "Java Home: Points to the current active Java SDK", "cup.and.saucer.fill"),
        "pnpm": ("Package Manager", "pnpm: Efficient, disk-space-saving package manager", "shippingbox.fill"),
        "mongodb": ("Database", "MongoDB: NoSQL database service", "externaldrive.fill"),
        "postgresql": ("Database", "PostgreSQL: Advanced relational database service", "externaldrive.fill"),
        "LC_ALL": ("System", "Terminal Locale: Ensures UTF-8 encoding for text/symbols", "globe"),
        "LANG": ("System", "Terminal Locale: Sets system language for terminal output", "globe"),
        "alias": ("Shortcut", "Command Alias: Simplifies long terminal instructions", "bolt.fill"),
        "source": ("Loader", "Tool Injection: Loads external configuration or plugins", "arrow.down.doc.fill"),
        "chromedriver": ("Testing", "Browser Automation: Support for automated web testing", "web.camera.fill"),
        "antigravity": ("AI Tool", "Antigravity CLI: Integrated AI coding assistant", "sparkles"),
        "windsurf": ("Editor", "Windsurf CLI: Command line tools for Windsurf editor", "square.and.pencil")
    ]
    
    func analyze(lines: [ConfigLine]) -> [ConfigInsight] {
        var insights: [ConfigInsight] = []
        let keywords = ["alias", "export", "source", "plugins="]
        
        for line in lines {
            let trimmed = line.content.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }
            
            // Basic filtering for core config
            let isCore = keywords.contains { trimmed.hasPrefix($0) } || trimmed.hasPrefix(".")
            if !isCore { continue }
            
            var found = false
            for (key, info) in ruleMap {
                if trimmed.localizedCaseInsensitiveContains(key) {
                    insights.append(ConfigInsight(
                        id: line.id,
                        category: info.category,
                        content: trimmed,
                        description: trimmed.descriptionMapping(trimmed, original: info.desc),
                        icon: info.icon,
                        isEnabled: !line.isCommented
                    ))
                    found = true
                    break
                }
            }
            
            // Generic catch for common patterns if no specific rule matched
            if !found {
                if trimmed.hasPrefix("alias") {
                    insights.append(ConfigInsight(id: line.id, category: "Alias", content: trimmed, description: "Command efficiency: Custom terminal shortcut", icon: "bolt.fill", isEnabled: !line.isCommented))
                } else if trimmed.hasPrefix("export PATH") {
                    insights.append(ConfigInsight(id: line.id, category: "PATH", content: trimmed, description: "Tool Path: Adds external commands to terminal", icon: "folder.fill", isEnabled: !line.isCommented))
                } else if trimmed.hasPrefix("export") {
                    insights.append(ConfigInsight(id: line.id, category: "Environment", content: trimmed, description: "System Variable: Configures application environment", icon: "gearshape.fill", isEnabled: !line.isCommented))
                }
            }
        }
        
        return insights
    }
    
    func detectConflicts(lines: [ConfigLine]) -> [ConfigConflict] {
        var conflicts: [ConfigConflict] = []
        var exports: [String: [UUID]] = [:]
        var aliases: [String: [UUID]] = [:]
        
        for line in lines {
            if line.isCommented { continue }
            let trimmed = line.content.trimmingCharacters(in: .whitespaces)
            
            // Detect Exports
            if trimmed.hasPrefix("export "), let eqIndex = trimmed.firstIndex(of: "=") {
                let key = String(trimmed.prefix(upTo: eqIndex).replacingOccurrences(of: "export ", with: "").trimmingCharacters(in: .whitespaces))
                exports[key, default: []].append(line.id)
            }
            
            // Detect Aliases
            if trimmed.hasPrefix("alias "), let eqIndex = trimmed.firstIndex(of: "=") {
                let key = String(trimmed.prefix(upTo: eqIndex).replacingOccurrences(of: "alias ", with: "").trimmingCharacters(in: .whitespaces))
                aliases[key, default: []].append(line.id)
            }
        }
        
        // Build Conflict Reports
        for (key, ids) in exports where ids.count > 1 && key != "PATH" {
            conflicts.append(ConfigConflict(
                type: .duplicateExport,
                key: key,
                lineIds: ids,
                message: NSLocalizedString("Variable '\(key)' is defined \(ids.count) times. The last definition takes precedence.", comment: "")
            ))
        }
        
        for (key, ids) in aliases where ids.count > 1 {
            conflicts.append(ConfigConflict(
                type: .duplicateAlias,
                key: key,
                lineIds: ids,
                message: NSLocalizedString("Alias '\(key)' is redefined multiple times. This may cause confusion.", comment: "")
            ))
        }
        
        return conflicts
    }
}

extension String {
    fileprivate func descriptionMapping(_ trimmed: String, original: String) -> String {
        // We could add more logic here if needed, or stick to simple mapping
        return original
    }
}
