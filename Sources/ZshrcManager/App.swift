import SwiftUI

struct ZshrcManagerApp {
}

struct ContentView: View {
    @StateObject private var lang = LanguageManager()
    @StateObject private var shellManager = ShellManager()
    @StateObject private var aliasManager = AliasManager()
    @StateObject private var pathManager = PathManager()
    @StateObject private var snapshotManager = SnapshotManager()
    @StateObject private var envDetector = EnvironmentDetector()
    @StateObject private var diagnosticManager = DiagnosticManager()
    @StateObject private var templateManager = TemplateManager()
    @StateObject private var serviceManager = ServiceManager()
    @StateObject private var pythonManager = PythonManager()
    @StateObject private var terminalManager = TerminalManager()
    
    @State private var selection: String? = "Overview"
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection, lang: lang)
        } detail: {
            mainContent
        }
        .navigationTitle("Zshrc Manager")
        .environmentObject(lang)
        .onAppear {
            shellManager.start()
            aliasManager.start()
            pathManager.start()
            pythonManager.start()
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        Group {
            if let selection = selection {
                switch selection {
                case "Overview":
                    DetailView(
                        manager: shellManager,
                        aliasManager: aliasManager,
                        pathManager: pathManager,
                        snapshotManager: snapshotManager,
                        envDetector: envDetector,
                        lang: lang,
                        selection: $selection
                    )
                case "FunctionalList":
                    FunctionalListView(manager: shellManager, lang: lang)
                case "Aliases":
                    AliasListView(manager: aliasManager, lang: lang)
                case "Path":
                    PathListView(manager: pathManager, lang: lang)
                case "Templates":
                    TemplateView(manager: templateManager, aliasManager: aliasManager, pathManager: pathManager, lang: lang)
                case "Essentials":
                    EssentialsView(manager: serviceManager, lang: lang)
                case "Python":
                    PythonView(manager: pythonManager, lang: lang)
                default:
                    VStack { Text("Select Category") }
                }
            } else {
                VStack { Text("Select Category") }
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
            List(selection: $selection) {
                Section(header: Text(lang.t("General"))) {
                    Label(lang.t("Overview"), systemImage: "macwindow").tag("Overview")
                    Label(lang.t("Functional List"), systemImage: "checklist").tag("FunctionalList")
                    Label(lang.t("Aliases"), systemImage: "bolt.fill").tag("Aliases")
                    Label(lang.t("Path Manager"), systemImage: "folder.fill").tag("Path")
                    Label(lang.t("Environment Detection"), systemImage: "sensor.tag.radiowaves.forward.fill").tag("Templates")
                    Label(lang.t("Essentials"), systemImage: "sparkles").tag("Essentials")
                    Label(lang.t("Python Manager"), systemImage: "pyramid.fill").tag("Python")
                }
            }
            .listStyle(.sidebar)
            
            // Clean Language Switcher (Menu with Buttons, No Redundant Chevrons)
            VStack {
                Divider().opacity(0.1)
                HStack(spacing: 12) {
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.blue.opacity(0.8))
                    
                    Menu {
                        ForEach(Language.allCases, id: \.self) { language in
                            Button(action: { lang.currentLanguage = language }) {
                                Text(language.rawValue)
                                if lang.currentLanguage == language {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Text(lang.currentLanguage.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    }
                    .menuStyle(.borderlessButton)
                    .fixedSize()
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.black.opacity(0.05))
        }
    }
}

struct DetailView: View {
    @ObservedObject var manager: ShellManager
    @ObservedObject var aliasManager: AliasManager
    @ObservedObject var pathManager: PathManager
    @ObservedObject var snapshotManager: SnapshotManager
    @ObservedObject var envDetector: EnvironmentDetector
    @ObservedObject var lang: LanguageManager
    @Binding var selection: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HeroBanner(
                    title: "\(lang.t("Overview")) (\(manager.detectedConfigFileName))",
                    subtitle: manager.isInstalled ? lang.t("System Fully Managed") : lang.t("System Not Managed"),
                    icon: "macwindow",
                    color: manager.isInstalled ? .blue : .orange
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    if !manager.conflicts.isEmpty {
                        ModernSectionHeader(title: lang.t("Conflict Alerts"))
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(manager.conflicts) { conflict in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 14))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lang.t(conflict.type.rawValue))
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.orange)
                                            Text(conflict.message)
                                                .font(.system(size: 13))
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    
                                    if conflict.id != manager.conflicts.last?.id {
                                        ModernDivider()
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.orange.opacity(0.05))
                            
                            ModernDivider()
                            
                            Button(action: { selection = "FunctionalList" }) {
                                Label(lang.t("Manage in List"), systemImage: "arrow.right.circle.fill")
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                            .background(Color.orange.opacity(0.1))
                            .foregroundColor(.orange)
                        }
                    }
                    
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
                    
                    HStack(spacing: 16) {
                        if !manager.isInstalled {
                            GlowButton(label: lang.t("Inject into .zshrc").replacingOccurrences(of: ".zshrc", with: manager.detectedConfigFileName), icon: "plus.circle.fill", color: .blue, action: { manager.install() })
                        } else {
                            GlowButton(label: lang.t("Uninstall (Restore .zshrc)").replacingOccurrences(of: ".zshrc", with: manager.detectedConfigFileName), icon: "xmark.bin.fill", color: .red, action: { manager.uninstall() })
                        }
                    }
                    ModernSectionHeader(title: lang.t("System Environment Report"))
                    GlassCard {
                        VStack(alignment: .leading, spacing: 0) {
                            if envDetector.fullScriptOutput.isEmpty {
                                HStack {
                                    Image(systemName: "terminal.fill").foregroundColor(.secondary)
                                    Text(lang.t("Run env check to see detailed system report"))
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    GlowButton(label: lang.t("Run Check"), icon: "play.circle.fill", color: .purple, isSubtle: true, action: { envDetector.runFullCheckScript() })
                                }
                                .padding(20)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Label(lang.t("Detection Results"), systemImage: "text.justify.left")
                                            .font(.system(size: 12, weight: .bold))
                                        Spacer()
                                        if envDetector.isRunningScript {
                                            ProgressView().scaleEffect(0.5)
                                        } else {
                                            Button(action: { envDetector.runFullCheckScript() }) {
                                                Image(systemName: "arrow.clockwise").font(.system(size: 11))
                                            }
                                            .buttonStyle(.plain).foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.horizontal, 20).padding(.top, 16)
                                    
                                    ConsoleOutputView(text: envDetector.fullScriptOutput)
                                        .padding(.horizontal, 20).padding(.bottom, 20)
                                }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: 800, alignment: .leading)
        }
    }
}

struct MetricRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon).foregroundColor(color).frame(width: 24)
            Text(title).font(.system(size: 13, weight: .semibold))
            Spacer()
            Text(value).font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(.blue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}
