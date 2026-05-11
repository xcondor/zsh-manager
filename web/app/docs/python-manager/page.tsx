'use client';

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
}