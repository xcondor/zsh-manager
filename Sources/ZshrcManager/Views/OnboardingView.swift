import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @ObservedObject var lang: LanguageManager
    @State private var currentStep = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text("Skip")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .padding()
            }
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // Page 1: The Problem
                    OnboardingPage(
                        title: "Tired of breaking your terminal?",
                        subtitle: "Fixing 'Command not found' can be a nightmare. Configuring your Mac environment shouldn't feel like defusing a bomb.",
                        icon: "exclamationmark.triangle.fill",
                        iconColor: .orange
                    )
                    .frame(width: geometry.size.width)
                    
                    // Page 2: The Solution
                    OnboardingPage(
                        title: "Visual Environment Manager",
                        subtitle: "Zshrc Manager gives you a pristine dashboard to control your PATH, setup Aliases, and safely install Dev Tools like Python and Node.",
                        icon: "macwindow.badge.plus",
                        iconColor: .blue
                    )
                    .frame(width: geometry.size.width)
                    
                    // Page 3: The Safety
                    OnboardingPage(
                        title: "100% Safe & Non-Destructive",
                        subtitle: "We don't mess up your config. We install a single 'Shadow' line into your .zshrc, keeping your original code readable and untouched.",
                        icon: "lock.shield.fill",
                        iconColor: .green
                    )
                    .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width * 3, alignment: .leading)
                .offset(x: -CGFloat(currentStep) * geometry.size.width)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentStep)
            }
            .frame(height: 300)
            
            // Indicators
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(currentStep == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentStep == index ? 1.2 : 1.0)
                        .animation(.spring(), value: currentStep)
                }
            }
            .padding(.vertical, 20)
            
            // Action Button
            Button(action: {
                if currentStep < 2 {
                    withAnimation { currentStep += 1 }
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasCompletedOnboarding = true
                    }
                }
            }) {
                Text(currentStep < 2 ? "Next" : "Get Started")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(currentStep < 2 ? Color.blue.opacity(0.8) : Color.green)
                    .cornerRadius(10)
                    .shadow(color: (currentStep < 2 ? Color.blue : Color.green).opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 60)
            .padding(.bottom, 40)
        }
        .frame(width: 600, height: 450)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

struct OnboardingPage: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(iconColor)
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            Spacer()
        }
    }
}
