import Foundation
import SwiftUI
import SwiftShell

struct EssentialService: Identifiable {
    let id: String
    let name: String
    let icon: String
    let description: String
    let checkCommand: String
    let installCommand: String
    let tips: String
}

struct InstallScriptReview: Identifiable {
    let id: UUID
    let service: EssentialService
    let url: String
    let scriptText: String
    let interpreter: String
    
    init(id: UUID = UUID(), service: EssentialService, url: String, scriptText: String, interpreter: String) {
        self.id = id
        self.service = service
        self.url = url
        self.scriptText = scriptText
        self.interpreter = interpreter
    }
}

class ServiceManager: ObservableObject {
    @Published var services: [EssentialService] = [
        EssentialService(
            id: "brew",
            name: "Homebrew",
            icon: "shippingbox.fill",
            description: "The Missing Package Manager",
            checkCommand: "which brew",
            installCommand: "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
            tips: "Essential for all other tools"
        ),
        EssentialService(
            id: "nvm",
            name: "NVM",
            icon: "list.number",
            description: "Node Version Manager",
            checkCommand: "[ -d ~/.nvm ]",
            installCommand: "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash",
            tips: "Manage multiple Node.js versions easily"
        ),
        EssentialService(
            id: "node",
            name: "Node.js",
            icon: "leaf.fill",
            description: "JavaScript runtime",
            checkCommand: "which node",
            installCommand: "brew install node",
            tips: "Essential for modern web development"
        ),
        EssentialService(
            id: "omz",
            name: "Oh My Zsh",
            icon: "terminal.fill",
            description: "Popular framework for Zsh",
            checkCommand: "[ -d ~/.oh-my-zsh ]",
            installCommand: "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"",
            tips: "Beautiful themes and plugins"
        ),
        EssentialService(
            id: "rust",
            name: "Rust",
            icon: "hammer.fill",
            description: "Rust Language Environment",
            checkCommand: "which rustc",
            installCommand: "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y",
            tips: "Modern and memory-safe"
        ),
        EssentialService(
            id: "docker",
            name: "Docker",
            icon: "whale.fill",
            description: "Modern containerization",
            checkCommand: "which docker",
            installCommand: "brew install --cask docker",
            tips: "Run apps in consistent containers"
        ),
        EssentialService(
            id: "pyenv",
            name: "Pyenv",
            icon: "pyramid.fill",
            description: "Python Version Manager",
            checkCommand: "which pyenv",
            installCommand: "brew install pyenv",
            tips: "Manage multiple Python versions easily"
        ),
        EssentialService(
            id: "pnpm",
            name: "pnpm",
            icon: "shippingbox",
            description: "Fast package manager",
            checkCommand: "which pnpm",
            installCommand: "curl -fsSL https://get.pnpm.io/install.sh | sh -",
            tips: "Advanced node package manager"
        ),
        EssentialService(
            id: "bun",
            name: "Bun",
            icon: "bolt.fill",
            description: "Fast all-in-one JS toolkit",
            checkCommand: "which bun",
            installCommand: "curl -fsSL https://bun.sh/install | bash",
            tips: "Drop-in replacement for Node.js"
        ),
        EssentialService(
            id: "golang",
            name: "Go",
            icon: "circle.grid.hex.fill",
            description: "Go Language Environment",
            checkCommand: "which go",
            installCommand: "brew install go",
            tips: "Build fast, reliable, and efficient software"
        ),
        EssentialService(
            id: "deno",
            name: "Deno",
            icon: "leaf.arrow.triangle.circlepath",
            description: "Modern JS/TS runtime",
            checkCommand: "which deno",
            installCommand: "curl -fsSL https://deno.land/install.sh | sh",
            tips: "Secure by default runtime"
        ),
        EssentialService(
            id: "gh",
            name: "GitHub CLI",
            icon: "network",
            description: "GitHub on the command line",
            checkCommand: "which gh",
            installCommand: "brew install gh",
            tips: "Bring pull requests and issues to your terminal"
        ),
        EssentialService(
            id: "java",
            name: "Java (OpenJDK)",
            icon: "cup.and.saucer.fill",
            description: "Java Development Kit",
            checkCommand: "java -version",
            installCommand: "brew install openjdk",
            tips: "Standard platform for Java development"
        ),
        EssentialService(
            id: "iterm2",
            name: "iTerm2",
            icon: "terminal",
            description: "Powerful terminal replacement",
            checkCommand: "[ -d /Applications/iTerm.app ]",
            installCommand: "brew install --cask iterm2",
            tips: "Superior terminal experience for macOS"
        ),
        EssentialService(
            id: "nerd-font",
            name: "Meslo Nerd Font",
            icon: "textformat.size",
            description: "Font with glyphs for terminal icons",
            checkCommand: "[ -d ~/Library/Fonts ] && ls ~/Library/Fonts | grep -i 'MesloLGS'",
            installCommand: "brew install --cask font-meslo-lg-nerd-font",
            tips: "Required for P10k icons to display correctly"
        )
    ]
    
    @Published var installationOutput: String = ""
    @Published var isInstalling: Bool = false
    @Published var currentlyInstallingName: String = ""
    @Published var installedIds: Set<String> = []
    @Published var pendingInstallReview: InstallScriptReview? = nil
    @Published var isFetchingScript: Bool = false
    
    // Global lock support for multi-step sequences
    private var isGlobalTaskActive: Bool = false
    
    func beginGlobalTask() {
        self.isGlobalTaskActive = true
        self.isInstalling = true
    }
    
