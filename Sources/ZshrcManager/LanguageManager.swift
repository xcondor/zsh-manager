import Foundation
import SwiftUI

enum Language: String, Codable, CaseIterable {
    case en = "English"
    case zh = "简体中文"
}

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    // Translations Dictionary
    private let translations: [String: [Language: String]] = [
        "Status_Success": [.en: "Installation Successful!", .zh: "注入成功！"],
        "Status_Failed": [.en: "Operation Failed", .zh: "操作失败"],
        "Status_Uninstall": [.en: "Uninstalled from .zshrc", .zh: "已从 .zshrc 中卸载"],
        
        // Navigation & General
        "Overview": [.en: "Overview", .zh: "总览"],
        "Aliases": [.en: "Aliases", .zh: "别名 (Alias)"],
        "Path Manager": [.en: "Path Manager", .zh: "路径管理 (PATH)"],
        "Environments": [.en: "Environments", .zh: "环境探测"],
        "Config Doctor": [.en: "Config Doctor", .zh: "配置诊断 (Doctor)"],
        "Snapshots": [.en: "Snapshots", .zh: "配置快照 (Snapshot)"],
        "Settings & Tools": [.en: "Settings & Tools", .zh: "设置与工具"],
        
        // New UI Strings
        "Manage Aliases Desc": [.en: "Manage your terminal shorthand commands", .zh: "管理您的终端快捷命令"],
        "No Aliases Found": [.en: "No Aliases Found", .zh: "未发现别名配置"],
        "PATH Priority Desc": [.en: "Order and toggle your executable search paths", .zh: "管理并排序您的执行路径"],
        "Snapshots Desc": [.en: "Backup and restore your manager configurations", .zh: "备份与恢复您的配置快照"],
        "No Snapshots Found": [.en: "No Snapshots Found", .zh: "未发现快照"],
        "Diagnostic Report Desc": [.en: "System health check and diagnostic report", .zh: "系统健康检查与诊断报告"],
        "Injection Protection": [.en: "Injection Protection", .zh: "注入保护"],
        "Injection Desc": [.en: "Monitoring ~/.zshrc for local management", .zh: "监控 ~/.zshrc 以进行本地化管理"],
        "System Metrics": [.en: "System Metrics", .zh: "系统指标"],
        "Environment Detection": [.en: "Environment Detection", .zh: "环境检测"],
        "Functional List": [.en: "Functional List", .zh: "功能详情清单"],
        "Conflict Alerts": [.en: "Configuration Conflict Alerts", .zh: "配置文件冲突提示"],
        "Duplicate Variable": [.en: "Duplicate Variable", .zh: "变量定义重复"],
        "Duplicate Alias": [.en: "Duplicate Alias", .zh: "别名定义重复"],
        "No Tools Detected": [.en: "No supported tools detected on this system", .zh: "系统内未检测到受支持的开发工具"],
        "Manage in List": [.en: "Fix in Functional List", .zh: "去功能清单中处理"],
        "FAST INSTALL": [.en: "INSTALL", .zh: "极速安装"],
        "INSTALL": [.en: "INSTALL", .zh: "安装"],
        "Available Tools": [.en: "Available Tools", .zh: "可安装工具"],
        "Essentials": [.en: "Essentials", .zh: "基础服务"],
        "One-click install development environments": [.en: "One-click install development environments", .zh: "一键配置开发环境"],
        "Essential Services": [.en: "Essential Services", .zh: "基础服务安装"],
        "Installation Console": [.en: "Installation Console", .zh: "安装控制台"],
        "Already Installed": [.en: "Already Installed", .zh: "已安装"],
        "System Detected": [.en: "System Detected", .zh: "系统自动检测到"],
        "Ready": [.en: "Ready", .zh: "就绪"],
        "Configure": [.en: "Configure", .zh: "一键配置"],
        "Not Found": [.en: "Not Found", .zh: "未发现"],
        "Node Version Manager": [.en: "Node Version Manager", .zh: "Node 版本管理器"],
        "Java": [.en: "Java", .zh: "Java"],
        "Go": [.en: "Go", .zh: "Go"],
        "Rust": [.en: "Rust", .zh: "Rust"],
        "Flutter": [.en: "Flutter", .zh: "Flutter"],
        "Ruby": [.en: "Ruby", .zh: "Ruby"],
        "PHP": [.en: "PHP", .zh: "PHP"],
        "GCC": [.en: "GCC", .zh: "GCC Toolchain"],
        "JavaScript runtime": [.en: "JavaScript runtime", .zh: "JavaScript 运行时"],
        "Popular framework for Zsh": [.en: "Popular framework for Zsh", .zh: "流行的 Zsh 配置框架"],
        "Rust Language Environment": [.en: "Rust Language Environment", .zh: "Rust 语言环境"],
        "Modern containerization": [.en: "Modern containerization platform", .zh: "现代容器化平台"],
        "Fast package manager": [.en: "Fast package manager", .zh: "极速包管理器"],
        "Manage multiple Node.js versions easily": [.en: "Manage multiple Node.js versions easily", .zh: "便捷管理多个 Node.js 版本"],
        "Essential for modern web development": [.en: "Essential for modern web development", .zh: "现代 Web 开发必备"],
        "Beautiful themes and plugins": [.en: "Beautiful themes and plugins", .zh: "美观的主题与强大的插件"],
        "Modern and memory-safe": [.en: "Modern and memory-safe", .zh: "现代且内存安全性强"],
        "Run apps in consistent containers": [.en: "Run apps in consistent containers", .zh: "在一致的容器中运行应用"],
        "Advanced node package manager": [.en: "Advanced node package manager", .zh: "更先进的 Node 包管理器"],
        "The Missing Package Manager": [.en: "The Missing Package Manager for macOS", .zh: "macOS 必备包管理器"],
        "Essential for all other tools": [.en: "Essential for all other tools", .zh: "安装其他工具的基础"],
        "Migrate to Modules": [.en: "Migrate all to modular files", .zh: "一键迁移至模块化管理"],
        "Migration Log": [.en: "Last Migration Log", .zh: "最近迁移日志"],
        "Undo Migration": [.en: "Undo Migration", .zh: "撤销迁移"],
        "Items Migrated": [.en: "Items successfully moved to modules", .zh: "项配置已成功移至模块化管理"],
        "Expert Insight Report": [.en: "Functional List", .zh: "功能清单"],
        "Environment Detector": [.en: "Environment Detector", .zh: "系统环境监测"],
        "Reading profiles": [.en: "Reading shell profiles...", .zh: "正在读取系统配置文件..."],
        "System Config Path": [.en: "Current system configuration file is ", .zh: "当前系统的配置文件是 "],
        "Coming Soon": [.en: "Coming Soon", .zh: "敬请期待"],
        "Save": [.en: "Save", .zh: "保存"],
        "Cancel": [.en: "Cancel", .zh: "取消"],
        "Rescan": [.en: "Rescan", .zh: "重新扫描"],
        
        // Overview (ShellManager)
        "System Managed": [.en: "System Managed", .zh: "系统受控中"],
        "System Not Managed": [.en: "System Not Managed", .zh: "系统未受控"],
        "Inject into .zshrc": [.en: "Inject into .zshrc", .zh: "注入至 .zshrc"],
        "Uninstall (Restore .zshrc)": [.en: "Uninstall (Restore .zshrc)", .zh: "卸载 (还原 .zshrc)"],
        "Technical Summary": [.en: "Technical Summary", .zh: "技术实现摘要"],
        "Injection Line Intro": [.en: "Injects 'source ~/.zsh_manager/main.zsh' at the end of your .zshrc", .zh: "在 .zshrc 末尾注入 'source ~/.zsh_manager/main.zsh'"],
        "Manager Folder Desc": [.en: "Creates and manages configurations in ~/.zsh_manager/", .zh: "在 ~/.zsh_manager/ 中创建并管理具体配置"],
        "Original Preservation": [.en: "Ensures original .zshrc is preserved and readable", .zh: "确保原始 .zshrc 文件保持原样且可读"],
        
        // Aliases
        "Add Alias": [.en: "Add Alias", .zh: "添加别名"],
        "New Alias": [.en: "New Alias", .zh: "新建别名"],
        "Alias Name": [.en: "Alias Name", .zh: "别名名称"],
        "Command": [.en: "Command", .zh: "指令内容"],
        "Description (optional)": [.en: "Description (optional)", .zh: "备注 (可选)"],
        
        // PATH
        "PATH Priority": [.en: "PATH Priority (Top has highest priority)", .zh: "PATH 优先级 (越靠上优先级越高)"],
        "Add Path": [.en: "Add Path", .zh: "添加路径"],
        "Path does not exist": [.en: "Path does not exist", .zh: "路径不存在"],
        "Drag rows to reorder": [.en: "Drag rows to reorder priority", .zh: "拖拽行以调整优先级"],
        
        // Environment Detection
        "Environment Status": [.en: "Environment Status", .zh: "开发环境状态"],
        "Scanning...": [.en: "Scanning for Dev Tools...", .zh: "正在扫描开发工具..."],
        "Not Detected": [.en: "Not detected in standard paths", .zh: "未在标准路径中探测到"],
        "Auto-Config Template": [.en: "Auto-Config Template", .zh: "一键配置模板"],
        
        // Config Doctor (Diagnostics)
        "Analyzing...": [.en: "Analyzing config files...", .zh: "正在分析配置文件..."],
        "No issues detected": [.en: "No issues detected", .zh: "未发现问题"],
        "Healthy Desc": [.en: "Your managed configurations are healthy.", .zh: "当前受控配置运行良好。"],
        "Critical Issues": [.en: "Critical Issues (Fix Required)", .zh: "严重问题 (建议修复)"],
        "Warnings": [.en: "Warnings (Review Recommended)", .zh: "警告 (建议查看)"],
        "Optimizations": [.en: "Optimizations (Optional)", .zh: "优化建议 (可选)"],
        "Issue Injection": [.en: "Injection", .zh: "注入状态"],
        "Issue Aliases": [.en: "Aliases", .zh: "别名检查"],
        "Issue PATH": [.en: "PATH", .zh: "路径检查"],
        "Issue System": [.en: "System", .zh: "系统诊断"],
        "Run Scan": [.en: "Run Scan", .zh: "执行诊断"],
        
        // Diagnostic Messages
        "Diag_Injection_NotEnd": [.en: "Manager source line is not at the end of .zshrc", .zh: "管理器的 source 行不在 .zshrc 的末尾"],
        "Diag_Injection_NotEnd_Sug": [.en: "Move the source line to the end to ensure it can override other configurations.", .zh: "将 source 行移至末尾，以确保其能正确覆盖其他配置。"],
        "Diag_Alias_Duplicate": [.en: "Duplicate alias name found: ", .zh: "发现重复的别名名称: "],
        "Diag_Alias_Duplicate_Sug": [.en: "Rename one of the aliases to avoid terminal conflicts.", .zh: "重命名其中一个别名以避免终端冲突。"],
        "Diag_Path_Duplicate": [.en: "Duplicate path entry: ", .zh: "发现重复的路径条目: "],
        "Diag_Path_Duplicate_Sug": [.en: "Remove the duplicate entry to clean up your PATH variable.", .zh: "移除重复项以清理您的 PATH 变量。"],
        "Diag_Path_Invalid": [.en: "Invalid path: ", .zh: "无效的路径: "],
        "Diag_Path_Invalid_Sug": [.en: "The directory does not exist. Check for typos or remove the entry.", .zh: "该目录不存在。请检查拼写或移除该项。"],
        "Diag_Orphaned_File": [.en: "Orphaned config file found: ", .zh: "发现孤立的配置文件: "],
        "Diag_Orphaned_File_Sug": [.en: "This file is in the manager folder but not loaded. You may want to delete it or source it in main.zsh.", .zh: "该文件在管理目录中但未被加载。您可以删除它或将其加入 main.zsh 中引用。"],
        
        // Snapshots
        "Take Snapshot": [.en: "Take Snapshot", .zh: "拍摄快照"],
        "Create New Snapshot": [.en: "Create New Snapshot", .zh: "创建新快照"],
        "Snapshot Name": [.en: "Name (optional)", .zh: "快照名称 (可选)"],
        "Restore": [.en: "Restore", .zh: "恢复"],
        "Delete": [.en: "Delete", .zh: "删除"],
        "Select a category": [.en: "Select a category", .zh: "请选择一个分类"],
        
        // Detection
        "Preset Desc": [.en: "One-click tool configuration", .zh: "一键式工具配置"],
        "Inject Template": [.en: "Inject Template", .zh: "注入模板"],
        "Template Injected": [.en: "Template Injected! Restart terminal.", .zh: "模板已注入！请重启终端生效。"],
        "Presets": [.en: "Presets", .zh: "开发预设"],
        "Node.js (NVM)": [.en: "Node.js (NVM)", .zh: "Node.js (NVM)"],
        "Python (Pyenv)": [.en: "Python (Pyenv)", .zh: "Python (Pyenv)"],
        "Claude Code": [.en: "Claude Code", .zh: "Claude Code"],
        "OpenClaw": [.en: "OpenClaw", .zh: "OpenClaw"],
        "Gemini CLI": [.en: "Gemini CLI", .zh: "Gemini CLI"],
        
        // Terminal Test Lab
        "Test Lab": [.en: "Test Lab", .zh: "测试实验室"],
        "Console Output": [.en: "Console Output", .zh: "控制台输出"],
        "Terminal Desc": [.en: "Verify your configurations live", .zh: "实时验证您的配置生效情况"],
        "Run Command": [.en: "Run", .zh: "运行"],
        "Clear Console": [.en: "Clear", .zh: "清空"],
        "Enter command": [.en: "Enter zsh command...", .zh: "输入 zsh 指令..."],
        
        // Wizard
        "Status": [.en: "Status", .zh: "状态"],
        "Detecting": [.en: "Detecting tool...", .zh: "正在探测工具..."],
        "Configuring": [.en: "Applying configs...", .zh: "正在应用配置..."],
        "Verifying": [.en: "Verifying health...", .zh: "正在验证健康状况..."],
        "API Key Required": [.en: "API Key Required", .zh: "⚠️ 缺少 API Key"],
        "Key Missing Desc": [.en: "Set your API Key in the Aliases page to enable this tool.", .zh: "请前往“别名”页面设置您的真实 API Key 以启用此工具。"],
        
        // Missing Overview Strings
        "Management Engine": [.en: "Management Engine", .zh: "配置管理引擎"],
        "Live Metrics": [.en: "Live Metrics", .zh: "实时监控指标"],
        "System Fully Managed": [.en: "System Fully Managed", .zh: "系统已完全受控"],
        "Bridge Status": [.en: "Bridge Status", .zh: "通信桥接状态"],
        "Zsh communication health": [.en: "Zsh communication health", .zh: "Zsh 通信健康状况"],
        "Active": [.en: "Active", .zh: "运行中"],
        "Disabled": [.en: "Disabled", .zh: "已禁用"],
        "Ready to use": [.en: "Ready to use", .zh: "准备就绪"],
        "Analyzing System Health...": [.en: "Analyzing System Health...", .zh: "正在分析系统健康状况..."],
        "Diagnostic Findings": [.en: "Diagnostic Findings", .zh: "诊断发现"],
        "System Configuration Healthy": [.en: "System Configuration Healthy", .zh: "系统配置健康"],
        "No configuration issues detected in .zshrc": [.en: "No configuration issues detected in .zshrc", .zh: "在 .zshrc 中未检测到配置问题"],
        "Re-Run": [.en: "Re-Run", .zh: "重新运行"],
        
        // Shell Editor
        "Shell Editor": [.en: "Shell Editor", .zh: "Shell 配置编辑"],
        "Shell Editor Desc": [.en: "Toggle individual config lines on/off", .zh: "行级配置开关 (无需编辑文本)"],
        "Reload": [.en: "Reload", .zh: "重载内容"],
        "Search lines...": [.en: "Search configuration lines...", .zh: "搜索配置行..."],
        
        // New Environment Strings
        "System Environment Report": [.en: "System Environment Report", .zh: "系统环境报告"],
        "Run Check": [.en: "Run Check", .zh: "执行检测"],
        "Detection Results": [.en: "Detection Results", .zh: "检测结果"],
        "No report yet...": [.en: "No report yet...", .zh: "暂无报告..."],
        "Run env check to see detailed system report": [.en: "Run environment check to see detailed system report", .zh: "运行环境检测以查看详细的系统环境报告"],
        
        // Python Manager
        "Python Manager": [.en: "Python Manager", .zh: "Python 环境管理"],
        "Python Environment": [.en: "Python Environment", .zh: "Python 深度开发环境"],
        "Manage multiple Python versions with Pyenv": [.en: "Manage multiple Python versions with Pyenv", .zh: "通过 Pyenv 管理多个 Python 版本"],
        "Pyenv Not Installed": [.en: "Pyenv Not Installed", .zh: "未发现 Pyenv"],
        "Please install Pyenv in 'Essential Services' first.": [.en: "Please install Pyenv in 'Essential Services' first.", .zh: "请先在“基础服务”中安装 Pyenv"],
        "Installed Versions": [.en: "Installed Versions", .zh: "已安装版本"],
        "Global Version": [.en: "Global Version", .zh: "全局版本 (Global)"],
        "Set Global": [.en: "Set Global", .zh: "设为全局"],
        "Install New Version": [.en: "Install New Version", .zh: "安装新版本"],
        "Select Version": [.en: "Select Version", .zh: "选择版本"],
        "Download Mirror": [.en: "Download Mirror", .zh: "下载镜像源"],
        "Install Python": [.en: "Install Python", .zh: "执行安装"],
        "Pyenv Console": [.en: "Pyenv Terminal Logs", .zh: "Pyenv 终端输出日志"],
        "Huawei Cloud": [.en: "Huawei Cloud", .zh: "华为云镜像"],
        "Aliyun": [.en: "Aliyun", .zh: "阿里云镜像"],
        "Default": [.en: "Default (Original)", .zh: "默认 (官方源)"]
    ]

    init() {
        // 1. Try to load saved language
        if let saved = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let lang = Language(rawValue: saved) {
            self.currentLanguage = lang
        } else {
            // 2. Fallback to system auto-detection
            let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
            if languageCode.contains("zh") {
                self.currentLanguage = .zh
            } else {
                self.currentLanguage = .en
            }
        }
    }

    func t(_ key: String) -> String {
        guard let entry = translations[key] else {
            return key // Return key if translation missing
        }
        return entry[currentLanguage] ?? key
    }
}
