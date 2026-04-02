import Foundation

struct Snapshot: Identifiable, Codable {
    var id: String { timestamp }
    let timestamp: String
    let name: String
    let date: Date
}

class SnapshotManager: ObservableObject {
    @Published var snapshots: [Snapshot] = []
    
    private let fileManager = FileManager.default
    private var managerDirPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager")
    }
    
    private var snapshotsDirPath: URL {
        managerDirPath.appendingPathComponent("snapshots")
    }

    init() {
        ensureSnapshotDirectory()
        loadSnapshots()
    }

    private func ensureSnapshotDirectory() {
        if !fileManager.fileExists(atPath: snapshotsDirPath.path) {
            do {
                try fileManager.createDirectory(at: snapshotsDirPath, withIntermediateDirectories: true)
            } catch {
                print("Failed to create snapshots directory: \(error)")
            }
        }
    }

    func loadSnapshots() {
        do {
            let contents = try fileManager.contentsOfDirectory(at: snapshotsDirPath, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
            
            snapshots = contents.compactMap { url -> Snapshot? in
                var isDir: ObjCBool = false
                guard fileManager.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue else { return nil }
                
                let timestamp = url.lastPathComponent
                let attributes = try? fileManager.attributesOfItem(atPath: url.path)
                let date = attributes?[.creationDate] as? Date ?? Date()
                
                return Snapshot(timestamp: timestamp, name: "Snapshot \(timestamp)", date: date)
            }.sorted(by: { $0.date > $1.date })
            
        } catch {
            print("Failed to load snapshots: \(error)")
        }
    }

    func createSnapshot(name: String? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        let snapshotURL = snapshotsDirPath.appendingPathComponent(timestamp)
        
        do {
            try fileManager.createDirectory(at: snapshotURL, withIntermediateDirectories: true)
            
            // Files to backup
            let filesToBackup = [
                "aliases.zsh", "aliases.json",
                "paths.zsh", "paths.json",
                "env.zsh", "env.json",
                "main.zsh"
            ]
            
            for fileName in filesToBackup {
                let sourceFile = managerDirPath.appendingPathComponent(fileName)
                let destFile = snapshotURL.appendingPathComponent(fileName)
                
                if fileManager.fileExists(atPath: sourceFile.path) {
                    try fileManager.copyItem(at: sourceFile, to: destFile)
                }
            }
            
            loadSnapshots()
        } catch {
            print("Failed to create snapshot: \(error)")
        }
    }

    func restoreSnapshot(_ snapshot: Snapshot) {
        let snapshotURL = snapshotsDirPath.appendingPathComponent(snapshot.timestamp)
        
        do {
            let filesToRestore = try fileManager.contentsOfDirectory(at: snapshotURL, includingPropertiesForKeys: nil)
            
            for sourceFile in filesToRestore {
                let fileName = sourceFile.lastPathComponent
                let destFile = managerDirPath.appendingPathComponent(fileName)
                
                if fileManager.fileExists(atPath: destFile.path) {
                    try fileManager.removeItem(at: destFile)
                }
                try fileManager.copyItem(at: sourceFile, to: destFile)
            }
            
            // Reload all managers would be ideal via a notification or delegate
        } catch {
            print("Failed to restore snapshot: \(error)")
        }
    }
    
    func deleteSnapshot(_ snapshot: Snapshot) {
        let snapshotURL = snapshotsDirPath.appendingPathComponent(snapshot.timestamp)
        do {
            try fileManager.removeItem(at: snapshotURL)
            loadSnapshots()
        } catch {
            print("Failed to delete snapshot: \(error)")
        }
    }
}
