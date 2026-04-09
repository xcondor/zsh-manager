import Foundation
import Combine

// REMOVED ObservableObject to kill AttributeGraph cycles
class AppState {
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
    
    init() {}
    
    func startAll() {
        // Sequentially start managers on the main thread to avoid race conditions
        DispatchQueue.main.async {
            self.shellManager.start()
            self.aliasManager.start()
            self.pathManager.start()
            // Some managers load data lazily or on demand
        }
    }
}
