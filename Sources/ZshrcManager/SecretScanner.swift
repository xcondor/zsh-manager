import Foundation

struct SecretFinding: Identifiable, Hashable {
    let id: UUID
    let filePath: String
    let lineNumber: Int?
    let kind: String
    let preview: String
    
    init(id: UUID = UUID(), filePath: String, lineNumber: Int?, kind: String, preview: String) {
        self.id = id
        self.filePath = filePath
        self.lineNumber = lineNumber
        self.kind = kind
        self.preview = preview
    }
}

final class SecretScanner {
    static let shared = SecretScanner()
    
    private let patterns: [(kind: String, regex: NSRegularExpression)] = [
        ("KeyAssignment", try! NSRegularExpression(pattern: #"(?i)\b(export\s+)?[A-Z0-9_]*(KEY|TOKEN|SECRET|PASSWORD)\s*="#)),
        ("OpenAIKey", try! NSRegularExpression(pattern: #"sk-[A-Za-z0-9]{16,}"#)),
        ("AWSAccessKey", try! NSRegularExpression(pattern: #"AKIA[0-9A-Z]{16}"#)),
        ("GoogleAPIKey", try! NSRegularExpression(pattern: #"AIza[0-9A-Za-z\-_]{30,}"#))
    ]
    
    func scanFile(path: String) -> [SecretFinding] {
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else { return [] }
        return scanText(text, filePath: path)
    }
    
    func scanText(_ text: String, filePath: String) -> [SecretFinding] {
        let lines = text.components(separatedBy: .newlines)
        var findings: [SecretFinding] = []
        
        for (idx, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("#") || trimmed.isEmpty { continue }
            
            for p in patterns {
                if p.regex.firstMatch(in: line, range: NSRange(location: 0, length: (line as NSString).length)) != nil {
                    findings.append(SecretFinding(
                        filePath: filePath,
                        lineNumber: idx + 1,
                        kind: p.kind,
                        preview: Self.redact(line)
                    ))
                    break
                }
            }
        }
        
        return findings
    }
    
    func scanManagerDirectory() -> [SecretFinding] {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let dir = home.appendingPathComponent(".zsh_manager").path
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: dir, isDirectory: &isDir), isDir.boolValue else { return [] }
        
        let exts = Set(["zsh", "json"])
        let enumerator = FileManager.default.enumerator(atPath: dir)
        var findings: [SecretFinding] = []
        
        while let rel = enumerator?.nextObject() as? String {
            let url = URL(fileURLWithPath: dir).appendingPathComponent(rel)
            if url.lastPathComponent.hasPrefix(".") { continue }
            let ext = url.pathExtension.lowercased()
            if !ext.isEmpty, !exts.contains(ext) { continue }
            if rel.contains("/snapshots/") || rel.contains("/backups/") { continue }
            findings.append(contentsOf: scanFile(path: url.path))
        }
        
        return findings
    }
    
    private static func redact(_ line: String) -> String {
        let maxLen = 140
        let clipped = line.count > maxLen ? String(line.prefix(maxLen)) + "…" : line
        if let eq = clipped.firstIndex(of: "=") {
            let left = clipped[..<clipped.index(after: eq)]
            return "\(left) <redacted>"
        }
        return clipped
    }
}

