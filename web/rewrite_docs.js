const fs = require('fs');

const configDoctorCode = `'use client';

import { AppWindow, StepIcon } from "@/components/DocsComponents";
import { useLanguage } from '../../i18n';

export default function ConfigDoctorDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};
  const isZh = s.cd_title === '配置诊断' || s.cd_title === '配置診斷';

  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">{s.cd_title || "Config Doctor"}</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          {s.cd_desc || "Automatically detect and fix syntax errors, path conflicts, and duplicate aliases in your zshrc."}
        </p>
      </section>

      <div className="grid gap-16 lg:grid-cols-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "语法高亮验证" : "Syntax Validation"}</h3>
                <p className="text-secondary">
                  {isZh ? "在保存之前实时检测丢失的引号、未闭合的括号以及无效变量。" : "Real-time detection of missing quotes, unclosed brackets, and invalid variables before saving."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "路径去重" : "Path Deduplication"}</h3>
                <p className="text-secondary">
                  {isZh ? "随着时间推移，$PATH 可能会变得杂乱。一键优化冗余路径并修复环境冲突。" : "$PATH can get cluttered over time. Instantly optimize redundant paths and resolve conflicts."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "弃用警告" : "Deprecation Warnings"}</h3>
                <p className="text-secondary">
                  {isZh ? "收到关于由于系统更新或架构更改而不再起作用的过时 zsh 插件的警告。" : "Get warned about outdated zsh plugins that no longer function."}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg:order-2">
          <AppWindow title={isZh ? "诊断面板" : "Diagnosis Panel"}>
            <div className="p-6 space-y-6">
               <div className="flex items-center gap-3 p-4 bg-red-500/10 border border-red-500/20 rounded-xl">
                  <div className="w-8 h-8 rounded-full bg-red-500/20 text-red-500 flex items-center justify-center font-bold">!</div>
                  <div>
                    <h4 className="text-red-400 font-bold text-sm">{isZh ? "发现 2 个语法错误" : "2 Syntax Errors Found"}</h4>
                    <p className="text-xs text-secondary">{isZh ? "在第 45 和 82 行" : "On lines 45 and 82"}</p>
                  </div>
               </div>
               
               <div className="flex items-center gap-3 p-4 bg-yellow-500/10 border border-yellow-500/20 rounded-xl">
                  <div className="w-8 h-8 rounded-full bg-yellow-500/20 text-yellow-500 flex items-center justify-center font-bold">!</div>
                  <div>
                    <h4 className="text-yellow-400 font-bold text-sm">{isZh ? "重复的 $PATH 变量" : "Duplicate $PATH Variable"}</h4>
                    <p className="text-xs text-secondary">{isZh ? "/usr/local/bin 出现两次" : "/usr/local/bin exported twice"}</p>
                  </div>
               </div>

               <button className="w-full py-3 bg-white/10 hover:bg-white/20 transition-colors rounded-xl font-bold text-sm">
                 {isZh ? "自动修复全部" : "Auto-Fix All Issues"}
               </button>
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}`;

const cloudSyncCode = `'use client';

import { AppWindow, StepIcon } from "@/components/DocsComponents";
import { useLanguage } from '../../i18n';

export default function CloudSyncDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};
  const isZh = s.sync_title === 'iCloud 同步 (Pro)' || s.sync_title === 'iCloud 同步 (Pro)';

  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">{s.sync_title || "iCloud Sync (Pro)"}</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          {s.sync_desc || "Keep your terminal environment perfectly synchronized across all your Macs."}
        </p>
      </section>

      <div className="grid gap-16 lg:grid-cols-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "原生无缝同步" : "Native Seamless Sync"}</h3>
                <p className="text-secondary">
                  {isZh ? "无需配置 Git 仓库。我们使用原生的 Apple iCloudKit 确保无论您在哪里打开终端，它都能提供一致的体验。" : "No need to configure Git repositories. We use native Apple iCloudKit."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "端到端加密" : "End-to-End Encryption"}</h3>
                <p className="text-secondary">
                  {isZh ? "包含凭据的环境变量在存储到 iCloud 之前会被军事级加密本地保障安全。" : "Environment variables containing credentials are encrypted locally."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "冲突解决" : "Conflict Resolution"}</h3>
                <p className="text-secondary">
                  {isZh ? "如果您在离线状态下编辑配置，上线时会提供智能差异比较以避免覆盖更改。" : "Smart diff comparison is provided to avoid overwriting changes."}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg:order-2">
          <AppWindow title={isZh ? "云端同步" : "Cloud Sync"}>
            <div className="p-8 flex flex-col items-center justify-center text-center space-y-6 min-h-[300px]">
              <div className="relative">
                <div className="w-20 h-20 bg-blue-500/20 rounded-full flex items-center justify-center animate-pulse">
                  <div className="w-16 h-16 bg-blue-500/40 rounded-full flex items-center justify-center">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#60A5FA" strokeWidth="2">
                      <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                    </svg>
                  </div>
                </div>
                <div className="absolute top-0 right-0 w-6 h-6 bg-green-500 rounded-full border-4 border-black"></div>
              </div>
              <div>
                <h4 className="text-lg font-bold text-white">{isZh ? "已同步并受保护" : "Synced & Protected"}</h4>
                <p className="text-sm text-secondary mt-1">{isZh ? "最后同步：刚刚" : "Last sync: Just now"}</p>
              </div>
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}`;

