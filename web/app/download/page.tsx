'use client';

import React, { useEffect } from 'react';
import { useLanguage } from '../i18n';

export default function DownloadPage() {
  const { lang, t, mounted } = useLanguage();
  const downloadUrl = "https://download.maczsh.com/ZshrcManager-v1.0.0-b2.dmg";

  useEffect(() => {
    // Elegant auto-trigger download
    const timer = setTimeout(() => {
      const link = document.createElement('a');
      link.href = downloadUrl;
      link.setAttribute('download', 'ZshrcManager.dmg');
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }, 2000);
    return () => clearTimeout(timer);
  }, []);

  if (!mounted) return null;

  const td = t.download_page;

  return (
    <div className="bg-[#020202] min-h-screen text-white relative overflow-hidden flex flex-col items-center justify-center p-6 antialiased">
      {/* Dynamic Background */}
      <div className="absolute inset-0 bg-grid opacity-[0.03] pointer-events-none" />
      <div className="absolute top-[-10%] left-[-10%] w-[50%] h-[50%] bg-accent-cyan/10 rounded-full blur-[120px] pointer-events-none animate-pulse" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-purple-500/5 rounded-full blur-[120px] pointer-events-none" />
      
      <main className="max-w-3xl w-full text-center relative z-10">
        {/* Success Icon with Glow */}
        <div className="mb-12 relative inline-block">
          <div className="absolute inset-0 bg-accent-cyan/40 blur-[40px] rounded-full scale-110" />
          <div className="relative h-24 w-24 rounded-[2rem] bg-accent-cyan flex items-center justify-center shadow-2xl">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#000" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
          <div className="absolute -bottom-2 -right-2 h-10 w-10 rounded-xl bg-[#080808] border border-white/10 flex items-center justify-center shadow-lg animate-bounce">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D8C0" strokeWidth="3">
              <path d="M12 17V3M6 11l6 6 6-6" />
            </svg>
          </div>
        </div>

        {/* Text Hero */}
        <div className="space-y-6 mb-20">
          <h1 className="text-4xl lg:text-6xl font-semibold tracking-tighter leading-tight">
            {td?.title || "Thanks for downloading!"}
          </h1>
          <p className="text-xl text-zinc-500 max-w-2xl mx-auto font-normal opacity-80">
            {td?.subtitle || "Your download should start automatically."}
          </p>
        </div>

        {/* Delicate Steps Card */}
        <div className="backdrop-blur-3xl bg-white/[0.03] border border-white/10 rounded-[3rem] p-12 lg:p-16 space-y-12 shadow-2xl relative group overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-br from-white/[0.02] to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-1000" />
          
          <h3 className="text-xs font-semibold uppercase tracking-[0.4em] text-accent-cyan relative z-10">
            {td?.next_steps || "NEXT STEPS"}
          </h3>
          
          <div className="grid gap-10 text-left relative z-10">
            <div className="flex gap-8 items-center group/step">
              <div className="h-10 w-10 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center shrink-0 font-bold text-sm group-hover/step:bg-accent-cyan group-hover/step:text-black transition-all">1</div>
              <p className="text-lg text-zinc-400 leading-relaxed font-normal group-hover/step:text-white transition-colors">
                {td?.step1 || "Open the downloaded ZshrcManager.dmg file"}
              </p>
            </div>
            <div className="flex gap-8 items-center group/step">
              <div className="h-10 w-10 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center shrink-0 font-bold text-sm group-hover/step:bg-accent-cyan group-hover/step:text-black transition-all">2</div>
              <p className="text-lg text-zinc-400 leading-relaxed font-normal group-hover/step:text-white transition-colors">
                {td?.step2 || "Drag Zshrc Manager to your Applications folder"}
              </p>
            </div>
            <div className="flex gap-8 items-center group/step">
              <div className="h-10 w-10 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center shrink-0 font-bold text-sm group-hover/step:bg-accent-cyan group-hover/step:text-black transition-all">3</div>
              <p className="text-lg text-zinc-400 leading-relaxed font-normal group-hover/step:text-white transition-colors">
                {td?.step3 || "Open from Launchpad and start your journey!"}
              </p>
            </div>
          </div>
        </div>

        {/* Footer Actions */}
        <div className="mt-20 space-y-8">
          <div className="space-y-4">
            <p className="text-[10px] text-zinc-600 font-semibold uppercase tracking-[0.3em]">
              {td?.not_started || "DOWNLOAD DIDN'T START?"}
            </p>
            <a 
              href={downloadUrl}
              className="inline-flex items-center gap-3 text-accent-cyan hover:text-white transition-all font-semibold text-sm uppercase tracking-widest bg-accent-cyan/5 px-6 py-3 rounded-full border border-accent-cyan/20 hover:bg-accent-cyan/10"
            >
              {td?.manual_link || "CLICK HERE TO DOWNLOAD MANUALLY"}
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </a>
          </div>

          <div className="pt-8">
            <a href="/" className="text-xs text-zinc-700 hover:text-zinc-400 transition-colors uppercase tracking-[0.3em] font-semibold border-b border-transparent hover:border-zinc-800 pb-1">
              {td?.back_home || "BACK TO HOME"}
            </a>
          </div>
        </div>
      </main>
    </div>
  );
}
