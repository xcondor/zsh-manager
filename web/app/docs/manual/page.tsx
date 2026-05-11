'use client';

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
}