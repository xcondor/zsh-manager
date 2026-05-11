import SwiftUI

/// Premium UI Components: Glassmorphism, Hub-style accents
struct GlassCard<Content: View>: View {
    let content: () -> Content
    var isSubtle: Bool = false
    var isHighContrast: Bool = false
    
    init(isSubtle: Bool = false, isHighContrast: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.isSubtle = isSubtle
        self.isHighContrast = isHighContrast
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .background(
            Group {
                if isHighContrast {
                    Color(NSColor.controlBackgroundColor)
                } else if isSubtle {
                    Color.primary.opacity(0.05)
                } else {
                    Color.primary.opacity(0.04).background(.ultraThinMaterial)
                }
            }
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(isHighContrast ? 0.3 : 0.2), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct StatusRow: View {
    let icon: String
    let title: String
    var description: String? = nil
    let statusText: String
    let statusColor: Color
    var isPulsing: Bool = false
    var showStatusText: Bool = true
    
    @State private var pulse = 0.6
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(statusColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                if let desc = description {
                    Text(desc)
                        .font(.system(size: 11))
                        .foregroundColor(.primary.opacity(0.7))
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                if showStatusText {
                    Text(statusText)
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(4)
                        .foregroundColor(statusColor)
                }
                
                if isPulsing {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .opacity(pulse)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                    pulse = 0.2
                                }
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

struct HeroBanner: View {
    let title: String
    let subtitle: String
    let icon: String
    var color: Color = .blue
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(color.opacity(0.1)).frame(width: 54, height: 54)
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }
            .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

struct ModernSectionHeader: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.secondary)
            .padding(.leading, 4)
            .padding(.bottom, 4)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 8) {
                ZStack {
                    Circle().fill(color.opacity(0.12)).frame(width: 24, height: 24)
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
            }
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Text("%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 6)
            }
            
            // Sub-accent line
            Capsule()
                .fill(color.opacity(0.3))
                .frame(height: 2)
                .frame(width: 40)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.white.opacity(0.03)
                .background(.ultraThinMaterial.opacity(0.5))
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct ModernDivider: View {
    var body: some View {
        Divider().background(Color.black.opacity(0.04)).padding(.leading, 60)
    }
}

struct GlowButton: View {
    let label: String
    let icon: String
    var color: Color = .blue
    var isSubtle: Bool = false
    var isLoading: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .scaleEffect(0.7)
                        .brightness(isSubtle ? 0 : 1)
                } else {
                    Image(systemName: icon).font(.system(size: 13, weight: .semibold))
                }
                Text(label).font(.system(size: 13, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSubtle {
                        Color.white.opacity(0.12)
                    } else {
                        LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    }
                }
            )
            .foregroundColor(isSubtle ? .primary : .white)
            .cornerRadius(8)
            .shadow(color: isSubtle ? .black.opacity(0.05) : color.opacity(0.3), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSubtle ? Color.white.opacity(0.2) : Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}

struct CustomTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 11, weight: .semibold)).foregroundColor(.secondary)
            HStack(spacing: 16) {
                Image(systemName: icon).foregroundColor(.blue).frame(width: 24)
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
        }
    }
}
struct ConfigInsightRow: View {
    let insight: ConfigInsight
    @EnvironmentObject var lang: LanguageManager
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.1)).frame(width: 32, height: 32)
                Image(systemName: insight.icon).font(.system(size: 14)).foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(lang.t(insight.description))
                    .font(.system(size: 13, weight: .semibold))
                Text(insight.content)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(lang.t(insight.category).uppercased())
                .font(.system(size: 8, weight: .semibold))
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(.vertical, 12)
    }
}

struct ConsoleOutputView: View {
    let text: String
    
    var body: some View {
        ScrollView {
            Text(text)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.green.opacity(0.8))
                .textSelection(.enabled)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 200)
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct LoadingOverlay: View {
    let message: String
    let subMessage: String?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                LoadingSpinner()
                
                VStack(spacing: 8) {
                    Text(message)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if let sub = subMessage {
                        Text(sub)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(40)
            .background(Color.white.opacity(0.05))
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
        }
    }
}

struct LoadingSpinner: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                style: StrokeStyle(lineWidth: 4, lineCap: .round)
            )
            .frame(width: 50, height: 50)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Commercialization Components

struct TrialWidget: View {
    @ObservedObject var license = LicenseManager.shared
    @EnvironmentObject var lang: LanguageManager
    var onUpgrade: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            statusIcon
            
            infoLabels
            
            Spacer()
            
