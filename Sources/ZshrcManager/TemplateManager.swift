import Foundation

struct ConfigTemplate: Identifiable {
    let id: String
    let name: String
    let icon: String
    let description: String
    let aliases: [AliasDefinition]
    let paths: [String]
    let checkCommand: String     // e.g. "which node"
    let verifyCommand: String    // e.g. "node -v"
    let requiredKey: String?     // e.g. "ANTHROPIC_API_KEY"
    let initScripts: [String]    // e.g. ["export NVM_DIR..."]
    
    /// Checks if the template is currently applied in the system configuration
    func checkApplied(aliasManager: AliasManager, pathManager: PathManager) -> Bool {
        if !aliases.isEmpty {
            let existingNames = Set(aliasManager.aliases.map { $0.name })
            for alias in aliases {
                if existingNames.contains(alias.name) { return true }
            }
        }
        if !paths.isEmpty {
            let existingPaths = Set(pathManager.paths.map { $0.path })
            for path in paths {
                if existingPaths.contains(path) { return true }
            }
        }
        if !initScripts.isEmpty {
            let envPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".zsh_manager/env.zsh")
            if let content = try? String(contentsOf: envPath, encoding: .utf8) {
                for script in initScripts {
                    if content.contains(script.components(separatedBy: "\n").first ?? script) { return true }
                }
            }
        }
        return false
    }
}

class TemplateManager: ObservableObject {
    @Published var templates: [ConfigTemplate] = []
    
    init() {
        self.templates = [
            ConfigTemplate(
                id: "node",
                name: "Node.js (NVM)",
                icon: "leaf.fill",
                description: "Standard Node Version Manager setup for Zsh.",
                aliases: [],
                paths: [],
                checkCommand: "ls $HOME/.nvm/nvm.sh",
                verifyCommand: "node -v",
                requiredKey: nil,
                initScripts: ["export NVM_DIR=\"$HOME/.nvm\"\n[ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\"\n[ -s \"$NVM_DIR/bash_completion\" ] && \\. \"$NVM_DIR/bash_completion\""]
            ),
            ConfigTemplate(
                id: "python",
                name: "Python (Pyenv)",
                icon: "pyramid.fill",
                description: "Pyenv initialization for managing Python versions.",
                aliases: [
                    AliasDefinition(name: "py", command: "python3", description: "Shorthand for python3")
                ],
                paths: [],
                checkCommand: "ls $HOME/.pyenv/bin/pyenv",
                verifyCommand: "python3 --version",
                requiredKey: nil,
                initScripts: ["export PYENV_ROOT=\"$HOME/.pyenv\"\n[[ -d $PYENV_ROOT/bin ]] && export PATH=\"$PYENV_ROOT/bin:$PATH\"\neval \"$(pyenv init -)\""]
            ),
            ConfigTemplate(
                id: "claude",
                name: "Claude Code",
                icon: "brain.headset",
                description: "AI-driven coding CLI by Anthropic.",
                aliases: [
                    AliasDefinition(name: "claude", command: "npx @anthropic-ai/claude-code", description: "Run Claude Code CLI"),
                    AliasDefinition(name: "ANTHROPIC_API_KEY", command: "YOUR_KEY_HERE", description: "Export Anthropic API Key")
                ],
                paths: [],
                checkCommand: "which npx",
                verifyCommand: "npx @anthropic-ai/claude-code --version", // --- INTERACTIVE FIX ---
                requiredKey: "ANTHROPIC_API_KEY",
                initScripts: []
            ),
            ConfigTemplate(
                id: "openclaw",
                name: "OpenClaw",
                icon: "shield.checkerboard",
                description: "Open-source AI coding assistant framework.",
                aliases: [
                    AliasDefinition(name: "OPENAI_API_KEY", command: "YOUR_KEY_HERE", description: "Export OpenAI API Key")
                ],
                paths: ["$(npm prefix -g)/bin"],
                checkCommand: "which npm",
                verifyCommand: "npm list -g @openclaw/cli | grep @openclaw/cli || echo 'OpenClaw'", // --- INTERACTIVE FIX ---
                requiredKey: "OPENAI_API_KEY",
                initScripts: []
            ),
            ConfigTemplate(
                id: "gemini",
                name: "Gemini CLI",
                icon: "sparkles",
                description: "Interact with Google Gemini models via terminal.",
                aliases: [
                    AliasDefinition(name: "GEMINI_API_KEY", command: "YOUR_KEY_HERE", description: "Export Gemini API Key")
                ],
                paths: [],
                checkCommand: "echo $GEMINI_API_KEY",
                verifyCommand: "echo 'Success'",
                requiredKey: "GEMINI_API_KEY",
                initScripts: []
            ),
            ConfigTemplate(
                id: "java",
                name: "Java",
                icon: "cup.and.saucer.fill",
                description: "Java Development Kit (JDK)",
                aliases: [],
                paths: ["$HOME/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home/bin"],
                checkCommand: "ls $HOME/Library/Java/JavaVirtualMachines/",
                verifyCommand: "java -version",
                requiredKey: nil,
                initScripts: ["export JAVA_HOME=$(/usr/libexec/java_home)\nexport PATH=$JAVA_HOME/bin:$PATH"]
            ),
            ConfigTemplate(
                id: "go",
                name: "Go",
                icon: "g.circle.fill",
                description: "Go Language (Golang) environment.",
                aliases: [
                    AliasDefinition(name: "gopath", command: "echo $GOPATH", description: "Show Go path")
                ],
                paths: ["$HOME/go/bin"],
                checkCommand: "which go",
                verifyCommand: "go version",
                requiredKey: nil,
                initScripts: []
            ),
            ConfigTemplate(
                id: "flutter",
                name: "Flutter",
                icon: "bird.fill",
                description: "Cross-platform development SDK.",
                aliases: [],
                paths: ["$HOME/development/flutter/bin"],
                checkCommand: "which flutter",
                verifyCommand: "flutter --version",
                requiredKey: nil,
                initScripts: []
            ),
            ConfigTemplate(
                id: "ruby",
                name: "Ruby",
                icon: "diamond.fill",
                description: "Ruby dynamic programming language.",
                aliases: [],
                paths: [],
                checkCommand: "which ruby",
                verifyCommand: "ruby -v",
                requiredKey: nil,
                initScripts: []
            )
        ]
    }
}
