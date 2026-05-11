import SwiftUI

struct PythonView: View {
    @ObservedObject var manager: PythonManager
    @ObservedObject var lang: LanguageManager
    @State private var selectedNewVersion = ""
    @State private var selectedMirror = "Default"
    
    var body: some View {
        ProGateView(title: lang.t("Python Environment")) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HeroBanner(
                        title: lang.t("Python Environment"),
                        subtitle: lang.t("Manage multiple Python versions with Pyenv"),
                        icon: "pyramid.fill",
                        color: .blue
                    )
                    
                    if !manager.isPyenvInstalled {
                        VStack(spacing: 30) {
                            GlassCard {
                                VStack(spacing: 24) {
                                    ZStack {
                                        Circle().fill(Color.orange.opacity(0.1)).frame(width: 80, height: 80)
                                        Image(systemName: "pyramid.fill").font(.system(size: 40)).foregroundColor(.orange)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Text(lang.t("Pyenv Not Installed")).font(.system(size: 20, weight: .bold))
                                        Text(lang.t("Python_Onboarding_Desc")).font(.system(size: 14)).foregroundColor(.secondary)
                                            .multilineTextAlignment(.center).padding(.horizontal, 20)
                                    }
                                    
                                    if let sysVer = manager.systemPythonVersion {
                                        HStack(spacing: 12) {
                                            Image(systemName: "applelogo").foregroundColor(.secondary)
                                            Text("\(lang.t("System Python Found")): \(sysVer)")
                                                .font(.system(size: 13, weight: .medium)).foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, 16).padding(.vertical, 8)
                                        .background(Color.secondary.opacity(0.05)).cornerRadius(20)
                                    }
                                    
                                    Divider().padding(.horizontal, 40)
                                    
                                    VStack(spacing: 16) {
                                        GlowButton(
                                            label: lang.t("Install Pyenv Now"),
                                            icon: "arrow.down.circle.fill",
                                            color: .blue,
                                            action: {
                                                if let service = AppState.shared.serviceManager.services.first(where: { $0.id == "pyenv" }) {
                                                    AppState.shared.serviceManager.install(service: service)
                                                }
                                            }
                                        )
                                        .disabled(AppState.shared.serviceManager.isInstalling)
                                        
                                        Text(lang.t("Recommended for Developers"))
                                            .font(.system(size: 11, weight: .bold)).foregroundColor(.blue.opacity(0.8))
                                    }
                                }
                                .padding(40)
                            }
                            
                            if AppState.shared.serviceManager.isInstalling {
                                    VStack(alignment: .leading, spacing: 12) {
                                        ModernSectionHeader(title: lang.t("Installation Console"))
                                        ConsoleOutputView(text: AppState.shared.serviceManager.installationOutput)
                                            .frame(height: 200)
                                    }
                            }
                        }
                    } else {
                        HStack(alignment: .top, spacing: 24) {
                            // Installed Versions
                            VStack(alignment: .leading, spacing: 16) {
                                ModernSectionHeader(title: lang.t("Installed Versions"))
                                ForEach(manager.installedVersions) { version in
                                    GlassCard {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(version.id).font(.system(size: 14, weight: .bold))
                                                if version.isGlobal {
                                                    Text(lang.t("Global Version")).font(.system(size: 10)).foregroundColor(.blue)
                                                }
                                            }
                                            Spacer()
                                            if !version.isGlobal {
                                                Button(action: { manager.setGlobal(version.id) }) {
                                                    Text(lang.t("Set Global")).font(.system(size: 10, weight: .bold))
                                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                                        .background(Color.blue.opacity(0.1)).cornerRadius(4)
                                                }
                                                .buttonStyle(.plain).foregroundColor(.blue)
                                            } else {
                                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                            }
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Installation and Mirrors
                            VStack(alignment: .leading, spacing: 16) {
                                ModernSectionHeader(title: lang.t("Install New Version"))
                                GlassCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text(lang.t("Select Version")).font(.system(size: 12, weight: .bold))
                                        Picker("", selection: $selectedNewVersion) {
                                            Text(lang.t("Select...")).tag("")
                                            ForEach(manager.availableVersions, id: \.self) { v in
                                                Text(v).tag(v)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        
                                        Divider().opacity(0.1)
                                        
                                        Text(lang.t("Download Mirror")).font(.system(size: 12, weight: .bold))
                                        Picker("", selection: $selectedMirror) {
                                                ForEach(Array(manager.mirrors.keys).sorted(), id: \.self) { name in
                                                    Text(lang.t(name)).tag(name)
                                                }
                                        }
                                        .pickerStyle(.radioGroup)
                                        .horizontalRadioGroup() // Custom helper if exists, otherwise normal
                                        
                                        GlowButton(
                                            label: lang.t("Install Python"),
                                            icon: "arrow.down.circle.fill",
                                            color: .blue,
                                            action: { 
                                                manager.selectedMirror = manager.mirrors[selectedMirror] ?? nil
                                                manager.installVersion(selectedNewVersion) 
                                            }
                                        )
                                        .disabled(selectedNewVersion.isEmpty || manager.isInstalling)
                                        .opacity(selectedNewVersion.isEmpty || manager.isInstalling ? 0.5 : 1)
                                    }
                                    .padding(20)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Advanced Tools Section
                        VStack(alignment: .leading, spacing: 16) {
                            ModernSectionHeader(title: lang.t("Python Advanced Tools"))
                            GlassCard {
                                VStack(alignment: .leading, spacing: 20) {
                                    Toggle(isOn: $manager.isPipFixEnabled) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lang.t("Pip Fix (PEP 668)")).font(.system(size: 14, weight: .bold))
                                            Text(lang.t("Pip Fix Desc")).font(.system(size: 12)).foregroundColor(.secondary)
                                        }
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                    
                                    Divider().opacity(0.1)
                                    
                                    Toggle(isOn: $manager.isVenvShortcutEnabled) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(lang.t("Smart Venv Shortcut")).font(.system(size: 14, weight: .bold))
                                            Text(lang.t("Smart Venv Desc")).font(.system(size: 12)).foregroundColor(.secondary)
                                        }
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                    
                                    HStack {
                                        if manager.showApplySuccess {
                                            Label(lang.t("Python Fix Applied"), systemImage: "checkmark.circle.fill")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.green)
                                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                        }
                                        
                                        Spacer()
                                        
                                        GlowButton(
                                            label: lang.t("Apply Python Fixes"),
                                            icon: "sparkles",
                                            color: .orange,
                                            isSubtle: true,
                                            action: {
                                                withAnimation {
                                                    manager.applyAdvancedFixes()
                                                }
                                            }
                                        )
                                        .frame(width: 200)
                                    }
                                    .padding(.top, 10)
                                }
                                .padding(20)
                             }
                        }
                        
                        if !manager.installationOutput.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                ModernSectionHeader(title: lang.t("Pyenv Console"))
                                ConsoleOutputView(text: manager.installationOutput)
                            }
                        }
                    }
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 40).padding(.top, 24).padding(.bottom, 40)
            }
        }
        .onAppear { 
            manager.checkPyenv()
            manager.checkAdvancedSettings()
        }
    }
}

extension View {
    func horizontalRadioGroup() -> some View {
        return self // Simplified for now
    }
}
