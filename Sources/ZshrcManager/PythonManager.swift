import Foundation
import SwiftShell

struct PythonVersion: Identifiable, Hashable {
    let id: String
    let isGlobal: Bool
    let isCurrent: Bool
}

class PythonManager: ObservableObject {
    @Published var installedVersions: [PythonVersion] = []
    @Published var availableVersions: [String] = []
    @Published var currentGlobalVersion: String = ""
    @Published var isInstalling = false
    @Published var installationOutput = ""
    @Published var isPyenvInstalled = false
    @Published var systemPythonVersion: String? = nil
    
    @Published var selectedMirror: String? = nil
    let mirrors = [
        "Default": nil,
        "Huawei Cloud": "https://mirrors.huaweicloud.com/python/",
        "Aliyun": "https://mirrors.aliyun.com/python/"
    ]
    
    @Published var pyenvPath: String = ""
    
    init() {}

    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.checkPyenv()
        }
    }
    
    func checkPyenv() {
        // 1. Try 'which' first
        var res = SwiftShell.run("/usr/bin/which", "pyenv")
        var path = res.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2. Fallback to common paths if 'which' fails
        if res.exitcode != 0 || path.isEmpty {
            let commonPaths = ["/opt/homebrew/bin", "/usr/local/bin", "/usr/bin", "/bin"]
            for base in commonPaths {
                let fullPath = "\(base)/pyenv"
                if FileManager.default.fileExists(atPath: fullPath) {
                    path = fullPath
                    res = SwiftShell.run(fullPath, "--version") // Just to get a valid success result
                    break
                }
            }
        }
        
        // Also check system python
        let sysPy = SwiftShell.run("/usr/bin/python3", "--version")
        let sysVer = sysPy.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "Python ", with: "")
        
        DispatchQueue.main.async {
            self.pyenvPath = path
            self.isPyenvInstalled = !self.pyenvPath.isEmpty
            self.systemPythonVersion = sysPy.exitcode == 0 ? sysVer : nil
            
            if self.isPyenvInstalled {
                self.refreshVersions()
            }
        }
    }
    
    func refreshVersions() {
        guard !pyenvPath.isEmpty else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            var context = CustomContext(main)
            let homebrewPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let existingPath = context.env["PATH"] {
                context.env["PATH"] = "\(homebrewPath):\(existingPath)"
            } else {
                context.env["PATH"] = homebrewPath
            }

            // 1. Get installed versions
            let versionsRes = context.run(self.pyenvPath, "versions", "--bare")
            let globalRes = context.run(self.pyenvPath, "global")
            let global = globalRes.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let installed = versionsRes.stdout.components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .map { version in
                    PythonVersion(id: version, isGlobal: version == global, isCurrent: version == global)
                }
            
            // 2. Get subset of available versions
            let allAvailRes = context.run(self.pyenvPath, "install", "--list")
            let avail = allAvailRes.stdout.components(separatedBy: .newlines)
                .filter { $0.trimmingCharacters(in: .whitespaces).prefix(1).first?.isNumber ?? false }
                .filter { !$0.contains("-") && !$0.contains("rc") && !$0.contains("dev") } // Pure versions only
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .suffix(10) // Show last 10 versions for simplicity
            
            DispatchQueue.main.async {
                self.installedVersions = installed
                self.availableVersions = Array(avail.reversed())
                self.currentGlobalVersion = global
            }
        }
    }
    
    func installVersion(_ version: String) {
        guard !pyenvPath.isEmpty else { return }
        isInstalling = true
        installationOutput = "Starting installation of Python \(version)...\n"
        
        DispatchQueue.global(qos: .userInitiated).async {
            var context = CustomContext(main)
            let homebrewPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let existingPath = context.env["PATH"] {
                context.env["PATH"] = "\(homebrewPath):\(existingPath)"
            } else {
                context.env["PATH"] = homebrewPath
            }
            
            // Apply mirror if selected
            if let mirror = self.selectedMirror {
                context.env["PYTHON_BUILD_MIRROR_URL"] = mirror
                DispatchQueue.main.async {
                    self.installationOutput += "Using mirror: \(mirror)\n"
                }
            }
            
            let process = context.runAsync(self.pyenvPath, "install", version)
            
            process.onCompletion { res in
                DispatchQueue.main.async {
                    self.isInstalling = false
                    self.installationOutput += "\nInstallation finished with exit code \(res.exitcode())\n"
                    self.refreshVersions()
                }
            }
            
            process.stdout.onOutput { stream in
                let output = stream.read()
                DispatchQueue.main.async { self.installationOutput += output }
            }
            
            process.stderror.onOutput { stream in
                let output = stream.read()
                DispatchQueue.main.async { self.installationOutput += output }
            }
        }
    }
    
    func setGlobal(_ version: String) {
        guard !pyenvPath.isEmpty else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            var context = CustomContext(main)
            let homebrewPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let existingPath = context.env["PATH"] {
                context.env["PATH"] = "\(homebrewPath):\(existingPath)"
            } else {
                context.env["PATH"] = homebrewPath
            }
            
            context.run(self.pyenvPath, "global", version)
            self.refreshVersions()
        }
    }
}
