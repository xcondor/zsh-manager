import SwiftUI

@main
struct ZshrcManagerApp: App {
    // The language manager is the only one that needs to be an ObservableObject for the UI
    @StateObject private var lang = AppState.shared.lang
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(lang)
                .onAppear {
                    // Trigger the background managers only once when the UI is ready
                    AppState.shared.startAll()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            // Provide standard macOS commands
            SidebarCommands()
            CommandGroup(replacing: .newItem) { } // Disable 'New Window'
        }
    }
}

struct ContentView: View {
    private let state = AppState.shared
    @State private var selection: String? = "Overview"
    @EnvironmentObject var lang: LanguageManager
    @ObservedObject var service: ServiceManager = AppState.shared.serviceManager
    @ObservedObject var reviewer: ChangeReviewManager = ChangeReviewManager.shared
    @State private var showingActivation = false
    
    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selection: $selection, showingActivation: $showingActivation)
                .frame(width: 250)
            
            Divider()
            
            mainContent
        }
        .frame(minWidth: 1100, minHeight: 750)
        .overlay {
            if service.isInstalling {
                LoadingOverlay(
                    message: lang.t("Installing...") + " \(service.currentlyInstallingName)",
                    subMessage: lang.t("Please wait while we set up your terminal")
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: service.isInstalling)
        .sheet(item: $reviewer.pending) { proposal in
            ChangeReviewSheet(reviewer: reviewer, proposal: proposal, lang: lang)
        }
        // .sheet(isPresented: $showingActivation) {
        //     LicenseActivationSheet().environmentObject(lang)
        // }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        ZStack {
            if let selection = selection {
                switch selection {
                case "Overview":
                    AnyView(DetailView(manager: state.shellManager, selection: $selection))
                case "Aliases":
                    AnyView(AliasListView(manager: state.aliasManager, lang: lang))
                case "Path":
                    AnyView(PathListView(manager: state.pathManager, lang: lang))
                case "Environment":
                    AnyView(EnvDetectionView(manager: state.envDetector, lang: lang))
                case "Python":
                    AnyView(PythonView(manager: state.pythonManager, lang: lang))
                case "Doctor":
                    AnyView(DiagnosticView(
                        manager: state.diagnosticManager,
                        shellManager: state.shellManager,
                        aliasManager: state.aliasManager,
                        pathManager: state.pathManager,
                        lang: lang
                    ))
                case "Snapshots":
                    AnyView(SnapshotView(manager: state.snapshotManager, lang: lang))
                case "Sync":
                    AnyView(CloudSyncView(manager: state.cloudSyncManager).environmentObject(lang))
                case "Settings":
                    AnyView(SettingsView().environmentObject(lang))
                case "Functional":
                    AnyView(FunctionalListView(manager: state.shellManager, lang: lang))
                case "Essentials":
                    AnyView(EssentialsView(manager: service, lang: lang))
                case "TerminalMaster":
                    AnyView(TerminalMasterView(master: AppState.shared.terminalMaster, service: service, lang: lang))
                case "Feedback":
                    AnyView(FeedbackView().environmentObject(lang))
                default:
                    AnyView(VStack {
                        Text("Content for: \(selection)")
                            .font(.title)
                            .foregroundColor(.secondary)
                    })
                }
            } else {
                AnyView(Text("Select an item"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct SidebarView: View {
    @Binding var selection: String?
    @Binding var showingActivation: Bool
    @EnvironmentObject var lang: LanguageManager
    @ObservedObject var license = LicenseManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    // Trial Widget at the very top
                    // TrialWidget(onUpgrade: { showingActivation = true })
                    //    .padding(.bottom, 12)
                    
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
                    SidebarButton(title: lang.t("Python Manager"), icon: "pyramid.fill", tag: "Python", selection: $selection)
                    SidebarButton(title: lang.t("Config Doctor"), icon: "ant.fill", tag: "Doctor", selection: $selection)
                    SidebarButton(title: lang.t("Snapshots"), icon: "clock.arrow.circlepath", tag: "Snapshots", selection: $selection)
                    SidebarButton(title: lang.t("iCloud Sync"), icon: "icloud.and.arrow.up.fill", tag: "Sync", selection: $selection)
                    SidebarButton(title: lang.t("Support & Questions"), icon: "envelope.fill", tag: "Feedback", selection: $selection)
                    SidebarButton(title: lang.t("Settings"), icon: "gearshape.fill", tag: "Settings", selection: $selection)
                    SidebarButton(title: lang.t("Terminal Master"), icon: "sparkles", tag: "TerminalMaster", selection: $selection, activeColor: .orange)
                    
                    Divider().padding(.vertical, 10)
                    
                    SidebarButton(title: lang.t("Functional List"), icon: "terminal", tag: "Functional", selection: $selection)
                }
                .padding(.horizontal, 10)
            }
            Spacer()
            
            // Language Picker
            VStack(spacing: 8) {
                Divider().opacity(0.3)
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Picker("", selection: $lang.currentLanguage) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .controlSize(.small)
                    .frame(width: 100)
                }
                .padding(.vertical, 12)
            }
            .padding(.horizontal, 12)
        }
        .background(Color(NSColor.windowBackgroundColor).opacity(0.5))
    }
}

