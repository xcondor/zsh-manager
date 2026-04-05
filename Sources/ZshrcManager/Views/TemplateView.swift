import SwiftUI

struct TemplateView: View {
    @ObservedObject var manager: TemplateManager
    @ObservedObject var aliasManager: AliasManager
    @ObservedObject var pathManager: PathManager
    @ObservedObject var lang: LanguageManager
    @StateObject private var terminal = TerminalManager()
    
    @State private var wizardResults: [String: WizardStatus] = [:]
    
    enum WizardStatus {
        case idle, detecting, configuring, verifying, success(String), failure(String), notInstalled
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Environment Detection"),
                    subtitle: lang.t("Quickly help users configure a specific environment"),
                    icon: "sensor.tag.radiowaves.forward.fill",
                    color: .purple
                )
                
                if manager.templates.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "circle.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary.opacity(0.3))
                        Text(lang.t("No Tools Detected"))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                        ForEach(manager.templates) { template in
                            let status = wizardResults[template.id] ?? .detecting
                            
                            WizardCard(
                                template: template,
                                status: status,
                                lang: lang,
                                isKeyMissing: checkKeyMissing(for: template),
                                onAction: { runWizard(for: template) }
                            )
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            detectAll()
        }
    }
    
    func checkKeyMissing(for template: ConfigTemplate) -> Bool {
        guard let keyName = template.requiredKey else { return false }
        if let alias = aliasManager.aliases.first(where: { $0.name == keyName }) {
            return alias.command == "YOUR_KEY_HERE"
        }
        return false
    }
    
    func detectAll() {
        for template in manager.templates {
            checkStatus(for: template)
        }
    }
    
    func checkStatus(for template: ConfigTemplate) {
        if case .detecting = wizardResults[template.id] { return }
        
        wizardResults[template.id] = .detecting
        
        terminal.runCommand(template.checkCommand, silent: true) { output in
            DispatchQueue.main.async {
                if output.isEmpty || output.contains("not found") {
                    wizardResults[template.id] = .notInstalled
                } else {
                    if template.checkApplied(aliasManager: aliasManager, pathManager: pathManager) {
                        wizardResults[template.id] = .verifying
                        terminal.runCommand(template.verifyCommand, silent: true) { vOutput in
                            DispatchQueue.main.async {
                                if vOutput.isEmpty || vOutput.contains("not found") {
                                    wizardResults[template.id] = .failure("Verify Failed")
                                } else {
                                    let cleanOutput = vOutput.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespaces)
                                    wizardResults[template.id] = .success(cleanOutput.prefix(30) + (cleanOutput.count > 30 ? "..." : ""))
                                }
                            }
                        }
                    } else {
                        wizardResults[template.id] = .idle
                    }
                }
            }
        }
    }
    
    func runWizard(for template: ConfigTemplate) {
        wizardResults[template.id] = .detecting
        
        terminal.runCommand(template.checkCommand, silent: true) { output in
            if output.isEmpty || output.contains("not found") {
                DispatchQueue.main.async { wizardResults[template.id] = .notInstalled }
                return
            }
            
            DispatchQueue.main.async {
                wizardResults[template.id] = .configuring
                for alias in template.aliases {
                    aliasManager.addAlias(name: alias.name, command: alias.command, description: alias.description)
                }
                for path in template.paths {
                    pathManager.addPath(path)
                }
                
                for script in template.initScripts {
                    let envPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".zsh_manager/env.zsh")
                    let content = "\n# Managed by Zshrc Manager: \(template.name)\n\(script)\n"
                    let firstLine = script.components(separatedBy: "\n").first ?? script
                    if let current = try? String(contentsOf: envPath, encoding: .utf8), current.contains(firstLine) { continue }
                    
                    if FileManager.default.fileExists(atPath: envPath.path) {
                        if let handle = try? FileHandle(forWritingTo: envPath) {
                            handle.seekToEndOfFile()
                            handle.write(content.data(using: .utf8)!)
                            handle.closeFile()
                        }
                    } else {
                        try? content.write(to: envPath, atomically: true, encoding: .utf8)
                    }
                }
                
                wizardResults[template.id] = .verifying
                terminal.runCommand(template.verifyCommand, silent: true) { verifyOutput in
                    DispatchQueue.main.async {
                        if verifyOutput.isEmpty || verifyOutput.contains("not found") {
                            wizardResults[template.id] = .failure("Verification Failed")
                        } else {
                            let clean = verifyOutput.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespaces)
                            wizardResults[template.id] = .success(clean.prefix(30) + (clean.count > 30 ? "..." : ""))
                        }
                    }
                }
            }
        }
    }
}

struct WizardCard: View {
    let template: ConfigTemplate
    let status: TemplateView.WizardStatus
    let lang: LanguageManager
    let isKeyMissing: Bool
    let onAction: () -> Void
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Circle().fill(Color.purple.opacity(0.1)).frame(width: 44, height: 44)
                        Image(systemName: template.icon).foregroundColor(.purple).font(.system(size: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(lang.t(template.name)).font(.system(size: 16, weight: .bold))
                        Text(lang.t(template.description)).font(.system(size: 11)).foregroundColor(.secondary).lineLimit(2)
                    }
                    Spacer()
                    StatusIndicator(status: status)
                }
                
                if isKeyMissing {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange).font(.system(size: 10))
                        Text(lang.t("Key Missing")).font(.system(size: 11, weight: .bold)).foregroundColor(.orange)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1)).cornerRadius(6)
                } else {
                    Text(statusText).font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(statusColor.opacity(0.1)).cornerRadius(4)
                }
                
                HStack {
                    Spacer()
                    if isExecuting {
                        ProgressView().scaleEffect(0.6).frame(height: 32)
                    } else if case .success = status {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill").foregroundColor(.green)
                            Text(lang.t("Ready")).font(.system(size: 11, weight: .bold)).foregroundColor(.green)
                        }
                        .padding(.vertical, 8)
                    } else if case .failure = status {
                        GlowButton(label: lang.t("Retry"), icon: "arrow.clockwise", color: .red, action: onAction)
                    } else if case .notInstalled = status {
                        Text(lang.t("Please install tool first")).font(.system(size: 11)).foregroundColor(.secondary)
                    } else {
                        GlowButton(label: lang.t("Auto-Configure"), icon: "wand.and.stars", color: .purple, action: onAction)
                    }
                }
            }
            .padding(20)
        }
    }
    
    var isExecuting: Bool {
        switch status {
        case .detecting, .configuring, .verifying: return true
        default: return false
        }
    }
    
    var statusText: String {
        switch status {
        case .idle: return lang.t("Detected, Not Configured")
        case .notInstalled: return lang.t("Not Installed")
        case .detecting: return lang.t("Detecting")
        case .configuring: return lang.t("Configuring")
        case .verifying: return lang.t("Verifying")
        case .success(let msg): return msg.uppercased()
        case .failure(let msg): return msg.uppercased()
        }
    }
    
    var statusColor: Color {
        switch status {
        case .detecting, .configuring, .verifying: return .orange
        case .idle: return .blue
        case .success: return .green
        case .failure, .notInstalled: return .red
        default: return .secondary
        }
    }
}

struct StatusIndicator: View {
    let status: TemplateView.WizardStatus
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .shadow(color: color.opacity(0.5), radius: 3)
    }
    
    var color: Color {
        switch status {
        case .detecting, .configuring, .verifying: return .orange
        case .idle: return .blue
        case .success: return .green
        case .failure, .notInstalled: return .red
        default: return .gray.opacity(0.3)
        }
    }
}
