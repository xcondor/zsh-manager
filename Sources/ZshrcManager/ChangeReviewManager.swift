import Foundation
import SwiftUI

struct FileChangeProposal: Identifiable {
    let id: UUID
    let title: String
    let filePath: String
    let beforeText: String
    let afterText: String
    let diffText: String
    let summaryKeys: [String]
    
    init(id: UUID = UUID(), title: String, filePath: String, beforeText: String, afterText: String, diffText: String, summaryKeys: [String] = []) {
        self.id = id
        self.title = title
        self.filePath = filePath
        self.beforeText = beforeText
        self.afterText = afterText
        self.diffText = diffText
        self.summaryKeys = summaryKeys
    }
}

@MainActor
final class ChangeReviewManager: ObservableObject {
    static let shared = ChangeReviewManager()
    
    @Published var pending: FileChangeProposal? = nil
    
    private var continuation: CheckedContinuation<Bool, Never>? = nil
    
    func requestApproval(title: String, filePath: String, beforeText: String, afterText: String) async -> Bool {
        if beforeText == afterText { return true }
        
        if continuation != nil { return false }
        
        let diff = Self.buildSimpleDiff(before: beforeText, after: afterText)
        let keys = Self.generateSmartSummary(before: beforeText, after: afterText)
        pending = FileChangeProposal(title: title, filePath: filePath, beforeText: beforeText, afterText: afterText, diffText: diff, summaryKeys: keys)
        
        return await withCheckedContinuation { cont in
            self.continuation = cont
        }
    }
    
    func approve() {
        let cont = continuation
        continuation = nil
        pending = nil
        cont?.resume(returning: true)
    }
    
    func reject() {
        let cont = continuation
        continuation = nil
        pending = nil
        cont?.resume(returning: false)
    }
    
    private static func buildSimpleDiff(before: String, after: String) -> String {
        let beforeLines = before.components(separatedBy: .newlines)
        let afterLines = after.components(separatedBy: .newlines)
        
        let prefix = commonPrefixCount(beforeLines, afterLines)
        let suffix = commonSuffixCount(beforeLines, afterLines, prefix: prefix)
        
        let beforeMidStart = prefix
        let beforeMidEnd = max(prefix, beforeLines.count - suffix)
        let afterMidStart = prefix
        let afterMidEnd = max(prefix, afterLines.count - suffix)
        
        let contextHead = min(prefix, 20)
        let contextTail = min(suffix, 20)
        
        var out: [String] = []
        out.append("--- BEFORE")
        out.append("+++ AFTER")
        
        if contextHead > 0 {
            out.append("")
            out.append("@@ Context (Top)")
            for i in (prefix - contextHead)..<prefix {
                if i >= 0 && i < beforeLines.count {
                    out.append("  \(beforeLines[i])")
                }
            }
        }
        
        out.append("")
        out.append("@@ Changes")
        
        if beforeMidStart < beforeMidEnd {
            for i in beforeMidStart..<beforeMidEnd {
                out.append("- \(beforeLines[i])")
            }
        }
        
        if afterMidStart < afterMidEnd {
            for i in afterMidStart..<afterMidEnd {
                out.append("+ \(afterLines[i])")
            }
        }
        
        if contextTail > 0 {
            out.append("")
            out.append("@@ Context (Bottom)")
            let beforeTailStart = max(0, beforeLines.count - suffix)
            let beforeTailEnd = beforeLines.count
            let start = max(beforeTailStart, beforeTailEnd - contextTail)
            if start < beforeTailEnd {
                for i in start..<beforeTailEnd {
                    out.append("  \(beforeLines[i])")
                }
            }
        }
        
        return out.joined(separator: "\n")
    }
    
    private static func generateSmartSummary(before: String, after: String) -> [String] {
        let beforeLines = before.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }
        let afterLines = after.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }
        
        let added = afterLines.filter { !beforeLines.contains($0) && !$0.isEmpty }
        let removed = beforeLines.filter { !afterLines.contains($0) && !$0.isEmpty }
        
        if added.isEmpty && removed.isEmpty { return ["No significant changes."] }
        
        var keys: [String] = []
        
        // 识别 Alias
        if added.contains(where: { $0.hasPrefix("alias") }) { keys.append("Defining_Aliases") }
        
        // 识别 PATH
        if added.contains(where: { $0.contains("export PATH=") }) { keys.append("Modifying_Path") }
        
        // 识别 Secret
        let secretKeywords = ["KEY", "TOKEN", "SECRET"]
        if added.contains(where: { line in secretKeywords.contains { line.uppercased().contains($0) } }) {
            keys.append("Adding_Secrets")
        }
        
        if keys.isEmpty {
            keys.append("General_Adjustment")
        }
        
        return keys
    }
    
    private static func commonPrefixCount(_ a: [String], _ b: [String]) -> Int {
        let n = min(a.count, b.count)
        var i = 0
        while i < n, a[i] == b[i] { i += 1 }
        return i
    }
    
    private static func commonSuffixCount(_ a: [String], _ b: [String], prefix: Int) -> Int {
        let maxSuffix = min(a.count, b.count) - prefix
        if maxSuffix <= 0 { return 0 }
        var i = 0
        while i < maxSuffix {
            let ai = a.count - 1 - i
            let bi = b.count - 1 - i
            if ai < prefix || bi < prefix { break }
            if a[ai] != b[bi] { break }
            i += 1
        }
        return i
    }
}

