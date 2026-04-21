import Foundation

enum SafeFileWriterError: Error {
    case missingParentDirectory
    case replaceFailed
}

final class SafeFileWriter {
    static let shared = SafeFileWriter()
    
    private let fileManager = FileManager.default
    
    private var homeDir: URL { fileManager.homeDirectoryForCurrentUser }
    private var managerDir: URL { homeDir.appendingPathComponent(".zsh_manager") }
    private var backupsDir: URL { managerDir.appendingPathComponent("backups") }
    private var auditLogPath: URL { managerDir.appendingPathComponent("audit.log") }
    
    func writeFile(filePath: String, newContent: String, operation: String) throws -> String {
        let targetURL = URL(fileURLWithPath: filePath)
        let parent = targetURL.deletingLastPathComponent()
        guard fileManager.fileExists(atPath: parent.path) else { throw SafeFileWriterError.missingParentDirectory }
        
        try ensureDirectory(backupsDir)
        try ensureDirectory(managerDir)
        
        let beforeContent = (try? String(contentsOf: targetURL, encoding: .utf8)) ?? ""
        let backupURL = try createBackup(for: targetURL, beforeContent: beforeContent)
        
        let tmpURL = parent.appendingPathComponent(".tmp.\(targetURL.lastPathComponent).\(UUID().uuidString)")
        try newContent.write(to: tmpURL, atomically: true, encoding: .utf8)
        
        do {
            _ = try fileManager.replaceItemAt(targetURL, withItemAt: tmpURL, backupItemName: nil, options: .usingNewMetadataOnly)
            try appendAudit(operation: operation, filePath: filePath, backupPath: backupURL.path, beforeBytes: beforeContent.utf8.count, afterBytes: newContent.utf8.count)
        } catch {
            try? restoreBackup(targetURL: targetURL, backupURL: backupURL)
            throw SafeFileWriterError.replaceFailed
        }
        
        return backupURL.path
    }
    
    func restore(filePath: String, backupPath: String) throws {
        try restoreBackup(targetURL: URL(fileURLWithPath: filePath), backupURL: URL(fileURLWithPath: backupPath))
    }
    
    private func ensureDirectory(_ url: URL) throws {
        if !fileManager.fileExists(atPath: url.path) {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
    
    private func createBackup(for targetURL: URL, beforeContent: String) throws -> URL {
        let stamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let folder = backupsDir.appendingPathComponent(stamp)
        try ensureDirectory(folder)
        
        let backupURL = folder.appendingPathComponent(targetURL.lastPathComponent)
        if fileManager.fileExists(atPath: targetURL.path) {
            try? fileManager.removeItem(at: backupURL)
            try fileManager.copyItem(at: targetURL, to: backupURL)
        } else {
            try beforeContent.write(to: backupURL, atomically: true, encoding: .utf8)
        }
        return backupURL
    }
    
    private func restoreBackup(targetURL: URL, backupURL: URL) throws {
        if fileManager.fileExists(atPath: targetURL.path) {
            try? fileManager.removeItem(at: targetURL)
        }
        try fileManager.copyItem(at: backupURL, to: targetURL)
    }
    
    private func appendAudit(operation: String, filePath: String, backupPath: String, beforeBytes: Int, afterBytes: Int) throws {
        let stamp = ISO8601DateFormatter().string(from: Date())
        let record: [String: Any] = [
            "ts": stamp,
            "op": operation,
            "file": filePath,
            "backup": backupPath,
            "beforeBytes": beforeBytes,
            "afterBytes": afterBytes
        ]
        let data = try JSONSerialization.data(withJSONObject: record, options: [])
        let line = String(data: data, encoding: .utf8).map { $0 + "\n" } ?? ""
        
        if fileManager.fileExists(atPath: auditLogPath.path) {
            let handle = try FileHandle(forWritingTo: auditLogPath)
            handle.seekToEndOfFile()
            handle.write(line.data(using: .utf8) ?? Data())
            try handle.close()
        } else {
            try line.write(to: auditLogPath, atomically: true, encoding: .utf8)
        }
    }
}
