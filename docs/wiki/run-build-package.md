# 运行、构建与打包

## 1. 运行方式

### 1.1 本地开发运行（推荐）

仓库自带 Makefile（见 [Makefile](../../Makefile)）：

```bash
make run
```

该命令会执行：

- `swift test`
- `swift build`
- 启动 `.build/debug/ZshrcManager`

### 1.2 仅运行测试

```bash
make test
```

测试用例位于 [CoreTests.swift](../../Tests/ZshrcManagerTests/CoreTests.swift)，当前覆盖：

- Alias CRUD
- Path 添加与变量形式路径
- Template 预置存在性

### 1.3 仅构建

```bash
make build
```

### 1.4 Release 构建

```bash
make release
```

或：

```bash
swift build -c release
```

## 2. 打包与分发

### 2.1 打包 .app（包含脚本资源）

```bash
make package
```

内部调用 [scripts/package.sh](../../scripts/package.sh) 完成：

- SPM universal build（arm64 + x86_64）
- 组装 `.app` 结构（`Contents/MacOS`、`Contents/Resources`）
- 拷贝 `Resources/Info.plist`、`Resources/AppIcon.icns`
- 将 `scripts/*.sh` 复制进 app bundle 的 `Contents/Resources/scripts/` 并赋予可执行权限

### 2.2 生成 DMG

```bash
make dmg
```

脚本会生成带背景图与 Finder 布局的 DMG（需要 macOS 的 `osascript` 与 `hdiutil`）。

### 2.3 Debug DMG

```bash
make debug-dmg
```

## 3. 运行时行为与注意事项

### 3.1 会修改哪些文件

应用运行后可能写入/修改：

- `~/.zshrc`（或 `.bash_profile` / `.bashrc`，取决于探测结果）：
  - 注入/卸载 `source ~/.zsh_manager/main.zsh`
  - Config Doctor 自动修复可能会注释某些行并生成 `.doctor.bak` 备份
  - Terminal Master 会修改 `ZSH_THEME` 并插入 P10k instant prompt 片段
- `~/.zsh_manager/*`：
  - 管理器模块脚本与元数据
  - 快照目录

建议：在商业分发或面向团队使用时，引入“预演（dry-run）/差异预览/可回滚事务”机制。

### 3.2 脚本资源路径

运行脚本（如 `check_env.sh` / `check_config.sh`）时，代码会优先从 App Bundle 中加载脚本；开发态下使用项目路径 fallback。该策略对“发布版”是正确的，但需要避免任何硬编码到开发者本地绝对路径的情况（属于技术债）。

