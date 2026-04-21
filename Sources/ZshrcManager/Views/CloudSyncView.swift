import SwiftUI

struct CloudSyncView: View {
    @ObservedObject var manager: CloudSyncManager
    @EnvironmentObject var lang: LanguageManager
    
    var body: some View {
        ProGateView(title: lang.t("iCloud Sync")) {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HeroBanner(
                        title: lang.t("iCloud Sync"),
                        subtitle: lang.t("Sync configurations across all your Macs"),
                        icon: "icloud.and.arrow.up.fill",
                        color: .blue
                    )
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ModernSectionHeader(title: lang.t("Status"))
                        
                        GlassCard {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(lang.t("iCloud Backup")).font(.system(size: 14, weight: .bold))
                                        Text(lang.t("Sync aliases.json to iCloud Drive")).font(.system(size: 12)).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Toggle("", isOn: Binding(
                                        get: { manager.isEnabled },
                                        set: { manager.toggleSync(enabled: $0) }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                }
                                
                                if manager.isEnabled {
                                    ModernDivider()
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lang.t("Last Synced")).font(.system(size: 12, weight: .semibold))
                                            if let date = manager.lastSyncDate {
                                                Text(date.formatted(date: .abbreviated, time: .shortened)).font(.system(size: 11)).foregroundColor(.secondary)
                                            } else {
                                                Text(lang.t("Never")).font(.system(size: 11)).foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                        
                                        syncStatusView
                                        
                                        Button(action: { manager.syncUp() }) {
                                            Image(systemName: "arrow.clockwise")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(20)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ModernSectionHeader(title: lang.t("Privacy & Security"))
                        Text(lang.t("CloudSync_Privacy_Notice"))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 40).padding(.top, 24).padding(.bottom, 40)
            }
        }
    }
    
    @ViewBuilder
    private var syncStatusView: some View {
        HStack(spacing: 6) {
            switch manager.status {
            case .syncing:
                ProgressView().controlSize(.small).scaleEffect(0.6)
                Text(lang.t("Syncing...")).font(.system(size: 11)).foregroundColor(.blue)
            case .success:
                Image(systemName: "checkmark.circle.fill").font(.system(size: 11)).foregroundColor(.green)
                Text(lang.t("Up to Date")).font(.system(size: 11)).foregroundColor(.green)
            case .error:
                Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 11)).foregroundColor(.red)
                Text(lang.t("Sync Failed")).font(.system(size: 11)).foregroundColor(.red)
            case .idle:
                EmptyView()
            }
        }
        .padding(.horizontal, 8)
    }
}
