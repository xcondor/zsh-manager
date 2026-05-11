'use client';

import { AppWindow, StepIcon } from "@/components/DocsComponents";
import { useLanguage } from '../../i18n';

export default function TerminalMasterDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};

  return (
    <div className="space-y-20">
      <section className="space-y-6">
        <h1 className="text-5xl font-black mb-4">{s.tm_title || "Terminal Master"}</h1>
        <p className="text-xl text-secondary max-w-3xl">
          {s.tm_desc || "Instantly transform your terminal into a professional workstation. No manual configuration required."}
        </p>
      </section>

      {/* Real App Screenshot Section */}
      <section className="space-y-8">
        <div className="flex items-center gap-4">
          <StepIcon colorClass="bg-gradient-to-r from-blue-500 to-purple-500">
            <span className="text-sm">★</span>
          </StepIcon>
          <h2 className="text-3xl font-bold">{s.tm_overview || "Visual Dashboard Overview"}</h2>
        </div>
        <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl">
          <img 
            src="/screenshots/terminal-master.png" 
            alt="Terminal Master Interface" 
            className="w-full h-auto block"
          />
        </div>
      </section>

      {/* Feature 1: One-Click Oh My Zsh */}
      <section className="grid gap-12 lg:grid-cols-2 items-center">
        <div className="space-y-6">
          <StepIcon>1</StepIcon>
          <h2 className="text-3xl font-bold">{s.tm_deploy || "Deploy Oh My Zsh"}</h2>
          <p className="text-secondary leading-relaxed">
            {s.tm_deploy_desc || "Oh My Zsh is the foundation of a modern terminal. With Zshrc Manager, you don't need to copy-paste install scripts. Simply click Install next to Oh My Zsh in the Core Components section."}
          </p>
          <ul className="space-y-3">
             {[
               s.tm_feat1 || "Automated Git Clone",
               s.tm_feat2 || "Safe Config Backup",
               s.tm_feat3 || "Instant Activation"
             ].map(item => (
               <li key={item} className="flex items-center gap-2 text-sm font-medium">
                 <span className="text-blue-400">●</span> {item}
               </li>
             ))}
          </ul>
        </div>
        <div className="space-y-4">
          <div className="glass rounded-2xl p-6 border-blue-500/20 bg-blue-500/5">
             <h4 className="text-sm font-bold mb-4 uppercase tracking-widest text-blue-400">
               {s.tm_status || "Core Component Status"}
             </h4>
             <div className="space-y-4">
                <div className="flex items-center justify-between p-3 bg-white/5 rounded-xl">
                   <span className="font-medium">Oh My Zsh</span>
                   <span className="text-[10px] bg-green-500/20 text-green-400 px-2 py-0.5 rounded-full font-bold">
                     {s.tm_ready || "READY"}
                   </span>
                </div>
                <div className="flex items-center justify-between p-3 bg-white/5 rounded-xl">
                   <span className="font-medium">P10k Theme</span>
                   <span className="text-[10px] bg-green-500/20 text-green-400 px-2 py-0.5 rounded-full font-bold">
                     {s.tm_ready || "READY"}
                   </span>
                </div>
             </div>
          </div>
        </div>
      </section>
    </div>
  );
}
