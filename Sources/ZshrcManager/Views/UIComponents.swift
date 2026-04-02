import SwiftUI

/// Premium UI Components: Glassmorphism, Hub-style accents
struct GlassCard<Content: View>: View {
    let content: Content
    var isSubtle: Bool = false
    
    init(isSubtle: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.isSubtle = isSubtle
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            Group {
                if isSubtle {
                    Color.white.opacity(0.02)
                } else {
                    Color.clear.background(.ultraThinMaterial)
                }
            }
        )
        .cornerRadius(12)
        // Premium 1px Inner Border
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.12), .white.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
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
                        .foregroundColor(.secondary)
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
                            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                pulse = 0.2
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
                Circle().fill(color.opacity(0.1)).frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
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
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.secondary)
            .padding(.leading, 4)
            .padding(.bottom, 4)
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 13, weight: .semibold))
                Text(label).font(.system(size: 13, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSubtle {
                        Color.white.opacity(0.05)
                    } else {
                        LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    }
                }
            )
            .foregroundColor(isSubtle ? .primary : .white)
            .cornerRadius(8)
            .shadow(color: isSubtle ? .clear : color.opacity(0.3), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSubtle ? Color.white.opacity(0.1) : Color.white.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct CustomTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String
    var icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 11, weight: .bold)).foregroundColor(.secondary)
            HStack(spacing: 12) {
                Image(systemName: icon).foregroundColor(.blue).frame(width: 20)
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.primary)
            }
            .padding(12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.08), lineWidth: 1))
        }
    }
}
struct ConfigInsightRow: View {
    let insight: ConfigInsight
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.1)).frame(width: 32, height: 32)
                Image(systemName: insight.icon).font(.system(size: 14)).foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(insight.description)
                    .font(.system(size: 13, weight: .bold))
                Text(insight.content)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(insight.category.uppercased())
                .font(.system(size: 8, weight: .black))
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
