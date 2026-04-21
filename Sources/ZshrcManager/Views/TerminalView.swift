import SwiftUI
#if os(macOS)
import AppKit
#endif

struct MacTerminalTextField: NSViewRepresentable {
    @Binding var text: String
    var isFocused: Bool
    var onCommit: () -> Void
    var placeholder: String
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.isBordered = false
        textField.drawsBackground = false
        textField.focusRingType = .none
        textField.placeholderString = placeholder
        textField.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        textField.textColor = .green
        textField.target = context.coordinator
        textField.action = #selector(Coordinator.performAction)
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
        
        if isFocused && nsView.window?.firstResponder != nsView {
            DispatchQueue.main.async {
                nsView.window?.makeFirstResponder(nsView)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: MacTerminalTextField
        
        init(_ parent: MacTerminalTextField) {
            self.parent = parent
        }
        
        @objc func performAction() {
            parent.onCommit()
        }
        
        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                parent.text = textField.stringValue
            }
        }
    }
}

struct TerminalView: View {
    @ObservedObject var manager: TerminalManager
    @EnvironmentObject var lang: LanguageManager
    var isEmbedded: Bool = false
    
    @State private var input: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: isEmbedded ? 12 : 16) {
            if !isEmbedded {
                HeroBanner(
                    title: lang.t("Test Lab"),
                    subtitle: lang.t("Terminal Desc"),
                    icon: "terminal.fill",
                    color: .green
                )
            }
            
            VStack(spacing: 0) {
                // Console Output
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(manager.output)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                                .id("terminal_bottom")
                        }
                        .padding(12)
                    }
                    .background(Color.black.opacity(0.03))
                    .cornerRadius(12)
                    .onChange(of: manager.output) { _ in
                        withAnimation {
                            proxy.scrollTo("terminal_bottom", anchor: .bottom)
                        }
                    }
                }
                .frame(maxHeight: isEmbedded ? 140 : .infinity)
                .layoutPriority(0)
                
                // Input Bar (Modernized)
                HStack(spacing: 12) {
                    Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundColor(.green)
                    
                    MacTerminalTextField(
                        text: $input,
                        isFocused: isInputFocused,
                        onCommit: {
                            if !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                manager.sendInput(input)
                                input = ""
                            }
                        },
                        placeholder: lang.t("Enter command")
                    )
                    .frame(height: 32)
                    .disabled(manager.isRunning)
                    .opacity(manager.isRunning ? 0.5 : 1.0)
                    
                    if manager.isRunning {
                        ProgressView().scaleEffect(0.5).frame(width: 16, height: 16)
                    }
                    
                    Button(action: { manager.clear() }) {
                        Text(lang.t("Clear Console")).font(.system(size: 11)).foregroundColor(.secondary)
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .background(Color.black.opacity(0.95))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isInputFocused ? Color.green.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1))
                .padding(.top, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    #if os(macOS)
                    NSApp.activate(ignoringOtherApps: true)
                    #endif
                    isInputFocused = true
                }
                .layoutPriority(1)
            }
            
            if !isEmbedded {
                HStack {
                    Text(lang.t("Console Output")).font(.system(size: 11, weight: .bold)).foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, isEmbedded ? 0 : 40)
        .padding(.top, isEmbedded ? 0 : 20)
        .padding(.bottom, isEmbedded ? 0 : 40)
        .onAppear {
            manager.startSession()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
    }
}
