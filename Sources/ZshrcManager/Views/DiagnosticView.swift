import SwiftUI

struct DiagnosticView: View {
    @ObservedObject var manager: DiagnosticManager
    @ObservedObject var shellManager: ShellManager
    @ObservedObject var aliasManager: AliasManager
    @ObservedObject var pathManager: PathManager
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Config Doctor"),
                    subtitle: lang.t("Diagnostic system health report"),
                    icon: "stethoscope",
                    color: .blue
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        ModernSectionHeader(title: lang.t("Diagnostic Findings"))
                        Spacer()
                        GlowButton(label: lang.t("Re-Run"), icon: "play.fill", color: .blue) {
                            manager.runDiagnostics(aliasManager: aliasManager, pathManager: pathManager, lang: lang)
                        }
                    }
                    
                    if manager.isRunning {
                        loadingState
                    } else if manager.issues.isEmpty {
                        healthyState
                    } else {
                        GlassCard {
                            ForEach(manager.issues) { issue in
                                VStack(spacing: 0) {
                                    IssueRow(issue: issue, lang: lang)
                                    if issue.id != manager.issues.last?.id {
                                        ModernDivider()
                                    }
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
        .onAppear {
            manager.runDiagnostics(aliasManager: aliasManager, pathManager: pathManager, lang: lang)
        }
    }
    
    private var loadingState: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text(lang.t("Analyzing System Health...")).font(.system(size: 14)).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 80)
    }
    
    private var healthyState: some View {
        GlassCard {
            StatusRow(
                icon: "checkmark.seal.fill",
                title: lang.t("System Configuration Healthy"),
                description: lang.t("No configuration issues detected in .zshrc").replacingOccurrences(of: ".zshrc", with: shellManager.detectedConfigFileName),
                statusText: "PASS",
                statusColor: .green,
                isPulsing: true
            )
        }
    }
}

struct IssueRow: View {
    let issue: DiagnosticIssue
    let lang: LanguageManager
    
    private var color: Color {
        switch issue.severity {
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle().fill(color).frame(width: 8, height: 8)
                Text(issue.category).font(.system(size: 11, weight: .bold)).foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(issue.message).font(.system(size: 14, weight: .semibold))
                if let suggestion = issue.suggestion {
                    Text(suggestion).font(.system(size: 12)).foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 22).padding(.vertical, 16)
    }
}