const snapshotsCode = `'use client';

import { AppWindow, StepIcon } from "@/components/DocsComponents";
import { useLanguage } from '../../i18n';

export default function SnapshotsDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};
  const isZh = s.snap_title === '环境快照' || s.snap_title === '環境快照';

  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">{s.snap_title || "Snapshots"}</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          {s.snap_desc || "Create and restore backups of your entire zsh environment with a single click."}
        </p>
      </section>

      <div className="grid gap-16 lg:grid-cols-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "自动创建快照" : "Automated Snapshots"}</h3>
                <p className="text-secondary">
                  {isZh ? "在安装新插件或更改主题之前，我们会在后台自动创建一个静默快照作为安全网。" : "Before installing plugins, we silently create an automated snapshot."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "一键回滚" : "One-Click Rollback"}</h3>
                <p className="text-secondary">
                  {isZh ? "搞砸了环境变量？只需选择昨日的快照点击恢复即可。" : "Messed up environment variables? Select yesterday's snapshot to restore."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "差异比较" : "Diff Viewer"}</h3>
                <p className="text-secondary">
                  {isZh ? "在恢复快照前，您可以并排查看代码的改动之处。" : "Compare line-by-line differences before restoring a snapshot."}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg:order-2">
          <AppWindow title={isZh ? "时间机器" : "Time Machine"}>
            <div className="p-6 space-y-4">
               {[1, 2, 3].map((i) => (
                 <div key={i} className="p-4 bg-white/5 border border-white/10 rounded-xl flex items-center justify-between group hover:border-blue-500/50 transition-colors">
                    <div>
                      <h4 className="font-bold text-sm">{isZh ? "自动备份 " : "Auto Backup "} #{1000 - i}</h4>
                      <p className="text-xs text-secondary mt-1">{i} {isZh ? "天前" : "days ago"}</p>
                    </div>
                    <button className="px-4 py-1.5 bg-white/10 rounded-lg text-xs font-bold hover:bg-blue-500 hover:text-white transition-colors opacity-0 group-hover:opacity-100">
                      {isZh ? "恢复" : "Restore"}
                    </button>
                 </div>
               ))}
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}`;

