import SwiftUI

struct AliasListView: View {
    @ObservedObject var manager: AliasManager
    @ObservedObject var lang: LanguageManager
    @State private var showingAddPopover = false
    @State private var editingAlias: AliasDefinition? = nil
    
    @State private var newName = ""
    @State private var newCommand = ""
    @State private var newDescription = ""
    
    @State private var showRefreshReminder = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Aliases"),
                    subtitle: lang.t("Manage terminal shortcuts"),
                    icon: "bolt.fill",
                    color: .orange
                )
                
                if showRefreshReminder {
                    HStack {
                        Image(systemName: "info.circle.fill").foregroundColor(.green)
                        Text(lang.t("Refresh_Reminder")).font(.system(size: 13, weight: .bold))
                        Spacer()
                        Button(action: {
                            let task = Process()
                            task.launchPath = "/usr/bin/open"
                            task.arguments = ["-a", "Terminal", NSHomeDirectory()]
                            try? task.run()
                            withAnimation { showRefreshReminder = false }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "terminal.fill")
                                Text(lang.t("Launch_Terminal"))
                            }
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(6)
                            .foregroundColor(.green)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green.opacity(0.3), lineWidth: 1))
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        ModernSectionHeader(title: lang.t("Active Aliases"))
                        Spacer()
                        GlowButton(label: lang.t("Add Alias"), icon: "plus.circle.fill", color: .orange) {
                            showingAddPopover.toggle()
                        }
                    }
                    
                    if manager.aliases.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "bolt.fill").font(.system(size: 40)).foregroundColor(.orange.opacity(0.3))
                            Text(lang.t("What is a Shortcut?")).font(.system(size: 16, weight: .bold))
                            Text(lang.t("Save time by typing a short word instead of a long, complicated command.")).font(.system(size: 13)).foregroundColor(.secondary).multilineTextAlignment(.center)
                            
                            HStack(alignment: .center, spacing: 6) {
                                Image(systemName: "circle.grid.2x1.fill")
                                Text(lang.t("Drag to see more presets"))
                            }
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.orange.opacity(0.8))
                            .padding(.top, 10)
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack(spacing: 16) {
                                    QuickPresetAliasButton(title: lang.t("Flush DNS"), command: "sudo dscacheutil -flushcache") { manager.addAlias(name: "flushdns", command: "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder", description: lang.t("Clear Mac DNS Cache")) }
                                    QuickPresetAliasButton(title: lang.t("Git Status"), command: "git status") { manager.addAlias(name: "gs", command: "git status", description: lang.t("Quick Git Status")) }
                                    QuickPresetAliasButton(title: lang.t("Show Hidden"), command: "defaults write com.apple.finder AppleShowAllFiles YES") { manager.addAlias(name: "showhidden", command: "defaults write com.apple.finder AppleShowAllFiles YES; killall Finder", description: lang.t("Show Hidden Files")) }
                                    QuickPresetAliasButton(title: lang.t("Update Brew"), command: "brew update && brew upgrade") { manager.addAlias(name: "brewup", command: "brew update && brew upgrade", description: lang.t("Update and Upgrade Homebrew")) }
                                    QuickPresetAliasButton(title: lang.t("Clear Trash"), command: "rm -rf ~/.Trash/*") { manager.addAlias(name: "empty", command: "rm -rf ~/.Trash/*", description: lang.t("Empty Trash Bin")) }
                                    QuickPresetAliasButton(title: lang.t("My Public IP"), command: "curl ifconfig.me") { manager.addAlias(name: "myip", command: "curl ifconfig.me", description: lang.t("Get public IP address")) }
                                }
                                .padding(.horizontal, 4)
                                .padding(.bottom, 12)
                            }
                        }
                        .padding(40)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.05))
                        .cornerRadius(16)
                    } else {
                        GlassCard {
                            ForEach(manager.aliases) { alias in
                                VStack(spacing: 0) {
                                    Button(action: { editingAlias = alias }) {
                                        AliasRow(alias: alias, manager: manager, lang: lang)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    if alias.id != manager.aliases.last?.id {
                                        ModernDivider()
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 24).padding(.bottom, 40)
            .frame(maxWidth: 800, alignment: .leading)
        }
        .onChange(of: manager.aliases.count) {
            withAnimation { showRefreshReminder = true }
        }
        .sheet(isPresented: $showingAddPopover) {
            AliasEditSheet(
                title: lang.t("New Alias"),
                name: $newName,
                command: $newCommand,
                description: $newDescription,
                lang: lang,
                onSave: {
                    manager.addAlias(name: newName, command: newCommand, description: newDescription)
                    newName = ""; newCommand = ""; newDescription = ""
                    showingAddPopover = false
                },
                onCancel: { showingAddPopover = false }
            )
        }
        .sheet(item: $editingAlias) { alias in
            EditExistingAliasSheet(alias: alias, manager: manager, lang: lang) {
                editingAlias = nil
            }
        }
    }
}

struct AliasEditSheet: View {
    let title: String
    @Binding var name: String
    @Binding var command: String
    @Binding var description: String
    let lang: LanguageManager
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HeroBanner(title: title, subtitle: "Configure command shortcut", icon: "bolt.badge.a.fill", color: .orange)
            VStack(spacing: 20) {
                CustomTextField(label: lang.t("Alias Name"), text: $name, placeholder: "e.g. gs", icon: "terminal.fill")
                CustomTextField(label: lang.t("Command"), text: $command, placeholder: "e.g. git status", icon: "command")
            }
            HStack {
                Button(lang.t("Cancel")) { onCancel() }.buttonStyle(.plain).foregroundColor(.secondary)
                Spacer()
                GlowButton(label: lang.t("Save"), icon: "checkmark.circle.fill", color: .orange, action: onSave)
            }
        }
        .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40).frame(width: 450)
    }
}

