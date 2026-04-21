# Zshrc Manager · Code Wiki

本 Wiki 面向二次开发者，目标是用“可维护的工程视角”解释该仓库的整体架构、主要模块职责、关键类/函数、依赖关系与运行方式，并对现状做实用性与商业化评估，给出改造方案。

## 目录

- [1. 项目概览](./architecture.md#1-项目概览)
- [2. 架构与关键流程](./architecture.md#2-架构与关键流程)
- [3. 模块与关键 API](./modules.md#1-模块总览)
- [4. 依赖关系](./dependencies.md#1-外部依赖)
- [5. 运行、构建与打包](./run-build-package.md#1-运行方式)
- [6. 实用性与商业化评估](./commercialization.md#1-产品定位与差异化)

## 快速结论

- 这是一个 macOS 原生 SwiftUI 应用（Swift Package 可执行产物），围绕“Shadow Management（影子接管）”方案管理 Shell 配置。
- 核心策略是：仅在用户主配置文件（通常是 `~/.zshrc`）末尾注入一行 `source ~/.zsh_manager/main.zsh`，所有 UI 变更写入 `~/.zsh_manager/*.zsh` 与 `~/.zsh_manager/*.json`，保持用户原配置尽量不被破坏。
- 业务能力围绕开发者常见痛点：Alias/PATH/插件/环境探测/一键安装/诊断/快照回滚/终端实验室。

