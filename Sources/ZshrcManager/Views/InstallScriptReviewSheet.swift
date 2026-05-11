import SwiftUI

struct InstallScriptReviewSheet: View {
    let review: InstallScriptReview
    @ObservedObject var manager: ServiceManager
    @ObservedObject var lang: LanguageManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HeroBanner(
                title: "Review Installer Script",
                subtitle: review.service.name,
                icon: "shield.lefthalf.filled",
                color: .purple
            )
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(lang.t("Source URL")).font(.system(size: 12, weight: .bold)).foregroundColor(.secondary)
                    Text(review.url)
                        .font(.system(size: 12, design: .monospaced))
                        .textSelection(.enabled)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.08), lineWidth: 1))
                }
                
                ScrollView {
                    Text(review.scriptText)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                        .padding(12)
                }
                .background(Color.black.opacity(0.18))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08), lineWidth: 1))
                
                HStack {
                    Button(lang.t("Cancel")) {
                        manager.cancelInstallReview()
                        dismiss()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    GlowButton(label: "Run Installer", icon: "play.circle.fill", color: .purple) {
                        manager.approveInstallReview(review)
                        dismiss()
                    }
                }
            }
            .padding(24)
        }
        .frame(width: 820, height: 680)
    }
}

