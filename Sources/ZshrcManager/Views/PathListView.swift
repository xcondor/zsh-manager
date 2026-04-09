import SwiftUI

struct PathListView: View {
    @ObservedObject var manager: PathManager
    @ObservedObject var lang: LanguageManager
    @State private var newPath = ""
    @State private var showRefreshReminder = false
    @State private var viewMode: Int = 0 // 0: Managed, 1: Live Analysis
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Path Manager"),
                    subtitle: lang.t("Manage shell search paths"),
                    icon: "folder.fill",
                    color: .blue
                )
                
                // 视图切换
                HStack {
                    Picker("", selection: $viewMode) {
                        Text(lang.t("Registered Paths")).tag(0)
                        Text(lang.t("Live Analysis")).tag(1)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 300)
                    
                    Spacer()
                    
                    if viewMode == 1 {
                        Button(action: { manager.refreshLivePath() }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text(lang.t("Rescan"))
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 10)
                
                if viewMode == 0 {
                    managedView
                } else {
                    liveAnalysisView
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: 800, alignment: .leading)
        }
        .onAppear {
            manager.refreshLivePath()
        }
        .onChange(of: manager.paths.count) {
            withAnimation { showRefreshReminder = true }
        }
    }
    
    var managedView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if showRefreshReminder {
                refreshReminderBar
            }
            
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
                Text(lang.t("Drag_to_prioritize")).font(.system(size: 10)).foregroundColor(.secondary)
            }
            
            if manager.paths.isEmpty {
                emptyPathView
            } else {
                GlassCard {
                    List {
                        ForEach(manager.paths) { entry in
                            PathRow(entry: entry, manager: manager, lang: lang, isLive: false)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                        .onMove { from, to in
                            manager.move(fromOffsets: from, toOffset: to)
                        }
                    }
                    .listStyle(.plain)
                    .frame(minHeight: CGFloat(max(1, manager.paths.count) * 60))
                }
            }
        }
    }
    
    var liveAnalysisView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ModernSectionHeader(title: lang.t("Priority Hierarchy"))
            Text(lang.t("Live_Analysis_Desc"))
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            GlassCard {
                VStack(spacing: 0) {
                    ForEach(Array(manager.sessionPaths.enumerated()), id: \.offset) { index, entry in
                        PathRow(entry: entry, manager: manager, lang: lang, isLive: true, rank: index + 1)
                        if index < manager.sessionPaths.count - 1 {
                            Divider().opacity(0.1).padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
    }
    
    var refreshReminderBar: some View {
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
    
    var emptyPathView: some View {
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
    }
}

struct PathRow: View {
    let entry: PathEntry
    @ObservedObject var manager: PathManager
    let lang: LanguageManager
    let isLive: Bool
    var rank: Int? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            if isLive, let rank = rank {
                Text("\(rank)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.2))
                    .frame(width: 20)
            } else {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.3))
                    .padding(.leading, 4)
            }
            
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
                        .lineLimit(1)
                }
                
                HStack(spacing: 10) {
                    // 来源标签
                    Text(lang.t(entry.source.rawValue))
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(sourceColor.opacity(0.1))
                        .foregroundColor(sourceColor)
                        .cornerRadius(4)
                    
                    if entry.isShadowed {
                        Label(lang.t("Shadowed"), systemImage: "layers.fill")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.orange.opacity(0.8))
                    }
                    
                    if !(entry.isValid) && !(entry.isDynamic ?? false) {
                        Text(lang.t("Path does not exist"))
                            .font(.system(size: 9))
                            .foregroundColor(.red.opacity(0.6))
                    }
                }
            }
            Spacer()
            
            if !isLive {
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
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
        .background(entry.isShadowed ? Color.black.opacity(0.05) : Color.clear)
    }
    
    var sourceColor: Color {
        switch entry.source {
        case .system: return .gray
        case .managed: return .blue
        case .user: return .orange
        }
    }
}
