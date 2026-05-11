import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var lang: LanguageManager
    @ObservedObject var aiManager = AppState.shared.aiManager
    @ObservedObject var license = LicenseManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                HeroBanner(
                    title: lang.t("Settings"),
                    subtitle: lang.t("Global app configuration and preferences"),
                    icon: "gearshape.fill",
                    color: .gray
                )
                
                VStack(alignment: .leading, spacing: 24) {
                    // Language Section
                    VStack(alignment: .leading, spacing: 16) {
                        ModernSectionHeader(title: lang.t("Appearance & Language"))
                        GlassCard {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(lang.t("Display Language")).font(.system(size: 14, weight: .bold))
                                        Text(lang.t("Choose your preferred language for the interface")).font(.system(size: 12)).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Picker("", selection: $lang.currentLanguage) {
                                        ForEach(Language.allCases, id: \.self) { language in
                                            Text(language.rawValue).tag(language)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .frame(width: 150)
                                }
                            }
                            .padding(20)
                        }
                    }
                    
                    // AI Section
                    VStack(alignment: .leading, spacing: 16) {
                        ModernSectionHeader(title: lang.t("AI Integration"))
                        GlassCard {
                            VStack(alignment: .leading, spacing: 20) {
                                // AI Provider
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(lang.t("AI Provider")).font(.system(size: 14, weight: .bold))
                                        Text(lang.t("Select the AI engine for smart suggestions")).font(.system(size: 12)).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Picker("", selection: $aiManager.provider) {
                                        ForEach(AIProvider.allCases, id: \.self) { provider in
                                            Text(provider.rawValue).tag(provider)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .frame(width: 150)
                                }
                                
                                ModernDivider()
                                
                                // API Key
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(lang.t("API Key")).font(.system(size: 14, weight: .bold))
                                    HStack(spacing: 12) {
                                        Image(systemName: "key.fill").foregroundColor(.secondary).frame(width: 20)
                                        SecureField(lang.t("Enter your API key..."), text: $aiManager.apiKey)
                                            .textFieldStyle(.plain)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(8)
                                    
                                    Text(lang.t("AI_Key_Notice"))
                                        .font(.system(size: 11))
                                        .foregroundColor(.secondary)
                                }
                                
                                if aiManager.provider == .openai {
                                    ModernDivider()
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(lang.t("Custom Endpoint")).font(.system(size: 14, weight: .bold))
                                        HStack(spacing: 12) {
                                            Image(systemName: "link").foregroundColor(.secondary).frame(width: 20)
                                            TextField("https://api.openai.com/v1", text: $aiManager.customEndpoint)
                                                .textFieldStyle(.plain)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(8)
                                    }
                                }
                                
                                ModernDivider()
                                
                                HStack {
                                    Spacer()
                                    GlowButton(label: lang.t("Save Changes"), icon: "checkmark.circle.fill", color: .blue) {
                                        aiManager.saveSettings()
                                    }
                                }
                            }
                            .padding(20)
                        }
                    }
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 16) {
                        ModernSectionHeader(title: lang.t("About"))
                        GlassCard {
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Zshrc Manager").font(.system(size: 14, weight: .bold))
                                        Text("Version 1.2.0 (Build 20240427)").font(.system(size: 12)).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                
                                ModernDivider()
                                
                                HStack {
                                    Text(lang.t("Hardware ID")).font(.system(size: 12, weight: .bold))
                                    Spacer()
                                    Text(license.hardwareID).font(.system(size: 11, design: .monospaced)).foregroundColor(.secondary)
                                }
                            }
                            .padding(20)
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40)
            .padding(.top, 24)
            .padding(.bottom, 40)
            .frame(maxWidth: 800)
        }
    }
}
