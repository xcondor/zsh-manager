import SwiftUI

struct AICommandGeneratorSheet: View {
    @ObservedObject var aiManager: AIManager
    @ObservedObject var aliasManager: AliasManager
    @ObservedObject var lang: LanguageManager
    @Environment(\.dismiss) var dismiss
    
    @State private var userInput: String = ""
    @State private var generatedCommand: String = ""
    @State private var errorMessage: String? = nil
    @State private var showingSettings: Bool = false
    @State private var isSaved: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeroBanner(
                title: lang.t("AI Assistant"),
                subtitle: lang.t("Ask AI to generate command"),
                icon: "sparkles",
                color: .indigo
            )
            
            VStack(alignment: .leading, spacing: 20) {
                if aiManager.apiKey.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "key.fill").font(.system(size: 32)).foregroundColor(.indigo)
                        Text(lang.t("API Key Required")).font(.headline)
                        GlowButton(label: lang.t("Configure API"), icon: "gearshape.fill", color: .indigo) {
                            showingSettings = true
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(lang.t("Type your requirement here")).font(.system(size: 13, weight: .bold))
                        
                        TextEditor(text: $userInput)
                            .font(.system(size: 13))
                            .frame(height: 80)
                            .padding(10)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        
                        HStack {
                            Spacer()
                            if aiManager.isProcessing {
                                ProgressView().scaleEffect(0.6)
                                Text(lang.t("AI is thinking")).font(.caption).foregroundColor(.secondary)
                            } else {
                                GlowButton(label: lang.t("Generate Command"), icon: "wand.and.stars", color: .indigo) {
                                    generate()
                                }
                                .disabled(userInput.isEmpty)
                            }
                        }
                    }
                    
                    if !generatedCommand.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ModernSectionHeader(title: "AI 生成的建议")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(generatedCommand)
                                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.indigo.opacity(0.3), lineWidth: 1))
                                
                                HStack(spacing: 12) {
                                    GlowButton(label: lang.t("Try in Terminal"), icon: "terminal.fill", color: .gray, isSubtle: true) {
                                        let task = Process()
                                        task.launchPath = "/usr/bin/open"
                                        task.arguments = ["-a", "Terminal", NSHomeDirectory()]
                                        try? task.run()
                                    }
                                    
                                    Spacer()
                                    
                                    if isSaved {
                                        Label(lang.t("Saved"), systemImage: "checkmark.circle.fill").foregroundColor(.green).font(.caption)
                                    } else {
                                        GlowButton(label: lang.t("Save as Alias"), icon: "plus.circle.fill", color: .green) {
                                            saveAsAlias()
                                        }
                                    }
                                }
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if let error = errorMessage {
                        Text(error).font(.caption).foregroundColor(.red).padding(.top, 4)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(lang.t("Cancel")) { dismiss() }.buttonStyle(.plain).foregroundColor(.secondary)
                    Spacer()
                    if !aiManager.apiKey.isEmpty {
                        Button(action: { showingSettings = true }) {
                            Image(systemName: "gearshape.fill").foregroundColor(.secondary)
                        }.buttonStyle(.plain)
                    }
                }
            }
            .padding(40)
        }
        .frame(width: 550, height: generatedCommand.isEmpty ? 450 : 650)
        .sheet(isPresented: $showingSettings) {
            AISettingsView(manager: aiManager, lang: lang)
        }
        .animation(.spring(), value: generatedCommand)
    }
    
    func generate() {
        errorMessage = nil
        aiManager.generateCommand(from: userInput) { result in
            switch result {
            case .success(let cmd):
                self.generatedCommand = cmd
                self.isSaved = false
            case .failure(let err):
                self.errorMessage = err.localizedDescription
            }
        }
    }
    
    func saveAsAlias() {
        // 自动提取一个短名称
        let suggestedName = "ai_cmd_\(Int.random(in: 100...999))"
        aliasManager.addAlias(name: suggestedName, command: generatedCommand, description: "Generated from: \(userInput)")
        isSaved = true
    }
}
