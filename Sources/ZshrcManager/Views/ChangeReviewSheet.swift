import SwiftUI

struct ChangeReviewSheet: View {
    @ObservedObject var reviewer: ChangeReviewManager
    let proposal: FileChangeProposal
    @ObservedObject var lang: LanguageManager
    
    @State private var tab: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HeroBanner(
                title: proposal.title,
                subtitle: proposal.filePath,
                icon: "doc.text.magnifyingglass",
                color: .orange
            )
            
            VStack(alignment: .leading, spacing: 16) {
                if !proposal.summaryKeys.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(lang.t("Intent Analysis")).font(.system(size: 11, weight: .bold)).foregroundColor(.orange.opacity(0.8))
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(proposal.summaryKeys, id: \.self) { key in
                                Text("• \(lang.t(key))")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.12))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange.opacity(0.2), lineWidth: 1))
                }
                
                Picker("", selection: $tab) {
                    Text(lang.t("Diff")).tag(0)
                    Text(lang.t("Before")).tag(1)
                    Text(lang.t("After")).tag(2)
                }
                .pickerStyle(.segmented)
                
                Group {
                    if tab == 0 {
                        DiffTextView(text: proposal.diffText)
                    } else if tab == 1 {
                        DiffTextView(text: proposal.beforeText)
                    } else {
                        DiffTextView(text: proposal.afterText)
                    }
                }
                
                HStack {
                    Button(lang.t("Cancel")) { reviewer.reject() }
                        .buttonStyle(.plain)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    GlowButton(label: lang.t("Save"), icon: "checkmark.circle.fill", color: .orange) {
                        reviewer.approve()
                    }
                }
            }
            .padding(24)
        }
        .frame(width: 800, height: 650)
    }
}

private struct DiffTextView: View {
    let text: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 1) {
                let lines = ShellHighlighter.highlight(text: text)
                ForEach(lines) { line in
                    HStack(spacing: 0) {
                        ForEach(line.segments) { segment in
                            Text(segment.text)
                                .font(.system(size: 11, weight: segment.weight, design: .monospaced))
                                .foregroundColor(segment.color)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .background(
                        Group {
                            if line.content.hasPrefix("+") {
                                Color.green.opacity(0.18)
                            } else if line.content.hasPrefix("-") {
                                Color.red.opacity(0.18)
                            } else {
                                Color.clear
                            }
                        }
                    )
                }
            }
            .padding(.vertical, 12)
        }
        .background(Color.black)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1))
    }
}
