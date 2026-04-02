import SwiftUI

struct TerminalView: View {
    @ObservedObject var manager: TerminalManager
    @ObservedObject var lang: LanguageManager
    @State private var input: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeroBanner(
                title: lang.t("Test Lab"),
                subtitle: lang.t("Terminal Desc"),
                icon: "terminal.fill",
                color: .green
            )
            
            VStack(spacing: 0) {
                // Persistent Output Area
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(manager.output)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .id("Bottom")
                        }
                    }
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green.opacity(0.2), lineWidth: 1))
                    .onChange(of: manager.output) { _, _ in
                        withAnimation {
                            proxy.scrollTo("Bottom", anchor: .bottom)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                // Interactive Input Bar
                HStack(spacing: 12) {
                    Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold)).foregroundColor(.green)
                    
                    TextField(lang.t("Enter command"), text: $input)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.green)
                        .focused($isInputFocused)
                        .onSubmit {
                            if !input.isEmpty {
                                manager.sendInput(input)
                                input = ""
                            }
                        }
                    
                    if manager.isRunning {
                        Circle().fill(Color.green).frame(width: 8, height: 8)
                            .shadow(color: .green, radius: 4)
                    }
                    
                    Button(action: { manager.clear() }) {
                        Text(lang.t("Clear Console")).font(.system(size: 11)).foregroundColor(.secondary)
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                .background(Color.black.opacity(0.95))
                .cornerRadius(12)
                .padding(.top, 8)
            }
            
            HStack {
                Text("Session: \(manager.isRunning ? "Active (Bootstrapped)" : "Closed")")
                    .font(.system(size: 10, design: .monospaced)).foregroundColor(.secondary)
                Spacer()
                Button(action: { manager.stop(); manager.startSession() }) {
                    Label("Restart Shell", systemImage: "arrow.clockwise.circle")
                        .font(.system(size: 11)).foregroundColor(.green)
                }.buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
        .onAppear {
            manager.startSession()
            isInputFocused = true
        }
    }
}
