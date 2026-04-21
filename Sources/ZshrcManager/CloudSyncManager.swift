import Foundation
import Combine

enum SyncStatus: String {
    case idle
    case syncing
    case success
    case error
}

class CloudSyncManager: ObservableObject {
    static let shared = CloudSyncManager()
    
    @Published var status: SyncStatus = .idle
    @Published var lastSyncDate: Date?
    @Published var isEnabled: Bool = false
    
    private let fileManager = FileManager.default
    private let kCloudSyncEnabled = "cloud_sync_enabled"
    
    // Local source
    private var aliasesJsonPath: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".zsh_manager/aliases.json")
    }
    
    // Cloud destination (simulation or using Ubiquity container if available)
    private var cloudFolder: URL? {
        // In a real sandboxed app with entitlements:
        // return fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        
        // For this non-sandboxed tool, we use a fallback hidden folder in iCloud Drive if it exists,
        // or just a "CloudSync" folder in the app's data dir for demonstration.
        let icloudDrive = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Library/Mobile Documents/com~apple~CloudDocs/ZshrcManager")
        
        if fileManager.fileExists(atPath: icloudDrive.path) {
            return icloudDrive
        }
        
        // Fallback to local sync simulation folder
        let localSync = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(".zsh_manager/cloud_sync")
        if !fileManager.fileExists(atPath: localSync.path) {
            try? fileManager.createDirectory(at: localSync, withIntermediateDirectories: true)
        }
        return localSync
    }
    
    private var cloudAliasesPath: URL? {
        cloudFolder?.appendingPathComponent("aliases.json")
    }
    
    private init() {
        self.isEnabled = UserDefaults.standard.bool(forKey: kCloudSyncEnabled)
    }
    
    func start() {
        guard isEnabled && LicenseManager.shared.isPro else { return }
        syncDown()
    }
    
    func toggleSync(enabled: Bool) {
        self.isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: kCloudSyncEnabled)
        if enabled {
            syncUp()
        }
    }
    
    /// Push local changes to cloud
    func syncUp() {
        guard isEnabled && LicenseManager.shared.isPro else { return }
        guard let cloudPath = cloudAliasesPath else { return }
        
        status = .syncing
        
        DispatchQueue.global(qos: .background).async {
            do {
                if self.fileManager.fileExists(atPath: self.aliasesJsonPath.path) {
                    // Ensure cloud directory exists
                    if let cloudDir = self.cloudFolder, !self.fileManager.fileExists(atPath: cloudDir.path) {
                        try self.fileManager.createDirectory(at: cloudDir, withIntermediateDirectories: true)
                    }
                    
                    // Simple overwrite for now, in production we'd do conflict resolution
                    if self.fileManager.fileExists(atPath: cloudPath.path) {
                        try self.fileManager.removeItem(at: cloudPath)
                    }
                    try self.fileManager.copyItem(at: self.aliasesJsonPath, to: cloudPath)
                    
                    DispatchQueue.main.async {
                        self.status = .success
                        self.lastSyncDate = Date()
                    }
                }
            } catch {
                print("❌ Cloud Sync Up Error: \(error)")
                DispatchQueue.main.async { self.status = .error }
            }
        }
    }
    
    /// Pull cloud changes to local
    func syncDown() {
        guard isEnabled && LicenseManager.shared.isPro else { return }
        guard let cloudPath = cloudAliasesPath, fileManager.fileExists(atPath: cloudPath.path) else { return }
        
        status = .syncing
        
        DispatchQueue.global(qos: .background).async {
            do {
                // In production, we'd compare timestamps or hashes
                // For now, if cloud is newer, pull it
                let cloudAttr = try self.fileManager.attributesOfItem(atPath: cloudPath.path)
                let localAttr = try? self.fileManager.attributesOfItem(atPath: self.aliasesJsonPath.path)
                
                let cloudDate = cloudAttr[.modificationDate] as? Date ?? Date.distantPast
                let localDate = localAttr?[.modificationDate] as? Date ?? Date.distantPast
                
                if cloudDate > localDate {
                    print("☁️ Cloud is newer, pulling...")
                    if self.fileManager.fileExists(atPath: self.aliasesJsonPath.path) {
                        try self.fileManager.removeItem(at: self.aliasesJsonPath)
                    }
                    try self.fileManager.copyItem(at: cloudPath, to: self.aliasesJsonPath)
                    
                    // Notify AliasManager to reload
                    DispatchQueue.main.async {
                        AppState.shared.aliasManager.load()
                        self.status = .success
                        self.lastSyncDate = Date()
                    }
                } else {
                    DispatchQueue.main.async { self.status = .idle }
                }
            } catch {
                print("❌ Cloud Sync Down Error: \(error)")
                DispatchQueue.main.async { self.status = .error }
            }
        }
    }
}
