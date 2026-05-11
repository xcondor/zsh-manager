'use client';

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
}