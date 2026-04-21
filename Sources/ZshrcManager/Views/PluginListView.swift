import SwiftUI

struct PluginListView: View {
    @ObservedObject var manager: PluginManager
    @ObservedObject var lang: LanguageManager
    @StateObject private var terminal = TerminalManager()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeroBanner(
                        title: lang.t("Plugins"),
                        subtitle: lang.t("Plugin Store Desc"),
                        icon: "square.stack.3d.up.fill",
                        color: .cyan
                    )
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))], spacing: 20) {
                        ForEach(manager.plugins) { plugin in
                            PluginCard(
                                plugin: plugin,
                                manager: manager,
                                terminal: terminal,
                                lang: lang,
                                onInstall: {
                                    terminal.clear()
                                    terminal.sendInput("### \(lang.t("Installing_Plugin_Prefix"))\(plugin.name)")
                                    terminal.sendInput("### \(lang.t("See_Details_In_Console"))")
                                    
                                    manager.installPlugin(plugin.id, onOutput: { line in
                                        terminal.addOutput(line)
                                    }) { success in
                                        if success {
                                            terminal.sendInput("### \(lang.t("Installation_Success_Wait"))")
                                        }
                                    }
                                }
                            )
                        }
                    }
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 40).padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider().opacity(0.1)
            
            // Fixed bottom Console
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "terminal.fill").foregroundColor(.cyan).font(.system(size: 14))
                    Text(lang.t("Test Lab")).font(.system(size: 13, weight: .bold))
                }
                .padding(.horizontal, 40).padding(.top, 12)
                
                TerminalView(manager: terminal, isEmbedded: true)
                    .frame(height: 260)
                    .padding(.horizontal, 40).padding(.bottom, 20)
            }
            .background(Color(NSColor.windowBackgroundColor).opacity(0.8))
        }
    }
}

struct PluginCard: View {
    let plugin: PluginDefinition
    @ObservedObject var manager: PluginManager
    @ObservedObject var terminal: TerminalManager
    let lang: LanguageManager
    let onInstall: () -> Void
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Circle().fill(Color.cyan.opacity(0.1)).frame(width: 44, height: 44)
                        Image(systemName: "puzzlepiece.fill").foregroundColor(.cyan).font(.system(size: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plugin.name).font(.system(size: 16, weight: .bold))
                        Text(plugin.description).font(.system(size: 11)).foregroundColor(.secondary).lineLimit(2)
                    }
                    Spacer()
                    
                    if plugin.isInstalled {
                        Toggle("", isOn: Binding(
                            get: { plugin.isEnabled },
                            set: { _ in manager.togglePlugin(plugin.id) }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: .cyan))
                        .labelsHidden()
                    }
                }
                
                HStack {
                    StatusBadge(isInstalled: plugin.isInstalled, isEnabled: plugin.isEnabled, lang: lang)
                    Spacer()
                    if !plugin.isInstalled {
                        if plugin.isInstalling {
                            HStack(spacing: 8) {
                                ProgressView().scaleEffect(0.6)
                                Text(lang.t("Installing...")).font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(.cyan)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.cyan.opacity(0.1)).cornerRadius(8)
                        } else {
                            GlowButton(label: lang.t("INSTALL"), icon: "plus", color: .cyan, action: onInstall)
                        }
                    }
                }
                
                if plugin.isInstalled {
                    VStack(alignment: .leading, spacing: 12) {
                        Divider().padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "book.fill").foregroundColor(.blue)
                            Text(lang.t("Usage")).font(.system(size: 13, weight: .bold))
                            Spacer()
                        }
                        
                        Text(plugin.usage)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 8) {
                                Text(lang.t("Example Command")).font(.system(size: 10, weight: .bold)).foregroundColor(.secondary)
                                Text(plugin.testCommand)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                terminal.sendInput(plugin.testCommand)
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "play.fill")
                                    Text(lang.t("Try it!"))
                                }
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                            .disabled(plugin.testCommand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .opacity(plugin.testCommand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                        }
                        .padding(.top, 4)
                    }
                    .padding(16)
                    .background(Color.secondary.opacity(0.03))
                    .cornerRadius(8)
                }
            }
            .padding(20)
        }
    }
}

struct StatusBadge: View {
    let isInstalled: Bool
    let isEnabled: Bool
    let lang: LanguageManager
    
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(text).font(.system(size: 10, weight: .bold)).foregroundColor(color)
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(color.opacity(0.1)).cornerRadius(4)
    }
    
    var text: String {
        if !isInstalled { return lang.t("Plugin_Not_Installed") }
        return isEnabled ? lang.t("Active") : lang.t("Installed")
    }
    
    var color: Color {
        if !isInstalled { return .gray }
        return isEnabled ? .green : .blue
    }
}
