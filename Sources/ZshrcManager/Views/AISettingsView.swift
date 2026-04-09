import SwiftUI

struct AISettingsView: View {
    @ObservedObject var manager: AIManager
    @ObservedObject var lang: LanguageManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HeroBanner(
                title: lang.t("AI Settings"),
                subtitle: lang.t("Configure your API credentials"),
                icon: "key.fill",
                color: .indigo
            )
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("API Provider")).font(.system(size: 13, weight: .bold))
                    Picker("", selection: $manager.provider) {
                        ForEach(AIProvider.allCases, id: \.self) { provider in
                            Text(provider.rawValue).tag(provider)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("Enter your API Key")).font(.system(size: 13, weight: .bold))
                    HStack {
                        SecureField("API Key...", text: $manager.apiKey)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                    
                    Text("API Key 会加密保存在本地。建议使用 Gemini API (免费且快速)。")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                if manager.provider == .openai {
                    CustomTextField(label: "Custom Endpoint (Optional)", text: $manager.customEndpoint, placeholder: "https://api.openai.com/v1", icon: "link")
                }
                
                Spacer()
                
                HStack {
                    Button(lang.t("Cancel")) { dismiss() }
                        .buttonStyle(.plain)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    GlowButton(label: lang.t("Save"), icon: "checkmark.circle.fill", color: .indigo) {
                        manager.saveSettings()
                        dismiss()
                    }
                }
            }
            .padding(40)
        }
        .frame(width: 500, height: 550)
    }
}
