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
            
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("API Provider"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Picker("", selection: $manager.provider) {
                        ForEach(AIProvider.allCases, id: \.self) { provider in
                            Text(provider.rawValue).tag(provider)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(lang.t("Enter your API Key"))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Image(systemName: "key.fill").foregroundColor(.indigo).frame(width: 24)
                        SecureField("API Key...", text: $manager.apiKey)
                            .textFieldStyle(.plain)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
                    
                    Text(lang.t("API Key 会加密保存在本地。建议使用 Gemini API (免费且快速)。"))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.top, 4)
                }
                
                if manager.provider == .openai {
                    CustomTextField(label: lang.t("Custom Endpoint (Optional)"), text: $manager.customEndpoint, placeholder: "https://api.openai.com/v1", icon: "link")
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
            .padding(.horizontal, 48)
            .padding(.top, 32)
            .padding(.bottom, 40)
        }
        .frame(width: 550, height: 620)
    }
}
