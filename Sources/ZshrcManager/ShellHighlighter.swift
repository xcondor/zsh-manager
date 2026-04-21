import SwiftUI

struct ShellLine: Identifiable {
    let id = UUID()
    let content: String
    let segments: [TextSegment]
}

struct TextSegment: Identifiable {
    let id = UUID()
    let text: String
    let color: Color
    var weight: Font.Weight = .regular
}

final class ShellHighlighter {
    static func highlight(text: String) -> [ShellLine] {
        let lines = text.components(separatedBy: .newlines)
        return lines.map { line -> ShellLine in
            let segments = highlightLine(line)
            return ShellLine(content: line, segments: segments)
        }
    }
    
    private static func highlightLine(_ line: String) -> [TextSegment] {
        var segments: [TextSegment] = []
        
        // 1. Handle Pre-segmentation (Diff style)
        var content = line
        var baseColor: Color = .white.opacity(0.9)
        
        if line.hasPrefix("+") {
            baseColor = .green
        } else if line.hasPrefix("-") {
            baseColor = .red
        } else if line.hasPrefix("@") {
            return [TextSegment(text: line, color: .blue.opacity(0.8), weight: .bold)]
        } else if line.hasPrefix("#") {
            return [TextSegment(text: line, color: .gray)]
        }
        
        // 2. Tokenize (Simple)
        let keywords = Set(["export", "alias", "if", "then", "else", "fi", "for", "in", "do", "done", "case", "esac", "source", "unalias"])
        
        // Iterate through characters for better precision
        var i = 0
        let chars = Array(line)
        var currentText = ""
        
        while i < chars.count {
            let c = chars[i]
            
            if c == "#" && i > 0 && chars[i-1].isWhitespace { // Comment
                if !currentText.isEmpty { segments.append(TextSegment(text: currentText, color: baseColor)) }
                segments.append(TextSegment(text: String(chars[i...]), color: .gray))
                return segments
            } else if c == "\"" || c == "'" { // String
                if !currentText.isEmpty { segments.append(TextSegment(text: currentText, color: baseColor)) }
                let (str, nextI) = captureString(chars, start: i)
                segments.append(TextSegment(text: str, color: .yellow))
                i = nextI
                currentText = ""
                continue
            } else if c == "$" { // Variable
                if !currentText.isEmpty { segments.append(TextSegment(text: currentText, color: baseColor)) }
                let (varStr, nextI) = captureVariable(chars, start: i)
                segments.append(TextSegment(text: varStr, color: .cyan, weight: .semibold))
                i = nextI
                currentText = ""
                continue
            }
            
            currentText.append(c)
            
            // Check for keywords
            if c.isWhitespace || i == chars.count - 1 {
                let trimmed = currentText.trimmingCharacters(in: .whitespaces)
                if keywords.contains(trimmed) {
                    let ws = currentText.hasSuffix(" ") ? " " : ""
                    segments.append(TextSegment(text: trimmed, color: .pink, weight: .bold))
                    if !ws.isEmpty { segments.append(TextSegment(text: ws, color: baseColor)) }
                    currentText = ""
                }
            }
            
            i += 1
        }
        
        if !currentText.isEmpty {
            segments.append(TextSegment(text: currentText, color: baseColor))
        }
        
        return segments
    }
    
    private static func captureString(_ chars: [Character], start: Int) -> (String, Int) {
        let quote = chars[start]
        var str = String(quote)
        var i = start + 1
        while i < chars.count {
            str.append(chars[i])
            if chars[i] == quote && chars[i-1] != "\\" {
                return (str, i + 1)
            }
            i += 1
        }
        return (str, i)
    }
    
    private static func captureVariable(_ chars: [Character], start: Int) -> (String, Int) {
        var str = "$"
        var i = start + 1
        if i < chars.count && chars[i] == "{" {
            while i < chars.count {
                str.append(chars[i])
                if chars[i] == "}" { return (str, i + 1) }
                i += 1
            }
        } else {
            while i < chars.count && (chars[i].isLetter || chars[i].isNumber || chars[i] == "_") {
                str.append(chars[i])
                i += 1
            }
        }
        return (str, i)
    }
}
