'use client';

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
}