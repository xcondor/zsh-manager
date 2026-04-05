import SwiftUI

struct FunctionalListView: View {
    @ObservedObject var manager: ShellManager
    @ObservedObject var lang: LanguageManager
    @State private var copiedIds: Set<UUID> = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HeroBanner(
                    title: lang.t("Functional List"),
                    subtitle: "Manage individual configuration functions with ease",
                    icon: "checklist",
                    color: .blue
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        ModernSectionHeader(title: lang.t("Expert Insight Report"))
                        Spacer()
                    }
                    
                    GlassCard {
                        VStack(spacing: 0) {
                            if manager.insights.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "doc.text.magnifyingglass")
                                        .font(.system(size: 32))
                                        .foregroundColor(.secondary.opacity(0.3))
                                    Text(lang.t("No functional insights detected yet."))
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                .padding(40)
                                .frame(maxWidth: .infinity)
                            } else {
                                ForEach(manager.insights) { insight in
                                    HStack(spacing: 16) {
                                        ConfigInsightRow(insight: insight)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            Button(action: {
                                                NSPasteboard.general.clearContents()
                                                NSPasteboard.general.setString(insight.content, forType: .string)
                                                withAnimation { _ = copiedIds.insert(insight.id) }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    withAnimation { _ = copiedIds.remove(insight.id) }
                                                }
                                            }) {
                                                Image(systemName: copiedIds.contains(insight.id) ? "checkmark" : "doc.on.doc")
                                                    .font(.system(size: 11))
                                                    .foregroundColor(copiedIds.contains(insight.id) ? .green : .secondary)
                                            }
                                            .buttonStyle(.plain)
                                            
                                            Toggle(isOn: Binding(
                                                get: { insight.isEnabled },
                                                set: { _ in manager.toggleLine(id: insight.id) }
                                            )) {
                                                EmptyView()
                                            }
                                            .toggleStyle(SwitchToggleStyle(tint: .green))
                                            .labelsHidden()
                                            .scaleEffect(0.7)
                                            .frame(width: 32)
                                        }
                                    }
                                    .padding(.horizontal, 22)
                                    
                                    if insight.id != manager.insights.last?.id {
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
    }
}
