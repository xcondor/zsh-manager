'use client';

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
}