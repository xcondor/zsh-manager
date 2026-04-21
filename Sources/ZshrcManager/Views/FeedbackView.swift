import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var lang: LanguageManager
    @State private var message: String = ""
    @State private var isSending: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var emailCopied: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                HeroBanner(
                    title: lang.t("Support & Questions"),
                    subtitle: lang.t("Send Feedback"),
                    icon: "envelope.fill",
                    color: .purple
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(lang.t("Contact Support"))
                        .font(.system(size: 16, weight: .bold))
                    
                    HStack(spacing: 12) {
                        Text("musayp9527@gmail.com")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                copyEmail()
                            }
                        
                        Button(action: copyEmail) {
                            HStack(spacing: 4) {
                                Image(systemName: emailCopied ? "checkmark.circle.fill" : "doc.on.doc")
                                Text(emailCopied ? lang.t("Copied") : lang.t("Copy"))
                            }
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.blue)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("Message Details"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $message)
                        .font(.system(size: 13))
                        .padding(12)
                        .frame(minHeight: 200)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                    
                    Text(lang.t("Leave_Message_Help"))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                GlowButton(
                    label: isSending ? lang.t("Opening...") : lang.t("Send Feedback"),
                    icon: "paperplane.fill",
                    color: .purple,
                    isLoading: isSending
                ) {
                    sendEmail()
                }
                .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(lang.t("Email Error")),
                message: Text(alertMessage),
                primaryButton: .default(Text(lang.t("Copy Email Address"))) {
                    copyEmail()
                },
                secondaryButton: .cancel(Text(lang.t("Cancel")))
            )
        }
    }
    
    private func copyEmail() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString("musayp9527@gmail.com", forType: .string)
        
        withAnimation {
            emailCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                emailCopied = false
            }
        }
    }
    
    private func sendEmail() {
        isSending = true
        let recipient = "musayp9527@gmail.com"
        let subject = lang.t("Feedback_Email_Subject")
        let body = message
        
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = recipient
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]
        
        let success: Bool
        if let url = components.url {
            success = NSWorkspace.shared.open(url)
        } else {
            // Fallback for very long messages
            let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedBody = String(body.prefix(1000)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let fallbackString = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"
            if let fallbackUrl = URL(string: fallbackString) {
                success = NSWorkspace.shared.open(fallbackUrl)
            } else {
                success = false
            }
        }
        
        if !success {
            alertMessage = lang.t("Email_Fallback_Msg")
            showAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSending = false
        }
    }
}
