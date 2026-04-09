import SwiftUI

struct DiagnosticView: View {
    @ObservedObject var manager: DiagnosticManager
    @ObservedObject var shellManager: ShellManager
    @ObservedObject var aliasManager: AliasManager
    @ObservedObject var pathManager: PathManager
    @ObservedObject var lang: LanguageManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroBanner(
                    title: lang.t("Config Doctor"),
                    subtitle: lang.t("Scan and repair your terminal environment"),
                    icon: "stethoscope",
                    color: .red
                )
                
                HStack(spacing: 20) {
                    // 健康得分卡片
                    HealthScoreCard(score: manager.healthScore, isScanning: manager.isRunning, lang: lang) {
                        manager.runDiagnostics(shellManager: shellManager, pathManager: pathManager, aliasManager: aliasManager, lang: lang)
                    }
                    
                    // 概览统计
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(lang.t("Scan Results")).font(.system(size: 14, weight: .bold))
                            HStack(spacing: 20) {
                                StatItem(label: lang.t("Critical"), count: manager.issues.filter { $0.severity == .critical }.count, color: .red)
                                StatItem(label: lang.t("Warning"), count: manager.issues.filter { $0.severity == .warning }.count, color: .orange)
                                StatItem(label: "Info", count: manager.issues.filter { $0.severity == .info }.count, color: .blue)
                            }
                        }
                        .padding(20)
                    }
                }
                
                if manager.issues.isEmpty && !manager.isRunning {
                    emptyResultView
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        ModernSectionHeader(title: lang.t("Detailed Report"))
                        ForEach(manager.issues) { issue in
                            IssueCard(issue: issue, lang: lang) {
                                manager.applyFix(for: issue, shellManager: shellManager)
                                // 修复后自动重新扫描以更新状态
                                manager.runDiagnostics(shellManager: shellManager, pathManager: pathManager, aliasManager: aliasManager, lang: lang)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 60)
            }
            .padding(.horizontal, 40).padding(.top, 20).padding(.bottom, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            if manager.issues.isEmpty {
                manager.runDiagnostics(shellManager: shellManager, pathManager: pathManager, aliasManager: aliasManager, lang: lang)
            }
        }
    }
    
    var emptyResultView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundColor(.green.opacity(0.3))
            Text(lang.t("No issues found"))
                .font(.headline)
            Text("您的基础配置文件经过深度分析，暂未发现明显的性能隐患或配置冲突。")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }
}

struct HealthScoreCard: View {
    let score: Int
    let isScanning: Bool
    let lang: LanguageManager
    let action: () -> Void
    
    var body: some View {
        GlassCard {
            HStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.1), lineWidth: 10)
                        .frame(width: 100, height: 100)
                    Circle()
                        .trim(from: 0, to: CGFloat(score) / 100.0)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(score)")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                        Text("SCORE").font(.system(size: 10, weight: .bold)).foregroundColor(.secondary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(lang.t("Health Score")).font(.system(size: 16, weight: .bold))
                    GlowButton(
                        label: isScanning ? lang.t("Scanning...") : lang.t("Start Checkup"),
                        icon: isScanning ? "arrow.triangle.2.circlepath" : "magnifyingglass",
                        color: .red,
                        action: action
                    )
                }
            }
            .padding(20)
        }
    }
    
    var scoreColor: Color {
        if score >= 90 { return .green }
        if score >= 70 { return .orange }
        return .red
    }
}

struct IssueCard: View {
    let issue: DiagnosticIssue
    let lang: LanguageManager
    let onFix: () -> Void
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(issue.title, systemImage: iconName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(severityColor)
                    Spacer()
                    if issue.canFixAutomatically {
                        Button(action: onFix) {
                            Text(lang.t("Fix Now"))
                                .font(.system(size: 11, weight: .bold))
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Text(issue.description)
                    .font(.system(size: 13))
                    .foregroundColor(.primary.opacity(0.8))
                
                Divider().opacity(0.1)
                
                HStack(alignment: .top) {
                    Image(systemName: "lightbulb.fill").foregroundColor(.yellow).font(.system(size: 12))
                    Text(issue.suggestion)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
        }
    }
    
    var severityColor: Color {
        switch issue.severity {
        case .critical: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
    
    var iconName: String {
        switch issue.severity {
        case .critical: return "exclamationmark.shield.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

struct StatItem: View {
    let label: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 10, weight: .bold)).foregroundColor(.secondary)
            Text("\(count)").font(.system(size: 24, weight: .black, design: .rounded)).foregroundColor(color)
        }
    }
}
