import SwiftUI

struct EssentialsView: View {
    @ObservedObject var manager: ServiceManager
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeroBanner(
                    title: lang.t("Essential Services"),
                    subtitle: lang.t("One-click install development environments"),
                    icon: "sparkles",
                    color: .purple
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    ModernSectionHeader(title: lang.t("Available Tools"))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 280))], spacing: 20) {
                        ForEach(manager.services) { service in
                            ServiceCard(
                                service: service,
                                isInstalled: manager.installedIds.contains(service.id),
                                isInstalling: manager.isInstalling,
                                lang: lang,
                                onInstall: { manager.install(service: service) }
                            )
                        }
                    }
                }
                
                if !manager.installationOutput.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        ModernSectionHeader(title: lang.t("Installation Console"))
                        ConsoleOutputView(text: manager.installationOutput)
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 24).padding(.bottom, 40)
        }
        .onAppear { manager.checkAllStatus() }
        .sheet(item: $manager.pendingInstallReview) { review in
            InstallScriptReviewSheet(review: review, manager: manager, lang: lang)
        }
    }
}

struct ServiceCard: View {
    let service: EssentialService
    let isInstalled: Bool
    let isInstalling: Bool
    @ObservedObject var lang: LanguageManager
    let onInstall: () -> Void
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle().fill(isInstalled ? Color.green.opacity(0.1) : Color.purple.opacity(0.1)).frame(width: 48, height: 48)
                        Image(systemName: service.icon == "node_logo" ? "leaf.fill" : service.icon)
                            .font(.system(size: 24))
                            .foregroundColor(isInstalled ? .green : .purple)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(lang.t(service.name)).font(.system(size: 16, weight: .bold))
                        Text(lang.t(isInstalled ? "Already Installed" : "Not Found"))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(isInstalled ? .green : .secondary)
                    }
                    Spacer()
                }
                
                Text(lang.t(service.description))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .frame(height: 36, alignment: .top)
                
                HStack {
                    Text(lang.t(service.tips)).font(.system(size: 10)).foregroundColor(.secondary.opacity(0.6))
                    Spacer()
                    ZStack {
                        if !isInstalled {
                            Button(action: onInstall) {
                                Text(lang.t("INSTALL")).font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(Color.purple).cornerRadius(8)
                            }
                            .buttonStyle(.plain).foregroundColor(.white)
                            .disabled(isInstalling)
                            .opacity(isInstalling ? 0.5 : 1)
                        } else {
                            HStack(spacing: 4) {
                                Text(lang.t("Ready")).font(.system(size: 11, weight: .bold)).foregroundColor(.green)
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .frame(height: 32)
                }
            }
            .padding(20)
        }
    }
}