struct EditExistingAliasSheet: View {
    let alias: AliasDefinition
    @ObservedObject var manager: AliasManager
    let lang: LanguageManager
    let onDismiss: () -> Void
    
    @State private var name: String = ""
    @State private var command: String = ""
    @State private var description: String = ""
    
    init(alias: AliasDefinition, manager: AliasManager, lang: LanguageManager, onDismiss: @escaping () -> Void) {
        self.alias = alias
        self.manager = manager
        self.lang = lang
        self.onDismiss = onDismiss
        _name = State(initialValue: alias.name)
        _command = State(initialValue: alias.command)
        _description = State(initialValue: alias.description ?? "")
    }
    
    var body: some View {
        AliasEditSheet(
            title: "Edit Alias",
            name: $name,
            command: $command,
            description: $description,
            lang: lang,
            onSave: {
                manager.updateAlias(oldName: alias.name, name: name, command: command, description: description)
                onDismiss()
            },
            onCancel: onDismiss
        )
    }
}

struct AliasRow: View {
    let alias: AliasDefinition
    @ObservedObject var manager: AliasManager
    let lang: LanguageManager
    
    // Oh, I used ObservedObject var lang: LanguageManager.
    
    var body: some View {
        // I'll just use the view logic directly.
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(alias.name).font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(.orange)
                    Text("→").font(.system(size: 12)).foregroundColor(.secondary)
                    Text(alias.command).font(.system(size: 13, weight: .medium, design: .monospaced))
                }
            }
            Spacer()
            
            Button(action: { 
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(alias.name, forType: .string)
            }) {
                Image(systemName: "doc.on.doc").font(.system(size: 11)).foregroundColor(.secondary.opacity(0.4))
            }.buttonStyle(.plain)
            
            Image(systemName: "pencil").font(.system(size: 10)).foregroundColor(.secondary.opacity(0.3))
            
            Button(action: { manager.removeAlias(name: alias.name) }) {
                Image(systemName: "xmark.circle.fill").foregroundColor(.secondary.opacity(0.3))
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

struct QuickPresetAliasButton: View {
    let title: String
    let command: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title).font(.system(size: 13, weight: .bold))
                    Spacer()
                    Image(systemName: "plus.circle.fill").foregroundColor(.orange)
                }
                Text(command).font(.system(size: 10, design: .monospaced)).foregroundColor(.secondary).lineLimit(1)
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
