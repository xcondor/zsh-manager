import SwiftUI

struct EnvDetectionView: View {
    @ObservedObject var manager: EnvironmentDetector
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Environments"),
                    subtitle: lang.t("Development tool detection"),
                    icon: "shippingbox.fill",
                    color: .blue
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        ModernSectionHeader(title: lang.t("Detected Services"))
                        Spacer()
                        GlowButton(label: lang.t("Rescan"), icon: "arrow.clockwise", color: .blue) {
                            manager.scan()
                        }
                    }
                    
                    if manager.isScanning {
                        loadingState
                    } else {
                        GlassCard {
                            ForEach(manager.results) { result in
                                VStack(spacing: 0) {
                                    EnvToolRow(result: result, lang: lang)
                                    if result.id != manager.results.last?.id {
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
            manager.scan()
        }
    }
    
    private var loadingState: some View {
        VStack(spacing: 20) {
            ProgressView()
            Text(lang.t("Scanning System..."))
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
}

struct EnvToolRow: View {
    let result: EnvDetectionResult
    let lang: LanguageManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: result.isInstalled ? "checkmark.circle.fill" : "questionmark.circle")
                .font(.system(size: 20))
                .foregroundColor(result.isInstalled ? .green : .secondary.opacity(0.3))
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(result.env.rawValue).font(.system(size: 14, weight: .bold))
                if result.isInstalled {
                    Text(result.version ?? "Detected").font(.system(size: 11, design: .monospaced)).foregroundColor(.blue)
                } else {
                    Text("Not Detected").font(.system(size: 11)).foregroundColor(.secondary)
                }
            }
            Spacer()
            if let path = result.path {
                Text(path).font(.system(size: 10, design: .monospaced)).foregroundColor(.secondary.opacity(0.5))
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
    }
}
