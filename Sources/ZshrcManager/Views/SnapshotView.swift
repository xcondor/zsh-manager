import SwiftUI

struct SnapshotView: View {
    @ObservedObject var manager: SnapshotManager
    @ObservedObject var lang: LanguageManager
    @State private var showingAddPopover = false
    @State private var newSnapshotName = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Snapshots"),
                    subtitle: lang.t("Configuration restore points"),
                    icon: "clock.arrow.circlepath",
                    color: .purple
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        ModernSectionHeader(title: lang.t("Archive"))
                        Spacer()
                        GlowButton(label: lang.t("Take Snapshot"), icon: "camera.viewfinder", color: .purple) {
                            showingAddPopover.toggle()
                        }
                    }
                    
                    if manager.snapshots.isEmpty {
                        VStack(spacing: 20) {
                            Spacer(minLength: 40)
                            Image(systemName: "camera.shutter.button.fill").font(.system(size: 40)).foregroundColor(.secondary.opacity(0.3))
                            Text(lang.t("No Snapshots Found")).font(.system(size: 14)).foregroundColor(.secondary)
                            Spacer(minLength: 40)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        GlassCard {
                            ForEach(manager.snapshots) { snapshot in
                                VStack(spacing: 0) {
                                    SnapshotRow(snapshot: snapshot, manager: manager, lang: lang)
                                    if snapshot.id != manager.snapshots.last?.id {
                                        ModernDivider()
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: 800, alignment: .leading)
        }
        .sheet(isPresented: $showingAddPopover) {
            VStack(spacing: 20) {
                HeroBanner(title: lang.t("New Snapshot"), subtitle: "Save current state", icon: "camera.shutter.button.fill", color: .purple)
                CustomTextField(label: lang.t("Snapshot Name"), text: $newSnapshotName, placeholder: "(Optional) e.g. Pre-Python Install", icon: "tag.fill")
                HStack {
                    Button(lang.t("Cancel")) { showingAddPopover = false }.buttonStyle(.plain).foregroundColor(.secondary)
                    Spacer()
                    GlowButton(label: lang.t("Save Snapshot"), icon: "checkmark.circle.fill", color: .purple) {
                        manager.createSnapshot(name: newSnapshotName.isEmpty ? nil : newSnapshotName)
                        newSnapshotName = ""
                        showingAddPopover = false
                    }
                }
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(width: 450)
        }
    }
}

struct SnapshotRow: View {
    let snapshot: Snapshot
    @ObservedObject var manager: SnapshotManager
    let lang: LanguageManager
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(snapshot.name).font(.system(size: 14, weight: .bold))
                Text(snapshot.date.formatted(date: .abbreviated, time: .shortened)).font(.system(size: 11)).foregroundColor(.secondary)
            }
            Spacer()
            HStack(spacing: 12) {
                Button(action: { manager.restoreSnapshot(snapshot) }) {
                    Label(lang.t("Restore"), systemImage: "arrow.counterclockwise").font(.system(size: 12, weight: .semibold))
                }.buttonStyle(.bordered).tint(.purple)
                
                Button(action: { manager.deleteSnapshot(snapshot) }) {
                    Image(systemName: "trash").foregroundColor(.secondary.opacity(0.3))
                }.buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
    }
}
