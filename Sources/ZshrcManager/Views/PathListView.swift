import SwiftUI

struct PathListView: View {
    @ObservedObject var manager: PathManager
    @ObservedObject var lang: LanguageManager
    @State private var newPath = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Path Manager"),
                    subtitle: lang.t("Manage shell search paths"),
                    icon: "folder.fill",
                    color: .blue
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTextField(label: lang.t("Quick Add"), text: $newPath, placeholder: "e.g. /usr/local/bin or $HOME/bin", icon: "link")
                    GlowButton(label: lang.t("ADD PATH"), icon: "plus", color: .blue) {
                        if !newPath.isEmpty {
                            manager.addPath(newPath)
                            newPath = ""
                        }
                    }
                    
                    HStack {
                        ModernSectionHeader(title: lang.t("Registered Paths"))
                        Spacer()
                        Text("Drag to prioritize (Top-down)").font(.system(size: 10)).foregroundColor(.secondary)
                    }
                    
                    if manager.paths.isEmpty {
                        VStack(spacing: 20) {
                            Spacer(minLength: 40)
                            Image(systemName: "folder.badge.minus").font(.system(size: 40)).foregroundColor(.secondary.opacity(0.3))
                            Text(lang.t("No Paths Found")).font(.system(size: 14)).foregroundColor(.secondary)
                            Spacer(minLength: 40)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        GlassCard {
                            List {
                                ForEach(manager.paths) { entry in
                                    PathRow(entry: entry, manager: manager, lang: lang)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                }
                                .onMove { from, to in
                                    manager.move(fromOffsets: from, toOffset: to)
                                }
                                // Removing List separators and specific paddings to match GlassCard
                            }
                            .listStyle(.plain)
                            .frame(minHeight: CGFloat(manager.paths.count * 60))
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: 800, alignment: .leading)
        }
    }
}

struct PathRow: View {
    let entry: PathEntry
    @ObservedObject var manager: PathManager
    let lang: LanguageManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 10))
                .foregroundColor(.secondary.opacity(0.3))
                .padding(.leading, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    if entry.isDynamic ?? false {
                        Image(systemName: "terminal.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: entry.isValid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(entry.isValid ? .green : .red)
                    }
                    
                    Text(entry.path)
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(entry.isValid || (entry.isDynamic ?? false) ? .primary : .red.opacity(0.8))
                }
                
                if entry.isDynamic ?? false {
                    Text("Dynamic Shell Expression")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.blue.opacity(0.6))
                        .padding(.leading, 19)
                }
            }
            Spacer()
            
            Button(action: { 
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(entry.path, forType: .string)
            }) {
                Image(systemName: "doc.on.doc").font(.system(size: 11)).foregroundColor(.secondary.opacity(0.4))
            }.buttonStyle(.plain)
            
            Button(action: { manager.removePath(entry.path) }) {
                Image(systemName: "trash").font(.system(size: 11)).foregroundColor(.secondary.opacity(0.4))
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
    }
}
