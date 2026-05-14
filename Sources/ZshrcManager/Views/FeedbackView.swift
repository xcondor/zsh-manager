import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var lang: LanguageManager
    @State private var message: String = ""
    @State private var contact: String = ""
    @State private var isSending: Bool = false
    @State private var successSent: Bool = false
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
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("Contact Information (Optional)"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    TextField(lang.t("Your email or name..."), text: $contact)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.t("Message Details"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $message)
                        .font(.system(size: 13))
                        .padding(12)
                        .frame(minHeight: 180)
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
                
                if successSent {
                    HStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        Text(lang.t("Feedback Sent Successfully!")).foregroundColor(.green).font(.system(size: 13, weight: .bold))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
                
                GlowButton(
                    label: isSending ? lang.t("Sending...") : lang.t("Submit Feedback"),
                    icon: "paperplane.fill",
                    color: .purple,
                    isLoading: isSending
                ) {
                    submitFeedback()
                }
                .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
                
                VStack(alignment: .leading, spacing: 15) {
                    Divider().padding(.vertical, 10)
                    Text(lang.t("Other ways to contact"))
                        .font(.system(size: 14, weight: .bold))
                    
                    HStack(spacing: 12) {
                        Text("musayp9527@gmail.com")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.blue)
                            .onTapGesture { copyEmail() }
                        
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
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(lang.t("Error")), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func copyEmail() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString("musayp9527@gmail.com", forType: .string)
        withAnimation { emailCopied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { withAnimation { emailCopied = false } }
    }
    
    private func submitFeedback() {
        guard !message.isEmpty else { return }
        isSending = true
        successSent = false
        
        let url = URL(string: "https://maczsh.com/api/feedback")! // Updated to correct production domain
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "message": message,
            "contact": contact,
            "version": "2.1.0",
            "platform": "macOS"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSending = false
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    successSent = true
                    message = ""
                    contact = ""
                    // Hide success message after 5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation { successSent = false }
                    }
                } else {
                    alertMessage = "Failed to submit feedback. Please try again later."
                    showAlert = true
                }
            }
        }.resume()
    }
}
