import SwiftUI

struct ZshrcManagerApp {
}

struct ContentView: View {
    // Plain property to avoid Meta-Graph observation cycles
    private let state = AppState()
    @State private var selection: String? = "Overview"
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selection: $selection, lang: state.lang)
                .frame(width: 250)
            
            Divider()
            
            mainContent
        }
        .frame(minWidth: 1100, minHeight: 750)
        .environmentObject(state.lang)
        .onAppear {
            state.startAll()
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        Group {
            if let selection = selection {
                switch selection {
                case "Overview":
                    DetailView(manager: state.shellManager, lang: state.lang, selection: $selection)
                case "Aliases":
                    AliasListView(manager: state.aliasManager, lang: state.lang)
                case "Path":
                    PathListView(manager: state.pathManager, lang: state.lang)
                case "Environment":
                    EnvDetectionView(manager: state.envDetector, lang: state.lang)
                case "Doctor":
                    DiagnosticView(
                        manager: state.diagnosticManager,
                        shellManager: state.shellManager,
                        aliasManager: state.aliasManager,
                        pathManager: state.pathManager,
                        lang: state.lang
                    )
                case "Snapshots":
                    SnapshotView(manager: state.snapshotManager, lang: state.lang)
                case "Plugins":
                    TemplateView(
                        manager: state.templateManager,
                        aliasManager: state.aliasManager,
                        pathManager: state.pathManager,
                        lang: state.lang
                    )
                case "Functional":
                    FunctionalListView(manager: state.shellManager, lang: state.lang)
                default:
                    VStack {
                        Text("Content for: \(selection)")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                Text("Select an item")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct SidebarView: View {
    @Binding var selection: String?
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Text(lang.t("General"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                        .padding(.leading, 12)
                        .padding(.top, 20)
                    
                    SidebarButton(title: lang.t("Overview"), icon: "macwindow", tag: "Overview", selection: $selection)
                    SidebarButton(title: lang.t("Aliases"), icon: "list.dash", tag: "Aliases", selection: $selection)
                    SidebarButton(title: lang.t("Path Manager"), icon: "folder.fill", tag: "Path", selection: $selection)
                    
                    Text(lang.t("Settings & Tools"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                        .padding(.leading, 12)
                        .padding(.top, 20)
                    
                    SidebarButton(title: lang.t("Environments"), icon: "cpu", tag: "Environment", selection: $selection)
                    SidebarButton(title: lang.t("Config Doctor"), icon: "ant.fill", tag: "Doctor", selection: $selection)
                    SidebarButton(title: lang.t("Snapshots"), icon: "clock.arrow.circlepath", tag: "Snapshots", selection: $selection)
                    SidebarButton(title: lang.t("Plugins"), icon: "square.stack.3d.up.fill", tag: "Plugins", selection: $selection)
                    
                    Divider().padding(.vertical, 10)
                    
                    SidebarButton(title: lang.t("Functional List"), icon: "terminal", tag: "Functional", selection: $selection)
                }
                .padding(.horizontal, 10)
            }
            Spacer()
        }
        .background(Color(NSColor.windowBackgroundColor).opacity(0.5))
    }
}

struct SidebarButton: View {
    let title: String
    let icon: String
    let tag: String
    @Binding var selection: String?
    
    var body: some View {
        Button(action: { selection = tag }) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .frame(width: 16)
                Text(title)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(selection == tag ? Color.blue.opacity(0.1) : Color.clear)
            .foregroundColor(selection == tag ? .blue : .primary)
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}

// Sub-components moved to original DetailView section
struct DetailView: View {
    @ObservedObject var manager: ShellManager
    @ObservedObject var lang: LanguageManager
    @Binding var selection: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: "\(lang.t("Overview")) (\(manager.detectedConfigFileName))",
                    subtitle: manager.isInstalled ? lang.t("System Fully Managed") : lang.t("System Not Managed"),
                    icon: "macwindow",
                    color: manager.isInstalled ? .blue : .orange
                )
                
                let healthScore = manager.conflicts.isEmpty ? 100 : max(10, 100 - (manager.conflicts.count * 20))
                GlassCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lang.t("Health Score"))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)
                            Text("\(healthScore)")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundColor(healthScore == 100 ? .green : .orange)
                        }
                        Spacer()
                        if healthScore < 100 {
                            Image(systemName: "exclamationmark.shield.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange.opacity(0.8))
                        } else {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green.opacity(0.8))
                        }
                    }
                    .padding(20)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    ModernSectionHeader(title: lang.t("Management Engine"))
                    GlassCard {
                        StatusRow(
                            icon: manager.isInstalled ? "checkmark.shield.fill" : "exclamationmark.shield.fill",
                            title: lang.t("Injection Protection"),
                            description: lang.t("Injection Desc").replacingOccurrences(of: "~/.zshrc", with: manager.detectedConfigPath),
                            statusText: manager.isInstalled ? "Active" : "Disabled",
                            statusColor: manager.isInstalled ? .blue : .orange,
                            isPulsing: manager.isInstalled,
                            showStatusText: !manager.isInstalled
                        )
                    }
                }
            }
            .padding(40)
            .frame(maxWidth: 800, alignment: .leading)
        }
    }
}
struct QuickActionButton: View {
    var body: some View { EmptyView() }
}