    func endGlobalTask() {
        self.isGlobalTaskActive = false
        self.isInstalling = false
    }
    
    func checkAllStatus() {
        DispatchQueue.global(qos: .userInitiated).async {
            var newlyInstalled: Set<String> = []
            let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
            
            var context = CustomContext(main)
            let homebrewPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let existingPath = context.env["PATH"] {
                context.env["PATH"] = "\(homebrewPath):\(existingPath)"
            } else {
                context.env["PATH"] = homebrewPath
            }
            
            for service in self.services {
                let cmd = service.checkCommand.replacingOccurrences(of: "~", with: homeDir)
                let res = context.run("/bin/bash", "-c", cmd)
                if res.exitcode == 0 {
                    newlyInstalled.insert(service.id)
                }
            }
            
            DispatchQueue.main.async {
                self.installedIds = newlyInstalled
            }
        }
    }
    
    func install(service: EssentialService, completion: (() -> Void)? = nil) {
        if let parsed = parseRemoteScript(from: service.installCommand) {
            fetchInstallScript(service: service, urlString: parsed.url, interpreter: parsed.interpreter)
            return
        }
        
        self.isInstalling = true
        self.currentlyInstallingName = service.name
        self.installationOutput = "Starting installation of \(service.name)...\n"
        
        DispatchQueue.global(qos: .userInitiated).async {
            var context = CustomContext(main)
            let homebrewPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let existingPath = context.env["PATH"] {
                context.env["PATH"] = "\(homebrewPath):\(existingPath)"
            } else {
                context.env["PATH"] = homebrewPath
            }
            
            let process = context.runAsync("/bin/bash", "-c", service.installCommand)
            
            process.onCompletion { res in
                DispatchQueue.main.async {
                    if !self.isGlobalTaskActive {
                        self.isInstalling = false
                    }
                    self.currentlyInstallingName = ""
                    self.installationOutput += "\nInstallation finished with exit code \(res.exitcode())\n"
                    self.checkAllStatus()
                    completion?()
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
    
    func approveInstallReview(_ review: InstallScriptReview, completion: (() -> Void)? = nil) {
        pendingInstallReview = nil
        runReviewedScript(review, completion: completion)
    }
    
    func cancelInstallReview() {
        pendingInstallReview = nil
        isFetchingScript = false
    }
    
    private func fetchInstallScript(service: EssentialService, urlString: String, interpreter: String) {
        isFetchingScript = true
        currentlyInstallingName = service.name
        installationOutput = "Preparing installer for \(service.name)...\n"
        
        guard let url = URL(string: urlString) else {
            isFetchingScript = false
            installationOutput += "Invalid URL.\n"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isFetchingScript = false
                if let error = error {
                    self.installationOutput += "Failed to download installer: \(error.localizedDescription)\n"
                    return
                }
                guard let data = data, let text = String(data: data, encoding: .utf8) else {
                    self.installationOutput += "Failed to decode installer.\n"
                    return
                }
                self.pendingInstallReview = InstallScriptReview(service: service, url: urlString, scriptText: text, interpreter: interpreter)
            }
        }.resume()
    }
    
    private func runReviewedScript(_ review: InstallScriptReview, completion: (() -> Void)? = nil) {
        isInstalling = true
        currentlyInstallingName = review.service.name
        installationOutput = "Starting installation of \(review.service.name)...\n"
        installationOutput += "Source: \(review.url)\n\n"
        
        DispatchQueue.global(qos: .userInitiated).async {
            let home = FileManager.default.homeDirectoryForCurrentUser
            let dir = home.appendingPathComponent(".zsh_manager/installers/\(review.service.id)")
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            let stamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
            let fileURL = dir.appendingPathComponent("\(stamp).sh")
            try? review.scriptText.write(to: fileURL, atomically: true, encoding: .utf8)
            _ = SwiftShell.run("/bin/chmod", "+x", fileURL.path)
            
            var context = CustomContext(main)
            let homebrewPath = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let existingPath = context.env["PATH"] {
                context.env["PATH"] = "\(homebrewPath):\(existingPath)"
            } else {
                context.env["PATH"] = homebrewPath
            }
            
            let process = context.runAsync(review.interpreter, fileURL.path)
            
            process.onCompletion { res in
                DispatchQueue.main.async {
                    if !self.isGlobalTaskActive {
                        self.isInstalling = false
                    }
                    self.currentlyInstallingName = ""
                    self.installationOutput += "\nInstallation finished with exit code \(res.exitcode())\n"
                    self.checkAllStatus()
                    completion?()
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
    
    private func parseRemoteScript(from installCommand: String) -> (url: String, interpreter: String)? {
        let lower = installCommand.lowercased()
        let looksRemote = lower.contains("curl") || lower.contains("wget")
        let looksEval = lower.contains("| bash") || lower.contains("| sh") || lower.contains("$(curl") || lower.contains("$(wget")
        if !(looksRemote && looksEval) { return nil }
        
        let interpreter: String
        if lower.contains("| sh") || lower.contains("sh -c") {
            interpreter = "/bin/sh"
        } else {
            interpreter = "/bin/bash"
        }
        
        let regex = try? NSRegularExpression(pattern: #"https?://[^\s"')\\]+"#, options: [])
        let range = NSRange(location: 0, length: (installCommand as NSString).length)
        guard let match = regex?.firstMatch(in: installCommand, range: range) else { return nil }
        var url = (installCommand as NSString).substring(with: match.range)
        url = url.trimmingCharacters(in: CharacterSet(charactersIn: "\"')\\"))
        return (url, interpreter)
    }
}
