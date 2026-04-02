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
        )
    ]
    
    @Published var installationOutput: String = ""
    @Published var isInstalling: Bool = false
    @Published var installedIds: Set<String> = []
    
    func checkAllStatus() {
        DispatchQueue.global(qos: .userInitiated).async {
            var newlyInstalled: Set<String> = []
            let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
            
            for service in self.services {
                // Expand ~ to HOME if present
                let cmd = service.checkCommand.replacingOccurrences(of: "~", with: homeDir)
                
                // Run check command via bash to support existence tests (ls, [ -d ... ])
                let res = SwiftShell.run("/bin/bash", "-c", cmd)
                if res.exitcode == 0 {
                    newlyInstalled.insert(service.id)
                }
            }
            
            DispatchQueue.main.async {
                self.installedIds = newlyInstalled
            }
        }
    }
    
    func install(service: EssentialService) {
        self.isInstalling = true
        self.installationOutput = "Starting installation of \(service.name)...\n"
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Run the install command via shell
            let context = CustomContext()
            let process = context.runAsync("/bin/bash", "-c", service.installCommand)
            
            process.onCompletion { res in
                DispatchQueue.main.async {
                    self.isInstalling = false
                    self.installationOutput += "\nInstallation finished with exit code \(res.exitcode())\n"
                    self.checkAllStatus()
                }
            }
            
            process.stdout.onOutput { stream in
                let output = stream.read()
                DispatchQueue.main.async {
                    self.installationOutput += output
                }
            }
            
            process.stderror.onOutput { stream in
                let output = stream.read()
                DispatchQueue.main.async {
                    self.installationOutput += output
                }
            }
        }
    }
}
