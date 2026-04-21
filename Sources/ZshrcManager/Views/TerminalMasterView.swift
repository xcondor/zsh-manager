import SwiftUI

struct TerminalMasterView: View {
    @ObservedObject var master: TerminalMasterManager
    @ObservedObject var service: ServiceManager
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        ProGateView(title: lang.t("Fastest Setup")) {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HeroBanner(
                        title: lang.t("Terminal Master"),
                        subtitle: lang.t("Beautify Your Shell"),
                        icon: "sparkles",
                        color: .orange
                    )
                    
                    // Boost Start Button
                    VStack(spacing: 12) {
                        GlowButton(
                            label: service.isInstalling ? lang.t("Optimizing...") : lang.t("Boost Start"),
                            icon: "rocket.fill",
                            color: .orange,
                            isLoading: service.isInstalling
                        ) {
                            master.runBoostSequence(serviceManager: service)
                        }
                        
                        if master.isP10kInstalled {
                            Button(action: {
                                service.beginGlobalTask()
                                master.revertBeautify(serviceManager: service) {
                                    service.endGlobalTask()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward.circle")
                                    Text(lang.t("Restore Default Theme"))
                                }
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    // Step List
                    VStack(alignment: .leading, spacing: 16) {
                        Text(lang.t("Core Components")).font(.system(size: 16, weight: .bold))
                        
                        VStack(spacing: 12) {
                            MasterStepRow(
                                name: lang.t("iTerm2 App"),
                                status: service.installedIds.contains("iterm2"),
                                action: { if let s = service.services.first(where: { $0.id == "iterm2" }) { service.install(service: s) } }
                            )
                            
                            MasterStepRow(
                                name: "Oh My Zsh",
                                status: master.isOMZInstalled,
                                action: { if let s = service.services.first(where: { $0.id == "omz" }) { service.install(service: s) } }
                            )
                            
                            MasterStepRow(
                                name: lang.t("Shell Theme"),
                                status: master.isP10kInstalled,
                                action: { master.applyBeautify(serviceManager: service) }
                            )
                            
                            MasterStepRow(
                                name: lang.t("Nerd Font"),
                                status: master.isFontInstalled,
                                action: { if let s = service.services.first(where: { $0.id == "nerd-font" }) { service.install(service: s) } }
                            )
                        }
                    }
                    
                    // Plugin Selection
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(lang.t("Interactive Enhancements")).font(.system(size: 16, weight: .bold))
                            
                            VStack(spacing: 12) {
                                ForEach(AppState.shared.pluginManager.plugins.filter { ["autosuggestions", "syntax-highlighting", "fzf-tab"].contains($0.id) }) { plugin in
                                    MasterPluginRow(plugin: plugin, manager: AppState.shared.pluginManager, lang: lang)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(lang.t("Modern Productivity Tools")).font(.system(size: 16, weight: .bold))
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(AppState.shared.pluginManager.plugins.filter { ["zoxide", "eza", "bat", "thefuck", "tldr", "extract"].contains($0.id) }) { plugin in
                                    MiniPluginCard(plugin: plugin, manager: AppState.shared.pluginManager, lang: lang)
                                }
                            }
                        }
                    }
                    
                    // Post install guide
                    VStack(alignment: .leading, spacing: 12) {
                        Text(lang.t("Post-Install Tips")).font(.system(size: 14, weight: .bold))
                        Text(lang.t("Set Font Guide"))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(8)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 40).padding(.top, 20)
            }
        }
        .onAppear {
            service.checkAllStatus()
            master.checkStatus()
        }
        .alert(lang.t(master.lastResultTitle), isPresented: $master.showSuccess) {
            Button(lang.t("OK"), role: .cancel) { }
        } message: {
            Text(lang.t(master.lastResultMessage))
        }
    }
}

struct MasterStepRow: View {
    let name: String
    let status: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: status ? "checkmark.circle.fill" : "circle")
                .foregroundColor(status ? .green : .secondary)
            Text(name).font(.system(size: 14))
            Spacer()
            if !status {
                Button(action: action) {
                    Text("Install").font(.system(size: 12, weight: .bold))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            } else {
                Text("Ready").font(.system(size: 12)).foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.black.opacity(0.02))
        .cornerRadius(10)
    }
}

struct MasterPluginRow: View {
    let plugin: PluginDefinition
    @ObservedObject var manager: PluginManager
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: plugin.isInstalled ? "checkmark.circle.fill" : "circle")
                .foregroundColor(plugin.isInstalled ? .green : .secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(plugin.name).font(.system(size: 14, weight: .medium))
                Text(lang.t(plugin.description)).font(.system(size: 11)).foregroundColor(.secondary)
            }
            
            Spacer()
            
            if plugin.isInstalling {
                ProgressView().controlSize(.small)
            } else if !plugin.isInstalled {
                Button(action: {
                    manager.installPlugin(plugin.id, onOutput: { _ in }, completion: { _ in })
                }) {
                    Text("Install").font(.system(size: 12, weight: .bold))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            } else {
                Toggle("", isOn: Binding(
                    get: { plugin.isEnabled },
                    set: { _ in manager.togglePlugin(plugin.id) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .labelsHidden()
                .scaleEffect(0.7)
            }
        }
        .padding()
        .background(Color.black.opacity(0.02))
        .cornerRadius(10)
    }
}

struct MiniPluginCard: View {
    let plugin: PluginDefinition
    @ObservedObject var manager: PluginManager
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: plugin.isInstalled ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 10))
                        .foregroundColor(plugin.isInstalled ? .green : .secondary)
                    Text(plugin.name).font(.system(size: 12, weight: .bold))
                }
                Text(lang.t(plugin.description)).font(.system(size: 10)).foregroundColor(.secondary).lineLimit(1)
            }
            Spacer()
            if plugin.isInstalling {
                ProgressView().controlSize(.small).scaleEffect(0.6)
            } else if !plugin.isInstalled {
                Button(action: {
                    manager.installPlugin(plugin.id, onOutput: { _ in }, completion: { _ in })
                }) {
                    Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(Color.black.opacity(0.02))
        .cornerRadius(10)
    }
}
