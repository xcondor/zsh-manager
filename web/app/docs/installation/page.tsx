export default function InstallationDocs() {
  return (
    <div className="space-y-10">
      <div>
        <h1 className="text-5xl font-black mb-4">
          Installation <span className="text-secondary/50 font-medium">/ 安装</span>
        </h1>
        <p className="text-xl text-secondary">
          Zshrc Manager is distributed as a standard macOS DMG package.<br />
          <span className="text-sm opacity-60">Zshrc Manager 以标准的 macOS DMG 格式发布。</span>
        </p>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">System Requirements / 系统要求</h2>
        <ul className="list-disc list-inside text-secondary space-y-2 ml-4">
          <li>macOS 12.0 (Monterey) or later <span className="text-sm opacity-60 ml-2">/ macOS 12.0 或更高版本</span></li>
          <li>Apple Silicon (M1/M2/M3) or Intel processor <span className="text-sm opacity-60 ml-2">/ Apple 芯片或 Intel 处理器</span></li>
          <li>Zsh (Default on modern macOS) <span className="text-sm opacity-60 ml-2">/ Zsh (现代 macOS 默认)</span></li>
        </ul>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">Step 1: Download / 第一步：下载</h2>
        <p className="text-secondary">
          Download the latest version of Zshrc Manager from the official website.<br />
          <span className="text-sm opacity-60">从官方网站下载最新版本的 Zshrc Manager。</span>
        </p>
        <div className="bg-white/5 rounded-xl p-4 font-mono text-sm border border-white/5">
          ZshrcManager-v1.2.0.dmg
        </div>
      </div>

      <div className="space-y-8">
        <div className="flex items-center gap-4">
           <div className="flex h-10 w-10 items-center justify-center rounded-full bg-blue-500 text-white font-black">2</div>
           <h2 className="text-2xl font-bold">Drag to Applications / 拖拽到应用程序</h2>
        </div>
        <p className="text-secondary">
          Open the downloaded DMG and drag the <strong>Zshrc Manager</strong> icon into your <strong>Applications</strong> folder.<br />
          <span className="text-sm opacity-60">打开下载的 DMG 文件，将 <strong>Zshrc Manager</strong> 图标拖入 <strong>Applications</strong> 文件夹。</span>
        </p>
        <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl max-w-2xl mx-auto">
          <img 
            src="/screenshots/installation.png" 
            alt="DMG Installation Window" 
            className="w-full h-auto block"
          />
        </div>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">Step 3: Initial Setup / 第三步：初始设置</h2>
        <p className="text-secondary">
          Upon first launch, Zshrc Manager will perform a quick scan of your <code>~/.zshrc</code> file. <br />
          It will safely index your existing aliases and environment variables.<br />
          <span className="text-sm opacity-60">首次启动时，Zshrc Manager 将快速扫描您的 <code>~/.zshrc</code> 文件，并安全地索引现有的别名和环境变量。</span>
        </p>
        <div className="p-4 bg-yellow-500/10 border border-yellow-500/20 rounded-xl text-sm text-yellow-400">
           <strong>Note:</strong> You may need to grant Full Disk Access to allow the application to modify configuration files in your home directory.<br />
           <span className="opacity-80"><strong>注意：</strong> 您可能需要授予“完全磁盘访问权限”，以允许应用程序修改主目录中的配置文件。</span>
        </div>
      </div>
    </div>
  );
}
