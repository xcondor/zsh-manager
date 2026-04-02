# Zshrc Manager - Project Identity & Scope

## 1. Project Overview
Zshrc Manager is a native macOS application designed to transform complex Shell configurations into a manageable, visual environment. Unlike tools that focus on terminal interaction (like Warp or Fig), this product focuses on **Environmental Asset Management**, providing users with a safe, intuitive way to manage their terminal setup.

## 2. Technical Philosophy: Shadow Management
To ensure reliability and compatibility with complex user-defined scripts (if-else, source nesting, etc.), the project avoids "Full Parsing." Instead, it uses a **Shadow Management** strategy:
- **Injection Pattern**: Append `source ~/.zsh_manager/main.zsh` to the user's `.zshrc`.
- **Modular Storage**: UI-driven changes are stored as independent files within `~/.zsh_manager/`, which are then sourced by the main manager script. 
- **Non-Destructive**: The user's original `.zshrc` remains intact and legible.

## 3. Product Roadmap

### Phase 1: MVP - "The Alias & Path Master" (Sprint 1 - 4 Weeks)
- **Visual Alias List**: Complete CRUD (Create, Read, Update, Delete) for aliases.
- **PATH Visualization**: Drag-and-drop sorting for PATH priorities with validity detection.
- **One-click Snapshot**: Backup and restore system for configuration states.

### Phase 2: V1.5 - "Config Doctor"
- **Diagnostic System**: Detect and highlight invalid paths (red highlight) and duplicate definitions.
- **Environment Detection**: Automatically identify Homebrew, Python, Node, Go, etc., and offer "One-click activation" templates.
- **Block Isolation**: Allow locking specific configuration blocks to prevent accidental UI-driven changes.

### Phase 3: V2.0 - "The Shell Hub"
- **Cloud Sync**: Securely sync configuration fragments across devices.
- **AI-Powered Functions**: Generate complex Shell functions using natural language.
- **Plugin Market**: One-click install and management for visual shell plugins (similar to Oh My Zsh).

## 4. Technical Stack
- **Framework**: SwiftUI (for high-performance, native macOS UX).
- **Core Logic**: Swift Shell library integration.
- **Data Persistence**: JSON-based state mapping, strictly compiled to Shell scripts for terminal execution.

## 5. UI/UX Design Principles
- **Architecture**: Classic macOS triple-pane or sidebar layout.
  - **Navigation (Left)**: Overview, Environment Variables, Aliases, PATH, Backup Center.
  - **Main List (Center)**: Clean list view with Toggle switches and search functionality.
  - **Detail/Warning (Right)**: Contextual information, conflict alerts, and historical logs.
- **Aesthetics**: Modern, premium design following macOS Human Interface Guidelines (HIG).

## 6. Critical Directives
- **Security**: All processing must remain local. Sensitivity check for API keys.
- **Exit Strategy**: Always provide an "Export and Uninstall" feature to restore the system to its pre-application state.
- **AI Environment Support**: Built-in visual controllers for Conda, Poetry, and Pyenv are high-priority features for the AI developer audience.