            upgradeButton
        }
        .padding(12)
        .background(Color.black.opacity(0.04))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(license.status == .expired ? Color.red.opacity(0.2) : Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var statusIcon: some View {
        ZStack {
            Circle()
                .stroke(Color.primary.opacity(0.1), lineWidth: 3)
                .frame(width: 32, height: 32)
            
            if license.status == .expired {
                Circle()
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))
            } else {
                Circle()
                    .trim(from: 0, to: CGFloat(license.trialDaysRemaining) / 3.0)
                    .stroke(
                        LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))
            }
            
            if license.status == .expired {
                Image(systemName: "exclamationmark").font(.system(size: 10, weight: .bold)).foregroundColor(.red)
            } else if license.status == .licensed {
                Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.green)
            } else {
                Text("\(license.trialDaysRemaining)").font(.system(size: 12, weight: .bold))
            }
        }
    }
    
    @ViewBuilder
    private var infoLabels: some View {
        VStack(alignment: .leading, spacing: 2) {
            if license.status == .licensed {
                Text(lang.t("Pro Activated")).font(.system(size: 11, weight: .bold))
                Text(lang.t("Lifetime Licensed")).font(.system(size: 9)).foregroundColor(.secondary)
            } else {
                Text(license.status == .expired ? lang.t("Trial Expired") : lang.t("Trial Status"))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(license.status == .expired ? .red : .primary)
                
                Text("\(license.trialDaysRemaining) " + lang.t("Days Remaining"))
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var upgradeButton: some View {
        if license.status != .licensed {
            Button(action: onUpgrade) {
                Text(lang.t("Activate"))
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(4)
                    .foregroundColor(.orange)
            }
            .buttonStyle(.plain)
        }
    }
}

struct LicenseActivationSheet: View {
    @ObservedObject var license = LicenseManager.shared
    @EnvironmentObject var lang: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State private var licenseKey: String = ""
    @State private var error: String?
    @State private var isSuccess = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                // Key Icon
                Image(systemName: "key.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue.opacity(0.8))
                    .padding(.top, 10)
                
                // Title & Subtitle
                VStack(spacing: 8) {
                    Text(lang.t("Activate Zshrc Manager"))
                        .font(.system(size: 24, weight: .bold))
                    Text(lang.t("Enter your license key to unlock all features"))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)
                
                // Input Field
                VStack(alignment: .leading, spacing: 8) {
                    Text(lang.t("License Key"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    TextField("CLAW-XXXX-XXXX-XXXX-XXXX", text: $licenseKey)
                        .textFieldStyle(.plain)
                        .font(.system(size: 15, design: .monospaced))
                        .padding(12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue.opacity(0.3), lineWidth: 2))
                }
                
                if let err = error {
                    Text(err).font(.system(size: 11)).foregroundColor(.red)
                }
                
                // Activate Button
                Button(action: {
                    if license.activateLicense(key: licenseKey) {
                        isSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    } else {
                        error = lang.t("License Key is invalid")
                    }
                }) {
                    Text(lang.t("Activate License"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(licenseKey.count >= 8 ? Color.blue.opacity(0.8) : Color.blue.opacity(0.4))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(licenseKey.count < 8)
                
                // Hardware ID
                VStack(spacing: 4) {
                    Text(lang.t("Hardware ID"))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text(license.hardwareID)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(.secondary.opacity(0.8))
                }
                .padding(.top, 10)
                
                Divider().padding(.vertical, 10).opacity(0.5)
                
                // Footer
                HStack(spacing: 4) {
                    Text(lang.t("Don't have a license?"))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Button(action: {
                        if let url = URL(string: "https://www.maczsh.com/zshrc-manager") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Text(lang.t("Purchase for $18"))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
                
                Button(lang.t("Cancel")) { dismiss() }
                    .buttonStyle(.plain)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
            }
            .padding(40)
        }
        .frame(width: 440)
        .background(Color(NSColor.windowBackgroundColor))
        .overlay {
            if isSuccess {
                ZStack {
                    Color(NSColor.windowBackgroundColor).opacity(0.9)
                        .background(.ultraThinMaterial)
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill").font(.system(size: 64)).foregroundColor(.green)
                        Text(lang.t("Pro Activated")).font(.system(size: 24, weight: .bold))
                    }
                }
            }
        }
    }
}

struct ProGateView<Content: View>: View {
    @ObservedObject var license = LicenseManager.shared
    @EnvironmentObject var lang: LanguageManager
    let title: String
    let content: () -> Content
    
    @State private var showingActivation = false
    
    var body: some View {
        content()
    }
}
