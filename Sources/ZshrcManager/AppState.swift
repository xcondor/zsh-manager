import Foundation
import Combine

// REMOVED ObservableObject to kill AttributeGraph cycles
class AppState {
    static let shared = AppState()
    
    let lang = LanguageManager()
    let shellManager = ShellManager()
    
    // Core Feature Managers
    let aliasManager = AliasManager()
    let pathManager = PathManager()
    
    // Auxiliary Managers
    let snapshotManager = SnapshotManager()
    let envDetector = EnvironmentDetector()
    let diagnosticManager = DiagnosticManager()
    let templateManager = TemplateManager()
    let serviceManager = ServiceManager()
    let pythonManager = PythonManager()
    let pluginManager = PluginManager()
    let terminalManager = TerminalManager()
    let terminalMaster = TerminalMasterManager()
    let aiManager = AIManager()
    let licenseManager = LicenseManager.shared
    let cloudSyncManager = CloudSyncManager.shared
    
    private init() {
        print("🚀 [AppState] Initialized core singleton.")
    }
    
    private var hasStarted = false
    
    private let startupQueue = DispatchQueue(label: "com.xingyc.zshrc-manager.startup", qos: .userInitiated)

    func startAll() {
        if hasStarted { return }
        hasStarted = true
        
        let startTimestamp = Date().timeIntervalSince1970
        print("⚡️ [AppState] Starting services at \(startTimestamp)...")
        
        // Use a serial background queue to prevent shell command collisions during boot
        startupQueue.async {
            print("⏳ [AppState] 1/8 Starting ShellManager...")
            self.shellManager.start()
            
            print("⏳ [AppState] 2/8 Starting AliasManager...")
            self.aliasManager.start()
            
            print("⏳ [AppState] 3/8 Starting PathManager...")
            self.pathManager.start()
            
            print("⏳ [AppState] 4/8 Starting PluginManager...")
            self.pluginManager.start()
            
            print("⏳ [AppState] 5/8 Starting ServiceManager...")
            self.serviceManager.checkAllStatus()
            
            print("⏳ [AppState] 6/8 Starting PythonManager...")
            self.pythonManager.start()
            
            print("⏳ [AppState] 7/8 Starting EnvironmentDetector...")
            self.envDetector.scan()
            
            print("⏳ [AppState] 8/8 Starting TerminalMaster...")
            self.terminalMaster.checkStatus()
            
            print("⏳ [AppState] 9/9 Starting CloudSyncManager...")
            self.cloudSyncManager.start()
            
            let endTimestamp = Date().timeIntervalSince1970
            print("✅ [AppState] Startup sequence completed in \(String(format: "%.2f", endTimestamp - startTimestamp))s.")
        }
    }
}