struct SidebarButton: View {
    let title: String
    let icon: String
    let tag: String
    @Binding var selection: String?
    var activeColor: Color = .blue
    
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
            .background(selection == tag ? activeColor.opacity(0.1) : Color.clear)
            .foregroundColor(selection == tag ? activeColor : .primary)
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}

struct DetailView: View {
    @ObservedObject var manager: ShellManager
    @EnvironmentObject var lang: LanguageManager
    @Binding var selection: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                // Header Region
                VStack(spacing: 8) {
                    Text(lang.t("Overview")).font(.system(size: 11, weight: .bold)).foregroundColor(.secondary).tracking(2)
                    Text(manager.detectedConfigFileName)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    
                    HStack(spacing: 6) {
                        Circle().fill(manager.isInstalled ? Color.blue : Color.orange).frame(width: 8, height: 8)
                        Text(manager.isInstalled ? lang.t("System Fully Managed") : lang.t("System Not Managed"))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 40)
                
                // Metrics Grid
                VStack(alignment: .leading, spacing: 16) {
                    ModernSectionHeader(title: lang.t("Environment Status"))
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        let diag = AppState.shared.diagnosticManager
                        let securityScore = max(0, 100 - diag.issues.filter { $0.category == "Security" }.count * 35)
                        MetricCard(title: lang.t("Security"), value: "\(securityScore)", icon: "shield.fill", color: securityScore == 100 ? .blue : .red)
                        
                        let perfScore = max(0, 100 - diag.issues.filter { $0.category == "Performance" }.count * 25)
                        MetricCard(title: lang.t("Performance"), value: "\(perfScore)", icon: "bolt.fill", color: perfScore == 100 ? .orange : .yellow)
                        
                        let stabilityScore = max(0, 100 - diag.issues.filter { ["Zshrc", "Path"].contains($0.category) }.count * 15)
                        MetricCard(title: lang.t("Stability"), value: "\(stabilityScore)", icon: "checkmark.seal.fill", color: stabilityScore == 100 ? .green : .orange)
                    }
                }
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    ModernSectionHeader(title: lang.t("Quick Add"))
                    HStack(spacing: 16) {
                        QuickActionButton(title: lang.t("Quick_Add_Alias"), icon: "plus.circle.fill", color: .orange) { selection = "Aliases" }
                        QuickActionButton(title: lang.t("Quick_Fix_Command"), icon: "wrench.and.screwdriver.fill", color: .blue) { selection = "Path" }
                        QuickActionButton(title: lang.t("Quick_Install_Env"), icon: "shippingbox.fill", color: .green) { selection = "Essentials" }
                    }
                }
                
                // Management Core
                VStack(alignment: .leading, spacing: 16) {
                    ModernSectionHeader(title: lang.t("Management Engine"))
                    GlassCard {
                        VStack(spacing: 0) {
                            StatusRow(
                                icon: manager.isInstalled ? "checkmark.shield.fill" : "exclamationmark.shield.fill",
                                title: lang.t("Injection Protection"),
                                description: lang.t("Injection Desc").replacingOccurrences(of: "~/.zshrc", with: manager.detectedConfigPath),
                                statusText: manager.isInstalled ? "Active" : "Disabled",
                                statusColor: manager.isInstalled ? .blue : .orange,
                                isPulsing: manager.isInstalled,
                                showStatusText: !manager.isInstalled
                            )
                            
                            Divider().opacity(0.25).padding(.horizontal, 20)
                            
                            HStack {
                                if !manager.isInstalled {
                                    GlowButton(
                                        label: lang.t("Inject into .zshrc").replacingOccurrences(of: ".zshrc", with: manager.detectedConfigFileName),
                                        icon: "plus.circle.fill",
                                        color: .blue,
                                        action: { manager.install() }
                                    )
                                } else {
                                    GlowButton(
                                        label: lang.t("Uninstall (Restore .zshrc)").replacingOccurrences(of: ".zshrc", with: manager.detectedConfigFileName),
                                        icon: "xmark.bin.fill",
                                        color: .red,
                                        isSubtle: true,
                                        action: { manager.uninstall() }
                                    )
                                }
                                Spacer()
                                
                                Button(action: { selection = "Doctor" }) {
                                    HStack {
                                        Text(lang.t("Review Report"))
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.blue)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(20)
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
            .frame(maxWidth: 850)
            .frame(maxWidth: .infinity)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
