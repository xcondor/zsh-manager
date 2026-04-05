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
        "Aliases": [.en: "Aliases", .zh: "快捷指令 (Aliases)"],
        "Path Manager": [.en: "Path Manager", .zh: "命令搜寻路径 (PATH)"],
        "Environments": [.en: "Environments", .zh: "一键环境安装 (Dev Tools)"],
        "Config Doctor": [.en: "Config Doctor", .zh: "环境修复 (一键扫描)"],
        "Snapshots": [.en: "Snapshots", .zh: "安全备份 (时光机)"],
        "Settings & Tools": [.en: "Settings & Tools", .zh: "实验室与高级工具"],
        "General": [.en: "General", .zh: "系统核心功能"],
        
        // New UI Strings
        "Manage Aliases Desc": [.en: "Manage your terminal shorthand commands", .zh: "管理您的终端快捷命令"],
        "No Aliases Found": [.en: "No Aliases Found", .zh: "未发现别名配置"],
        "PATH Priority Desc": [.en: "Order and toggle your executable search paths", .zh: "管理并排序您的执行路径"],
        "Snapshots Desc": [.en: "Backup and restore your manager configurations", .zh: "备份与恢复您的配置快照"],
        "No Snapshots Found": [.en: "No Snapshots Found", .zh: "未发现快照"],
        "Diagnostic Report Desc": [.en: "System health check and diagnostic report", .zh: "系统健康检查与诊断报告"],
        "Injection Protection": [.en: "Injection Protection", .zh: "安全隔离模式"],
        "Injection Desc": [.en: "Monitoring ~/.zshrc for local management", .zh: "我们在保护您的 ~/.zshrc，同时可视化管理您的底层配置。"],
        "System Metrics": [.en: "System Metrics", .zh: "系统指标"],
        "Environment Detection": [.en: "Environment Detection", .zh: "环境检测"],
        "Functional List": [.en: "Functional List", .zh: "高级底层代码 (慎点)"],
        "Conflict Alerts": [.en: "Configuration Conflict Alerts", .zh: "检测到代码冲突！(会让系统变慢或者报错)"],
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
        "System Managed": [.en: "System Managed", .zh: "终端管家正在保护中"],
        "System Not Managed": [.en: "System Not Managed", .zh: "系统处于裸奔状态"],
        "Inject into .zshrc": [.en: "Inject into .zshrc", .zh: "一键启动护城河接管"],
        "Uninstall (Restore .zshrc)": [.en: "Uninstall (Restore .zshrc)", .zh: "退出接管 (完全还原)"],
        "Technical Summary": [.en: "Technical Summary", .zh: "这是如何工作的？"],
        "Injection Line Intro": [.en: "Injects 'source ~/.zsh_manager/main.zsh' at the end of your .zshrc", .zh: "我们只会在您的配置文件最底部加一句短话，绝不碰您的历史代码。"],
        "Manager Folder Desc": [.en: "Creates and manages configurations in ~/.zsh_manager/", .zh: "所有的可视化操作会被自动转换为整洁的代码隔离保存。"],
        "Original Preservation": [.en: "Ensures original .zshrc is preserved and readable", .zh: "不想用了？随时点退出，电脑瞬间回到最初原样，零残留。"],
        
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
        "Management Engine": [.en: "Management Engine", .zh: "终端配置核心"],
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
        "Python Manager": [.en: "Python Manager", .zh: "Python 傻瓜安装箱"],
        "Python Environment": [.en: "Python Environment", .zh: "全自动多版本 Python 环境"],
        "Manage multiple Python versions with Pyenv": [.en: "Manage multiple Python versions with Pyenv", .zh: "解决 Python 版本引发的各种崩溃和烂摊子错误"],
        "Pyenv Not Installed": [.en: "Pyenv Not Installed", .zh: "还未安装 Python 管理核心"],
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
        "Default": [.en: "Default (Original)", .zh: "默认 (官方源)"],
        
        // Quick Actions & Setup UX
        "Quick_Add_Alias": [.en: "Create Shortcut", .zh: "添加快捷指令"],
        "Quick_Fix_Command": [.en: "Fix PATH Issues", .zh: "修复找不到命令"],
        "Quick_Install_Env": [.en: "Install Dev Tools", .zh: "安装开发环境"],
        "Health Score": [.en: "Health Score", .zh: "系统健康分"],
        "Fix Issues to Improve Score": [.en: "Fix Issues to Improve Score", .zh: "修复问题以提升全系统健康分"],
        "Refresh_Reminder": [.en: "Changes Saved! Launch a new terminal to see them:", .zh: "配置已无缝保存！启动一个全新终端体验："],
        "Launch_Terminal": [.en: "Launch Fresh Terminal", .zh: "一键呼出新终端"],
        "Copied!": [.en: "Copied!", .zh: "已复制!"],
        
        // New Development Tools
        "Bun": [.en: "Bun", .zh: "Bun 运行时"],
        "Fast all-in-one JS toolkit": [.en: "Fast all-in-one JS toolkit", .zh: "极速全能的 JavaScript 工具箱"],
        "Drop-in replacement for Node.js": [.en: "Drop-in replacement for Node.js", .zh: "可完美替代 Node.js"],
        "Deno": [.en: "Deno", .zh: "Deno 运行时"],
        "Modern JS/TS runtime": [.en: "Modern JS/TS runtime", .zh: "现代安全的 JS/TS 运行时"],
        "Secure by default runtime": [.en: "Secure by default runtime", .zh: "极度注重隐私的沙盒环境"],
        "GitHub CLI": [.en: "GitHub CLI", .zh: "GitHub CLI"],
        "GitHub on the command line": [.en: "GitHub on the command line", .zh: "GitHub 命令行原生工具"],
        "Bring pull requests and issues to your terminal": [.en: "Bring pull requests and issues to your terminal", .zh: "让拉取流程和议题直达你的终端"],
        "Java (OpenJDK)": [.en: "Java (OpenJDK)", .zh: "Java (OpenJDK)"],
        "Java Development Kit": [.en: "Java Development Kit", .zh: "Java 开发工具包"],
        "Standard platform for Java development": [.en: "Standard platform for Java development", .zh: "Java 官方标准开发平台"],
        "Go Language Environment": [.en: "Go Language Environment", .zh: "Go 语言环境"],
        "Build fast, reliable, and efficient software": [.en: "Build fast, reliable, and efficient software", .zh: "构建快速、可靠及高效的软件"],
        
        // Template Wizard Status
        "Detected, Not Configured": [.en: "Detected, Not Configured", .zh: "探测成功, 待配置"],
        "Not Installed": [.en: "Not Installed", .zh: "未安装该环境"],
        "Please install tool first": [.en: "Please install in Essentials", .zh: "请先前往安装环境"],
        "Auto-Configure": [.en: "Auto-Configure", .zh: "一键无缝配置"],
        "Retry": [.en: "Retry", .zh: "重试"],
        
        // Preset Aliases
        "Drag to see more presets": [.en: "← Drag horizontally to see more →", .zh: "← 水平滑动查看更多神仙指令 →"],
        "Flush DNS": [.en: "Flush DNS", .zh: "刷新本地 DNS"],
        "Clear Mac DNS Cache": [.en: "Clear Mac DNS Cache", .zh: "一键清理 Mac 的 DNS 缓存防网页卡死"],
        "Git Status": [.en: "Git Status", .zh: "看 Git 状态"],
        "Quick Git Status": [.en: "Quick Git Status", .zh: "极速敲两下 gs 看当下的 git 状态"],
        "Show Hidden": [.en: "Show Hidden", .zh: "显示隐藏文件"],
        "Show Hidden Files": [.en: "Show Hidden Files", .zh: "强制让访达显示 Mac 所有隐藏文件"],
        "Update Brew": [.en: "Update Brew", .zh: "更新 Homebrew"],
        "Update and Upgrade Homebrew": [.en: "Update and Upgrade Homebrew", .zh: "一键暴走更新并升级所有的 Brew 库"],
        "Clear Trash": [.en: "Clear Trash", .zh: "倒垃圾"],
        "Empty Trash Bin": [.en: "Empty Trash Bin", .zh: "暴力清空回收站内的顽固文件"],
        "My Public IP": [.en: "My Public IP", .zh: "我的外网 IP"],
        "Get public IP address": [.en: "Get public IP address", .zh: "通过 curl 一脚查出本机的外网 IP"],
        
        // Config Analyzer & Insights
        "No functional insights detected yet.": [.en: "No functional insights detected yet.", .zh: "目前系统中未检测到任何需要关注底层的高级配置片段。"],
        "Framework": [.en: "Framework", .zh: "框架/插件"],
        "Development": [.en: "Development", .zh: "开发环境"],
        "Environment": [.en: "Environment", .zh: "环境变量"],
        "Package Manager": [.en: "Package Manager", .zh: "包管理器"],
        "Database": [.en: "Database", .zh: "数据库"],
        "System": [.en: "System", .zh: "系统全局"],
        "Shortcut": [.en: "Shortcut", .zh: "快捷配置"],
        "Loader": [.en: "Loader", .zh: "外部加载"],
        "Testing": [.en: "Testing", .zh: "测试支撑"],
        "AI Tool": [.en: "AI Tool", .zh: "人工智能"],
        "Editor": [.en: "Editor", .zh: "编辑器 CLI"],
        "Alias": [.en: "Alias", .zh: "个人别名"],
        "PATH": [.en: "PATH", .zh: "搜寻路径"],
        
        "Terminal Framework: Oh My Zsh for themes and plugins": [.en: "Terminal Framework: Oh My Zsh for themes and plugins", .zh: "大名鼎鼎的终端框架 Oh My Zsh (主题与拓展插件)"],
        "Node.js Management: Version control for JavaScript runtime": [.en: "Node.js Management: Version control for JavaScript runtime", .zh: "JavaScript 运行时多版本控管器 (NVM 等)"],
        "Mobile SDK: Flutter cross-platform app development": [.en: "Mobile SDK: Flutter cross-platform app development", .zh: "Flutter 全端 APP 跨平台开发工具配置"],
        "Java Environment: JDK support for JVM applications": [.en: "Java Environment: JDK support for JVM applications", .zh: "Java JDK 运行时及应用支撑环境配置"],
        "Java Home: Points to the current active Java SDK": [.en: "Java Home: Points to the current active Java SDK", .zh: "Java Home 全局声明（指向当前核心 JDK 目录）"],
        "pnpm: Efficient, disk-space-saving package manager": [.en: "pnpm: Efficient, disk-space-saving package manager", .zh: "极省空间的极速 JavaScript 包管理器 pnpm"],
        "MongoDB: NoSQL database service": [.en: "MongoDB: NoSQL database service", .zh: "NoSQL 数据库 MongoDB 服务挂载配置"],
        "PostgreSQL: Advanced relational database service": [.en: "PostgreSQL: Advanced relational database service", .zh: "高性能关系型数据库 PostgreSQL 配置"],
        "Terminal Locale: Ensures UTF-8 encoding for text/symbols": [.en: "Terminal Locale: Ensures UTF-8 encoding for text/symbols", .zh: "终端区域设置：强制 UTF-8 编码防中文乱码"],
        "Terminal Locale: Sets system language for terminal output": [.en: "Terminal Locale: Sets system language for terminal output", .zh: "全球化配置：控制终端工具的系统默认语言输出"],
        "Command Alias: Simplifies long terminal instructions": [.en: "Command Alias: Simplifies long terminal instructions", .zh: "快捷别名：简化复杂终端命令行的敲击"],
        "Tool Injection: Loads external configuration or plugins": [.en: "Tool Injection: Loads external configuration or plugins", .zh: "外部脚本加载：深度注入外部的脚本或组件插件"],
        "Browser Automation: Support for automated web testing": [.en: "Browser Automation: Support for automated web testing", .zh: "自动化测试的浏览器内核驱动配置 (Web Driver)"],
        "Antigravity CLI: Integrated AI coding assistant": [.en: "Antigravity CLI: Integrated AI coding assistant", .zh: "你心爱的强无敌代码编写助手：Antigravity"],
        "Windsurf CLI: Command line tools for Windsurf editor": [.en: "Windsurf CLI: Command line tools for Windsurf editor", .zh: "Windsurf 编辑器的全局命令行注入"],
        "Command efficiency: Custom terminal shortcut": [.en: "Command efficiency: Custom terminal shortcut", .zh: "自定义的一键触发终端命令快捷操作"],
        "Tool Path: Adds external commands to terminal": [.en: "Tool Path: Adds external commands to terminal", .zh: "核心路径变量 (让你敲出各种缩写的基座支持)"],
        "System Variable: Configures application environment": [.en: "System Variable: Configures application environment", .zh: "全局系统级环境变量配置"],
        
        // Template Manager Descriptions
        "Standard Node Version Manager setup for Zsh.": [.en: "Standard Node Version Manager setup for Zsh.", .zh: "Node.js 官方标准多版本管理器 (NVM)"],
        "Pyenv initialization for managing Python versions.": [.en: "Pyenv initialization for managing Python versions.", .zh: "Python 版本冲突大杀器：Pyenv"],
        "Shorthand for python3": [.en: "Shorthand for python3", .zh: "给 python3 设置个好敲的缩写"],
        "AI-driven coding CLI by Anthropic.": [.en: "AI-driven coding CLI by Anthropic.", .zh: "Anthropic 官方的高级自动写代码 AI 助手"],
        "Run Claude Code CLI": [.en: "Run Claude Code CLI", .zh: "一键呼出 Claude"],
        "Export Anthropic API Key": [.en: "Export Anthropic API Key", .zh: "填入并导出你的 Anthropic API 秘钥"],
        "Open-source AI coding assistant framework.": [.en: "Open-source AI coding assistant framework.", .zh: "开源界广受好评的代码智能体核心框架"],
        "Export OpenAI API Key": [.en: "Export OpenAI API Key", .zh: "填入并导出你的 OpenAI 秘钥"],
        "Interact with Google Gemini models via terminal.": [.en: "Interact with Google Gemini models via terminal.", .zh: "通过指令丝滑调用 Google Gemini 多模态模型"],
        "Export Gemini API Key": [.en: "Export Gemini API Key", .zh: "填入并导出你的 Gemini 秘钥"],
        "Java Development Kit (JDK)": [.en: "Java Development Kit (JDK)", .zh: "Java 官方标准开发工具包 (JDK)"],
        "Go Language (Golang) environment.": [.en: "Go Language (Golang) environment.", .zh: "Google 出神入化的的云端第一语言：Go"],
        "Show Go path": [.en: "Show Go path", .zh: "查看当下的 Go 工程路径"],
        "Cross-platform development SDK.": [.en: "Cross-platform development SDK.", .zh: "一套代码跨苹果安卓：Flutter 开发套件"],
        "Ruby dynamic programming language.": [.en: "Ruby dynamic programming language.", .zh: "好用到逆天的动态脚本语言 Ruby"],
        
        // Final Sweep: Missing Strings
        "Active Aliases": [.en: "Active Aliases", .zh: "启用的快捷指令"],
        "Add Common Path: /usr/local/bin": [.en: "Add Common Path: /usr/local/bin", .zh: "添加常见路径: /usr/local/bin"],
        "Archive": [.en: "Archive", .zh: "归档"],
        "Configuration restore points": [.en: "Configuration restore points", .zh: "配置版本恢复点"],
        "Detected Services": [.en: "Detected Services", .zh: "检测到的关键服务"],
        "Development tool detection": [.en: "Development tool detection", .zh: "全环境扫描检测与一键配置"],
        "Diagnostic system health report": [.en: "Diagnostic system health report", .zh: "系统病历报告与冲突漏洞检查"],
        "Key Missing": [.en: "Key Missing", .zh: "未填 API Key"],
        "Manage shell search paths": [.en: "Manage shell search paths", .zh: "管理系统命令查找路径的优先级"],
        "Manage terminal shortcuts": [.en: "Manage terminal shortcuts", .zh: "为您最爱用的长串指令起个极短的名字吧"],
        "Missing 'command not found'?": [.en: "Missing 'command not found'?", .zh: "终端报错 'command not found'？"],
        "New Snapshot": [.en: "New Snapshot", .zh: "创建新快照"],
        "PATH tells your Mac where to look for commands like 'npm' or 'python'.\nIf a tool isn't working, add its folder path here.": [
            .en: "PATH tells your Mac where to look for commands like 'npm' or 'python'.\nIf a tool isn't working, add its folder path here.",
            .zh: "PATH 的作用就是告诉系统去哪里寻找类似于 'npm' 或 'python' 这样的执行命令。\n如果有工具无法运行，说明它的目录不在系统搜索范围里，请点加号把路径强制塞进来。"
        ],
        "Quick Add": [.en: "Quick Add", .zh: "快捷添加"],
        "Quickly help users configure a specific environment": [.en: "Quickly help users configure a specific environment", .zh: "自动扫描本地工具，点此一键无缝绑定环境路径"],
        "Registered Paths": [.en: "Registered Paths", .zh: "已登记的系统路径"],
        "Save Snapshot": [.en: "Save Snapshot", .zh: "完成备份保存"],
        "Save time by typing a short word instead of a long, complicated command.": [.en: "Save time by typing a short word instead of a long, complicated command.", .zh: "别再手敲老长一串字母了，设置一个好记的短字母，系统会自动帮您换成完整长命令。极客偷懒必备。"],
        "Scanning System...": [.en: "Scanning System...", .zh: "扫描大盘状态..."],
        "Select...": [.en: "Select...", .zh: "请选择..."],
        "What is a Shortcut?": [.en: "What is a Shortcut?", .zh: "什么是快捷指令 (Alias)？"],
        "ADD PATH": [.en: "ADD PATH", .zh: "强行写入"]
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
