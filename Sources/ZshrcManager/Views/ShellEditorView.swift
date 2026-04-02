import SwiftUI

struct ShellEditorView: View {
    @ObservedObject var manager: ShellManager
    @ObservedObject var lang: LanguageManager
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HeroBanner(
                title: lang.t("Shell Editor"),
                subtitle: lang.t("Shell Editor Desc"),
                icon: "square.and.pencil",
                color: .blue
            )
            
            VStack(alignment: .leading, spacing: 20) {
                // Header Info
                HStack {
                    Label(manager.currentShellPath, systemImage: "terminal.fill")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.blue.opacity(0.8))
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1)).cornerRadius(6)
                    Spacer()
                    Button(action: { manager.loadConfigLines() }) {
                        Label(lang.t("Reload"), systemImage: "arrow.clockwise")
                    }.buttonStyle(.plain).font(.system(size: 11)).foregroundColor(.secondary)
                }
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    TextField(lang.t("Search lines..."), text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13))
                }
                .padding(10)
                .background(Color.white.opacity(0.04))
                .cornerRadius(8)
                
                // List of Config Lines
                GlassCard {
                    List {
                        ForEach(filteredLines) { line in
                            ConfigLineRow(line: line, onToggle: {
                                manager.toggleLine(id: line.id)
                            })
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            ModernDivider()
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: 500)
                }
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
    }
    
    var filteredLines: [ConfigLine] {
        if searchText.isEmpty {
            return manager.configLines
        } else {
            return manager.configLines.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct ConfigLineRow: View {
    let line: ConfigLine
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Toggle("", isOn: Binding(
                get: { !line.isCommented },
                set: { _ in onToggle() }
            ))
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .labelsHidden()
            .scaleEffect(0.7)
            
            Text(line.isCommented ? "# " + line.content : line.content)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(line.isCommented ? .secondary : .primary)
                .strikethrough(line.isCommented)
                .lineLimit(1)
            
            Spacer()
            
            if line.isManagerInjected {
                Text("MANAGED")
                    .font(.system(size: 8, weight: .bold))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1)).foregroundColor(.blue)
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .opacity(line.content.trimmingCharacters(in: .whitespaces).isEmpty ? 0.3 : 1.0)
    }
}
