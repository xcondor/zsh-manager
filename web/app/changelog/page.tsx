'use client';

import React, { useState } from 'react';
import { useLanguage } from '../i18n';
import { Language, translations } from '../translations';

export default function Changelog() {
  const { lang, changeLang, t, mounted } = useLanguage();
  const [showLangMenu, setShowLangMenu] = useState(false);
  
  if (!mounted) return null;

  const tc = t.changelog_page || {};

  return (
    <div className="bg-black min-h-screen text-white font-sans antialiased selection:bg-accent-cyan/30">
      <style jsx global>{`
        body { background: #000; }
        .text-clean { line-height: 1.2; }
        .border-thin { border: 1px solid rgba(255, 255, 255, 0.08); }
      `}</style>

      {/* Full-width Sticky Navigation - Unified with Home Page */}
      <header id="site-header" className="fixed top-0 left-0 right-0 z-[9999] border-b border-white/5 bg-black/40 backdrop-blur-xl">
        <div className="container h-20 flex items-center justify-between">
          <a href="/" className="flex items-center gap-3">
             <div className="w-10 h-10 rounded-xl bg-accent-cyan flex items-center justify-center shadow-[0_0_20px_rgba(0,216,192,0.4)]">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#000" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="4 17 10 11 4 5" />
                  <line x1="12" y1="19" x2="20" y2="19" />
                </svg>
             </div>
             <span className="text-xl font-bold tracking-tight text-white">Zshrc Manager</span>
          </a>
          
          <div className="hidden lg:flex items-center gap-8 text-xs font-semibold text-secondary uppercase tracking-[0.1em]">
            <a href="/#features" className="hover:text-white transition-colors">{t.nav.features}</a>
            <a href="/pricing" className="hover:text-white transition-colors">{t.nav.pricing}</a>
            <a href="/docs" className="hover:text-white transition-colors">{t.footer?.docs || "Documentation"}</a>
          </div>

          <div className="flex items-center gap-4">
             {/* Language Selector */}
             <div className="relative">
               <button 
                 onClick={() => setShowLangMenu(!showLangMenu)}
                 className="px-4 py-2 rounded-xl bg-white/5 hover:bg-white/10 transition-all flex items-center justify-center gap-2 min-w-[80px]"
               >
                 <span className="text-sm leading-none flex items-center mt-[1px]">🌐</span>
                 <span className="text-sm leading-none font-bold text-accent-cyan uppercase tracking-widest">{lang}</span>
               </button>
               
               {showLangMenu && (
                 <>
                   <div className="fixed inset-0 z-[150]" onClick={() => setShowLangMenu(false)} />
                   <div className="absolute right-0 top-full mt-3 w-48 rounded-3xl p-3 shadow-2xl z-[200] animate-in fade-in slide-in-from-top-2 duration-300" style={{ background: 'rgba(15, 15, 15, 0.95)', backdropFilter: 'blur(24px)' }}>
                     <div className="grid gap-1.5">
                       {(Object.keys(translations) as Language[]).map((l) => (
                         <button
                           key={l}
                           onClick={() => {
                             changeLang(l);
                             setShowLangMenu(false);
                           }}
                           className={`w-full text-left px-4 py-3 rounded-xl text-[14px] font-semibold transition-all flex items-center justify-between group/item ${lang === l ? 'text-accent-cyan bg-accent-cyan/10' : 'text-secondary hover:bg-white/5 hover:text-white'}`}
                         >
                           <span>
                             {l === 'en' ? 'English' : 
                              l === 'zh' ? '简体中文' : 
                              l === 'zh_Hant' ? '繁體中文' : 
                              l === 'ko' ? '한국어' : 
                              l === 'ja' ? '日本語' : 
                              l === 'fr' ? 'Français' : 
                              l === 'de' ? 'Deutsch' : 
                              l === 'fi' ? 'Suomi' : 
                              l === 'ru' ? 'Русский' : l}
                           </span>
                           {lang === l && (
                             <div className="w-5 h-5 rounded-full bg-accent-cyan/20 flex items-center justify-center">
                               <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3.5">
                                 <path d="M20 6L9 17l-5-5" />
                               </svg>
                             </div>
                           )}
                         </button>
                       ))}
                     </div>
                   </div>
                 </>
               )}
             </div>
             <a href="/download" className="btn-nav font-bold">
               {t.nav.download}
               <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                 <path d="M12 17V3M6 11l6 6 6-6M19 21H5" />
               </svg>
             </a>
          </div>
        </div>
      </header>

      {/* Main Content with explicit padding to prevent overlap */}
      <main className="container pb-32" style={{ paddingTop: '160px' }}>
        {/* Header Section */}
        <div className="mb-24 text-center md:text-left">
          <p className="text-[10px] font-semibold uppercase tracking-[0.4em] text-accent-cyan mb-8">Latest Updates</p>
          <h1 className="text-6xl md:text-7xl font-bold text-clean">Changelog.</h1>
        </div>

        {/* Timeline Grid */}
        <div className="space-y-32">
          
          {/* Version 1.0.0 - Official Launch */}
          <div className="grid md:grid-cols-[200px_1fr] gap-12 lg:gap-24">
            <div className="space-y-4">
              <h2 className="text-4xl font-bold tracking-tight">v1.0.0</h2>
              <div className="inline-block px-3 py-1 rounded-full bg-accent-cyan/10 text-accent-cyan text-[10px] font-semibold uppercase tracking-widest border border-accent-cyan/20">
                Official Release
              </div>
              <p className="text-xs font-semibold text-zinc-600 uppercase tracking-widest mt-2">May 11, 2026</p>
            </div>

            <div className="bg-[#0d0d0d] border-thin rounded-[3rem] p-10 lg:p-16 space-y-12 shadow-2xl relative overflow-hidden">
               <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-accent-cyan/50 to-transparent opacity-30" />
               
               <div className="space-y-8">
                  <h3 className="text-xs font-semibold uppercase tracking-[0.3em] text-zinc-500">Major Features</h3>
                  <div className="grid md:grid-cols-2 gap-8">
                     <div className="space-y-4">
                        <h4 className="text-lg font-bold text-white">iCloud Sync</h4>
                        <p className="text-sm text-zinc-500 leading-relaxed font-normal">Full cross-device synchronization for terminal settings, profiles, and history using end-to-end encrypted iCloud containers.</p>
                     </div>
                     <div className="space-y-4">
                        <h4 className="text-lg font-bold text-white">Multilingual Engine</h4>
                        <p className="text-sm text-zinc-500 leading-relaxed font-normal">Native support for 9 global languages with dynamic locale switching and localized technical documentation.</p>
                     </div>
                  </div>
               </div>

               <div className="pt-12 border-t border-white/5 space-y-6">
                  <h3 className="text-xs font-semibold uppercase tracking-[0.3em] text-zinc-500">Improvements & Fixes</h3>
                  <ul className="space-y-4">
                    {[
                      "Optimized visual Zshrc editor for better performance on Apple Silicon (M1/M2/M3).",
                      "Enhanced terminal output parsing for faster configuration loading.",
                      "Fixed initial stability issues with background sync services.",
                      "Improved UI responsiveness on ProMotion displays."
                    ].map((item, i) => (
                      <li key={i} className="flex items-start gap-4 group">
                        <div className="mt-1.5 w-1.5 h-1.5 rounded-full bg-accent-cyan/40 group-hover:bg-accent-cyan transition-colors" />
                        <span className="text-zinc-400 group-hover:text-zinc-200 transition-colors text-sm font-medium leading-relaxed">{item}</span>
                      </li>
                    ))}
                  </ul>
               </div>
            </div>
          </div>
        </div>
      </main>

      <footer className="container py-24 border-t border-white/5 opacity-40">
        <div className="flex justify-between items-center text-[9px] font-normal uppercase tracking-[0.3em]">
          <p>© 2026 ZSHRC MANAGER. VERSION 1.0.0</p>
          <div className="flex gap-10">
            <a href="/privacy" className="hover:text-white transition-colors">Privacy</a>
            <a href="/terms" className="hover:text-white transition-colors">Terms</a>
            <a href="/pricing" className="hover:text-white transition-colors">Pricing</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