const pythonCode = `'use client';

import { AppWindow, StepIcon } from "@/components/DocsComponents";
import { useLanguage } from '../../i18n';

export default function PythonDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};
  const isZh = s.python_title === 'Python 管理' || s.python_title === 'Python 管理';

  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">{s.python_title || "Python & Conda Environment"}</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          {s.python_desc || "Managing Python environments on macOS can be a nightmare. Zshrc Manager simplifies this."}
        </p>
      </section>

      <div className="grid gap-16 lg:grid-cols-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "自动初始化" : "Automated Init"}</h3>
                <p className="text-secondary">
                  {isZh ? "自动检测 Conda/Mamba 安装并将所需的初始化代码注入您的 Shell。" : "Automatically detect installed Conda or Mamba installations."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "别名快捷切换" : "Alias Shortcuts"}</h3>
                <p className="text-secondary">
                  {isZh ? "在界面中定义单击快捷命令，快速切换 Python 3.9 和 3.12。" : "Toggle between Python 3.9 and 3.12 with single-character commands."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "智能路径解析" : "Path Intelligence"}</h3>
                <p className="text-secondary">
                  {isZh ? "分析您的 $PATH，确保 Python 优先加载，避免“命令未找到”陷阱。" : "Ensure Python binaries are prioritized correctly."}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg:order-2">
          <AppWindow title={isZh ? "环境管家" : "Environment Manager"}>
            <div className="p-8 space-y-8">
               <div className="space-y-4">
                  <div className="flex items-center justify-between">
                     <span className="text-sm font-bold">{isZh ? "默认解释器" : "Base Interpreter"}</span>
                     <span className="text-xs text-blue-400 font-mono">/usr/local/bin/python3</span>
                  </div>
                  <div className="h-2 w-full bg-white/5 rounded-full">
                     <div className="h-full w-full bg-green-500/50 rounded-full"></div>
                  </div>
               </div>

               <div className="grid grid-cols-2 gap-4">
                  <div className="p-4 glass rounded-2xl border-white/5 text-center space-y-2">
                     <p className="text-xs text-secondary uppercase font-bold tracking-widest">Conda</p>
                     <p className="text-lg font-black text-green-400">{isZh ? "已链接" : "Linked"}</p>
                  </div>
                  <div className="p-4 glass rounded-2xl border-white/5 text-center space-y-2">
                     <p className="text-xs text-secondary uppercase font-bold tracking-widest">Homebrew</p>
                     <p className="text-lg font-black">{isZh ? "活跃" : "Active"}</p>
                  </div>
               </div>
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}`;

const manualCode = `'use client';

import { AppWindow, StepIcon } from "@/components/DocsComponents";
import { useLanguage } from '../../i18n';

export default function ManualDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};
  const isZh = s.manual_title === '手动配置' || s.manual_title === '手動配置';

  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">{s.manual_title || "Expert Mode: Manual Edits"}</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          {s.manual_desc || "For advanced users: How to safely edit raw configuration blocks within Zshrc Manager."}
        </p>
      </section>

      <div className="grid gap-16 lg:grid-cols-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "集成编辑器" : "Integrated Editor"}</h3>
                <p className="text-secondary">
                  {isZh ? "访问专家选项卡查看原始配置文件。采用顶级 macOS 代码编辑器相同的文本引擎。" : "We use the same text engine underlying top-tier macOS code editors."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "安全沙盒" : "Safe Sandbox"}</h3>
                <p className="text-secondary">
                  {isZh ? "手动更改会被“配置诊断”验证，防止 Shell 意外锁定。" : "Changes are validated by the Config Doctor before being applied."}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">{isZh ? "模块化引用" : "Modular Source"}</h3>
                <p className="text-secondary">
                  {isZh ? "轻松管理外部 export 脚本，拖拽文件即可生成 source 命令。" : "Drag and drop files to generate the correct source commands instantly."}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg:order-2">
          <AppWindow title={isZh ? ".zshrc — 专业编辑器" : ".zshrc — Pro Editor"}>
            <div className="p-0 font-mono text-sm leading-relaxed overflow-hidden">
               <div className="flex bg-white/5 border-b border-white/5 px-4 py-2 text-[10px] uppercase font-bold tracking-widest text-secondary gap-6">
                  <span className="text-blue-400">Main .zshrc</span>
                  <span className="opacity-40">.zsh_aliases</span>
               </div>
               <div className="p-6 space-y-2">
                  <div className="flex gap-4"><span className="opacity-30 w-4">1</span><p><span className="text-purple-400">export</span> ZSH=<span className="text-green-400">"$HOME/.oh-my-zsh"</span></p></div>
                  <div className="flex gap-4"><span className="opacity-30 w-4">2</span><p><span className="text-purple-400">source</span> ~/scripts/custom_init.sh</p></div>
                  <div className="flex gap-4 bg-white/5 border-l-2 border-blue-500 pl-4 py-1"><span className="opacity-30 w-4">3</span><p>alias <span className="text-yellow-400">gs</span>=<span className="text-green-400">'git status'</span>|</p></div>
               </div>
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}`;

fs.writeFileSync('app/docs/config-doctor/page.tsx', configDoctorCode);
fs.writeFileSync('app/docs/cloud-sync/page.tsx', cloudSyncCode);
fs.writeFileSync('app/docs/snapshots/page.tsx', snapshotsCode);
fs.writeFileSync('app/docs/python-manager/page.tsx', pythonCode);
fs.writeFileSync('app/docs/manual/page.tsx', manualCode);

console.log('Docs updated successfully!');
