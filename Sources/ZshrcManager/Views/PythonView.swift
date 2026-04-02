import SwiftUI

struct PythonView: View {
    @ObservedObject var manager: PythonManager
    @ObservedObject var lang: LanguageManager
    @State private var selectedNewVersion = ""
    @State private var selectedMirror = "Default"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeroBanner(
                    title: lang.t("Python Environment"),
                    subtitle: lang.t("Manage multiple Python versions with Pyenv"),
                    icon: "pyramid.fill",
                    color: .blue
                )
                
                if !manager.isPyenvInstalled {
                    GlassCard {
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 32)).foregroundColor(.orange)
                            Text(lang.t("Pyenv Not Installed")).font(.system(size: 16, weight: .bold))
                            Text(lang.t("Please install Pyenv in 'Essential Services' first.")).font(.system(size: 13)).foregroundColor(.secondary)
                        }
                        .padding(40)
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
        .onAppear { manager.checkPyenv() }
    }
}

extension View {
    func horizontalRadioGroup() -> some View {
        return self // Simplified for now
    }
}
