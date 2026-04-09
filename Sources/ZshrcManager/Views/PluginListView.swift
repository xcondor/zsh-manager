import SwiftUI

struct PluginListView: View {
    @ObservedObject var manager: PluginManager
    @ObservedObject var lang: LanguageManager
    @StateObject private var terminal = TerminalManager()
    
    var body: some View {
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
                            lang: lang,
                            onInstall: {
                                manager.installPlugin(plugin.id) { success in
                                    // 可以在这里处理安装成功后的提示
                                }
                            }
                        )
                    }
                }
                
                if manager.isInstalling {
                    VStack(alignment: .leading, spacing: 10) {
                        ModernSectionHeader(title: lang.t("Installation Console"))
                        TerminalView(manager: terminal, lang: lang)
                            .frame(height: 200)
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PluginCard: View {
    let plugin: PluginDefinition
    @ObservedObject var manager: PluginManager
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
                        GlowButton(label: lang.t("INSTALL"), icon: "plus", color: .cyan, action: onInstall)
                    }
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
