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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(lang.t("API Provider"))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Picker("", selection: $manager.provider) {
                            ForEach(AIProvider.allCases, id: \.self) { provider in
                                Text(provider.rawValue).tag(provider)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(lang.t("Enter your API Key"))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            Image(systemName: "key.fill").foregroundColor(.indigo).frame(width: 24)
                            SecureField("API Key...", text: $manager.apiKey)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary.opacity(0.1), lineWidth: 1))
                    }
                    
                    CustomTextField(label: "Model Name (Optional)", text: $manager.modelName, placeholder: "e.g. gpt-4, claude-3-opus...", icon: "cpu")
                    
                    if manager.provider == .custom {
                        CustomTextField(label: lang.t("Custom Endpoint"), text: $manager.customEndpoint, placeholder: "https://api.your-proxy.com/v1/chat/completions", icon: "link")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            manager.testConnection { success, message in
                                manager.testResult = message
                            }
                        }) {
                            HStack {
                                if manager.isProcessing {
                                    ProgressView().controlSize(.small).padding(.trailing, 4)
                                }
                                Text("Test Connection")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.indigo.opacity(0.1))
                            .foregroundColor(.indigo)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .disabled(manager.apiKey.isEmpty || manager.isProcessing)
                        
                        if let result = manager.testResult {
                            Text(result)
                                .font(.system(size: 11))
                                .foregroundColor(result.contains("Successful") ? .green : .red)
                                .padding(.horizontal, 4)
                        }
                    }
                    
                    Text(lang.t("AI_Key_Notice"))
                        .font(.system(size: 10))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.top, 4)
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 32)
            }
            
            Divider().opacity(0.1)
            
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
            .padding(.horizontal, 48)
            .padding(.vertical, 24)
        }
        .frame(width: 550, height: 620)
    }
}
