import SwiftUI

struct PathListView: View {
    @ObservedObject var manager: PathManager
    @ObservedObject var lang: LanguageManager
    @State private var newPath = ""
    @State private var showRefreshReminder = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Path Manager"),
                    subtitle: lang.t("Manage shell search paths"),
                    icon: "folder.fill",
                    color: .blue
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
                            Image(systemName: "folder.fill").font(.system(size: 40)).foregroundColor(.blue.opacity(0.3))
                            Text(lang.t("Missing 'command not found'?")).font(.system(size: 16, weight: .bold))
                            Text(lang.t("PATH tells your Mac where to look for commands like 'npm' or 'python'.\nIf a tool isn't working, add its folder path here.")).font(.system(size: 13)).foregroundColor(.secondary).multilineTextAlignment(.center)
                            
                            GlowButton(label: lang.t("Add Common Path: /usr/local/bin"), icon: "plus.circle.fill", color: .blue) {
                                manager.addPath("/usr/local/bin")
                            }
                            .padding(.top, 10)
                        }
                        .padding(40)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(16)
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
        .onChange(of: manager.paths.count) {
            withAnimation { showRefreshReminder = true }
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
