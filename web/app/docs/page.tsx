'use client';

import { useLanguage } from '../i18n';

export default function DocsHome() {
  const { t, mounted } = useLanguage();

  return (
    <div className="space-y-10">
      <div>
        <h1 className="text-5xl font-black mb-4">{t.docs?.intro_title || "Introduction"}</h1>
        <p className="text-xl text-secondary leading-relaxed">
          {t.docs?.intro_desc || "Zshrc Manager is the ultimate macOS desktop application designed to simplify your shell environment management."}
        </p>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <div className="bg-white/5 rounded-2xl p-6 border border-white/5">
          <h3 className="text-lg font-bold mb-2">{t.docs?.gui_title || "GUI First"}</h3>
          <p className="text-sm text-secondary">{t.docs?.gui_desc}</p>
        </div>
        <div className="bg-white/5 rounded-2xl p-6 border border-white/5">
          <h3 className="text-lg font-bold mb-2">{t.docs?.safe_title || "Safe & Reliable"}</h3>
          <p className="text-sm text-secondary">{t.docs?.safe_desc}</p>
        </div>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">{t.docs?.preview_title || "Visual Preview"}</h2>
        <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl">
          <img 
            src="/screenshots/terminal-master.png" 
            alt="Zshrc Manager Dashboard" 
            className="w-full h-auto block"
          />
        </div>
      </div>
    </div>
  );
}
