import SwiftUI

struct AliasListView: View {
    @ObservedObject var manager: AliasManager
    @ObservedObject var lang: LanguageManager
    @State private var showingAddPopover = false
    @State private var editingAlias: AliasDefinition? = nil
    
    @State private var newName = ""
    @State private var newCommand = ""
    @State private var newDescription = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Aliases"),
                    subtitle: lang.t("Manage terminal shortcuts"),
                    icon: "bolt.fill",
                    color: .orange
                )
                
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
                            Spacer(minLength: 40)
                            Image(systemName: "bolt.slash.fill").font(.system(size: 40)).foregroundColor(.secondary.opacity(0.3))
                            Text(lang.t("No Aliases Found")).font(.system(size: 14)).foregroundColor(.secondary)
                            Spacer(minLength: 40)
                        }
                        .frame(maxWidth: .infinity)
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
            
            Image(systemName: "pencil").font(.system(size: 10)).foregroundColor(.secondary.opacity(0.3))
            
            Button(action: { manager.removeAlias(name: alias.name) }) {
                Image(systemName: "xmark.circle.fill").foregroundColor(.secondary.opacity(0.3))
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}
