import SwiftUI

struct AICommandGeneratorSheet: View {
    @ObservedObject var aiManager: AIManager
    @ObservedObject var aliasManager: AliasManager
    @ObservedObject var lang: LanguageManager
    @Environment(\.dismiss) var dismiss
    
    @State private var userInput = ""
    @State private var generatedCommand = ""
    @State private var errorMessage: String?
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(lang.t("AI Assistant"))
                        .font(.system(size: 24, weight: .bold))
                    Text(lang.t("Describe your needs in natural language"))
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 30))
                    .foregroundStyle(
                        LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: .indigo.opacity(0.4), radius: 10)
            }
            .padding(32)
            
            VStack(spacing: 24) {
                // Input Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("Example: Find files larger than 100MB..."))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.8))
                        .padding(.leading, 4)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(NSColor.controlBackgroundColor))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.1), lineWidth: 1))
                        
                        TextEditor(text: $userInput)
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(12)
                            .frame(height: 120)
                    }
                }
                
                // Action Button
                HStack {
                    if aiManager.apiKey.isEmpty {
                        HStack {
                            Image(systemName: "key.fill").foregroundColor(.orange)
                            Text(lang.t("Please set API Key in settings first")).font(.system(size: 12))
                        }
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    GlowButton(
                        label: lang.t("Generate Command"),
                        icon: "magicmouse.fill",
                        color: .indigo,
                        isLoading: aiManager.isProcessing
                    ) {
                        generate()
                    }
                    .disabled(userInput.isEmpty || aiManager.isProcessing)
                }
                
                // Result or Error Section
                if let error = errorMessage {
                    errorCard(error)
                } else if !generatedCommand.isEmpty {
                    resultCard
                }
            }
            .padding(.horizontal, 32)
            
            Spacer(minLength: 32)
            
            // Footer
            HStack {
                Button(lang.t("Cancel")) { dismiss() }
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary.opacity(0.8))
                
                Spacer()
                
                Button(action: { showingSettings = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "gearshape.fill")
                        Text(lang.t("Settings"))
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(32)
        }
        .frame(width: 650)
        .background(
            ZStack {
                Color(NSColor.windowBackgroundColor)
                RadialGradient(
                    colors: [.indigo.opacity(0.05), .clear],
                    center: .topTrailing,
                    startRadius: 0,
                    endRadius: 500
                )
            }
        )
        .sheet(isPresented: $showingSettings) {
            AISettingsView(manager: aiManager, lang: lang)
        }
    }
    
    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(lang.t("Generated Result"), systemImage: "terminal.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.indigo)
                Spacer()
                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(generatedCommand, forType: .string)
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 12))
                        .foregroundColor(.indigo)
                }
                .buttonStyle(.plain)
            }
            
            Text(generatedCommand)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .foregroundColor(.primary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.indigo.opacity(0.3), lineWidth: 1))
            
            Button(action: {
                aliasManager.addAlias(name: "cmd_\(Int.random(in: 100...999))", command: generatedCommand, description: userInput)
                dismiss()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text(lang.t("Save as Shortcut"))
                }
                .font(.system(size: 12, weight: .bold))
                .padding(.vertical, 8).padding(.horizontal, 16)
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.indigo.opacity(0.05))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.indigo.opacity(0.1), lineWidth: 1))
    }
    
    private func errorCard(_ error: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(lang.t("Execution Failed"))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.red)
                
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.red.opacity(0.8))
                    .textSelection(.enabled)
                    .lineLimit(5)
            }
            Spacer()
        }
        .padding(20)
        .background(Color.red.opacity(0.08))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.2), lineWidth: 1))
    }
    
    private func generate() {
        errorMessage = nil
        generatedCommand = ""
        
        aiManager.generateCommand(from: userInput) { result in
            switch result {
            case .success(let cmd):
                self.generatedCommand = cmd
            case .failure(let err):
                self.errorMessage = err.localizedDescription
            }
        }
    }
}
