'use client';

import { useState } from 'react';
import { useLanguage } from './i18n';
import { Language, translations } from './translations';

export default function Home() {
  const { lang, changeLang, t, mounted } = useLanguage();
  const [showLangMenu, setShowLangMenu] = useState(false);
  const [activeFaq, setActiveFaq] = useState<number | null>(null);

  if (!mounted) {
    return <main className="relative min-h-screen pb-0 bg-black"></main>;
  }

  return (
    <main className="relative min-h-screen pb-0">
      <div className="bg-glow hero-glow" />
      <div className="bg-glow" style={{ top: '60%', left: '-100px', opacity: 0.1 }} />
      <div className="bg-glow" style={{ top: '80%', right: '-100px', opacity: 0.1, background: 'radial-gradient(circle, var(--accent-cyan) 0%, transparent 70%)' }} />
      
      {/* Full-width Sticky Navigation */}
      <header id="site-header" className="fixed top-0 left-0 right-0 z-[9999]">
        <div className="container h-20 flex items-center justify-between px-6">
          <div className="flex items-center gap-3">
             <div className="w-10 h-10 rounded-xl bg-accent-cyan flex items-center justify-center shadow-[0_0_20px_rgba(0,216,192,0.4)]">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#000" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="4 17 10 11 4 5" />
                  <line x1="12" y1="19" x2="20" y2="19" />
                </svg>
             </div>
             <span className="text-xl font-semibold tracking-tighter text-white">Zshrc Manager</span>
          </div>
          
          <div className="hidden lg:flex items-center gap-8 text-xs font-semibold text-secondary uppercase tracking-[0.1em]">
            <a href="#features" className="hover:text-white transition-colors">{t.nav.features}</a>
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
             <a href="#" className="btn-nav">
               {t.nav.download}
               <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                 <path d="M12 17V3M6 11l6 6 6-6M19 21H5" />
               </svg>
             </a>
          </div>
        </div>
      </header>

      <section className="section pt-48 pb-32 overflow-hidden">
        <div className="container max-w-5xl text-center">
            <div className="flex justify-center items-center gap-4 mb-8">
              <div className="badge">
                 <span className="text-sm"></span>
                 {t.hero.badge}
              </div>
              <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 text-[11px] font-bold text-secondary uppercase tracking-widest">
                <span className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
                {t.socialProof.count} {t.socialProof.label}
              </div>
            </div>
            
            <h1 className="text-6xl lg:text-7xl leading-tight tracking-[-0.04em] font-black max-w-4xl mx-auto mb-6">
              {t.hero?.title}
            </h1>
            
            <p className="text-xl lg:text-2xl text-secondary max-w-2xl mx-auto leading-relaxed font-medium opacity-80 mb-12">
              {t.hero.subtitle}
            </p>
          
          <div className="flex flex-col md:flex-row items-center justify-center gap-6 w-full mb-16">
            <a href="#" className="btn-primary">
              {t.hero.getStarted}
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </a>
            <a href="#features" className="btn-secondary group">
              {t.hero.learnMore}
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className="group-hover:translate-x-1 transition-transform">
                <path d="M9 18l6-6-6-6" />
              </svg>
            </a>
          </div>

          {/* Homebrew Command Area */}
          <div className="max-w-2xl mx-auto mt-12 animate-in fade-in slide-in-from-bottom-8 duration-1000 delay-500">
            <div className="relative group">
              <div className="absolute -inset-1 bg-gradient-to-r from-accent-cyan/20 to-purple-500/20 rounded-2xl blur opacity-0 group-hover:opacity-100 transition duration-1000"></div>
              <div className="relative bg-[#080808] rounded-2xl p-2 pl-6 pr-2 flex items-center justify-between border border-white/5 hover:border-accent-cyan/30 transition-all duration-500">
                <div className="flex items-center gap-3">
                  <span className="text-accent-cyan font-black text-sm">$</span>
                  <code className="text-sm font-mono text-secondary group-hover:text-white transition-colors">brew install --cask zshrc-manager</code>
                </div>
                <button 
                  onClick={() => {
                    navigator.clipboard.writeText('brew install --cask zshrc-manager');
                    // Optional: show a temporary toast or change icon
                  }}
                  className="p-3 bg-white/5 hover:bg-white/10 rounded-xl transition-all text-secondary hover:text-accent-cyan active:scale-95"
                  title="Copy to clipboard"
                >
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                    <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
                  </svg>
                </button>
              </div>
            </div>
            <p className="mt-4 text-[10px] uppercase tracking-[0.2em] font-black text-secondary/30 text-center">
              {t.docs_subpages?.install_brew_desc || "Quick Install for Power Users"}
            </p>
          </div>
        </div>
      </section>

      {/* Features Section - Optimized Grid Spacing */}
      <section id="features" className="section py-24">
        <div className="container">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {(t.features?.cards || []).map((card: any, i: number) => (
              <div 
                key={i} 
                className="group relative p-12 rounded-[4rem] bg-[#080808] transition-all duration-700 flex flex-col h-full overflow-hidden"
              >
                {/* Hover Glow Effect */}
                <div className="absolute -top-24 -right-24 w-48 h-48 bg-accent-cyan/5 blur-[80px] rounded-full group-hover:bg-accent-cyan/10 transition-all duration-700" />
                
                <div className="relative z-10 flex flex-col items-center h-full text-center">
                  <div className="mb-10">
                    <div className="w-16 h-16 rounded-2xl bg-white/[0.03] flex items-center justify-center text-accent-cyan group-hover:scale-110 group-hover:bg-accent-cyan group-hover:text-black transition-all duration-700 shadow-2xl relative overflow-hidden">
                      <div className="absolute inset-0 bg-gradient-to-br from-white/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className="relative z-10">
                        <path d={
                          i === 0 ? "M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" :
                          i === 1 ? "M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" :
                          i === 2 ? "M12 15V3m0 12l-4-4m4 4l4-4M2 17l.62 2.48A2 2 0 004.56 21h14.88a2 2 0 001.94-1.52L22 17" :
                          "M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                        } />
                      </svg>
                    </div>
                  </div>
                  
                  <h3 className="text-2xl font-bold tracking-tight text-white mb-6 group-hover:text-accent-cyan transition-colors duration-500">{card.title}</h3>
                  <p className="text-base text-secondary mb-12 opacity-50 group-hover:opacity-90 transition-opacity duration-500 px-4 leading-relaxed">{card.desc}</p>
                  
                  <div className="mt-auto flex flex-col items-center gap-3 w-full">
                    {(card.highlights || []).slice(0, 2).map((highlight: string, j: number) => (
                      <span key={j} className="text-[10px] text-secondary/40 font-black uppercase tracking-[0.3em] truncate w-full">
                        {highlight}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>



      {/* FAQ Section */}
      <section id="faq" className="section py-32">
        <div className="container max-w-3xl">
          <div className="text-center mb-20 space-y-4">
            <h2 className="text-5xl font-semibold tracking-tight">{t.faq.title}</h2>
            <p className="text-secondary opacity-60">{t.faq.subtitle}</p>
          </div>
          <div className="flex flex-col gap-6">
            {(t.faq.items || []).map((item: any, i: number) => (
              <div 
                key={i} 
                className={`faq-item group relative rounded-3xl transition-all duration-500 ${activeFaq === i ? 'active bg-white/[0.03] shadow-2xl' : 'hover:bg-white/[0.01]'}`}
              >
                <button 
                  onClick={() => setActiveFaq(activeFaq === i ? null : i)}
                  className="faq-question py-8 px-8 w-full text-left flex justify-between items-center group"
                >
                  <div className="flex items-center text-left">
                    <span className="w-12 shrink-0 text-xs font-black text-accent-cyan/30 tracking-widest uppercase">{String(i + 1).padStart(2, '0')}</span>
                    <span className={`text-xl font-bold transition-all duration-300 ${activeFaq === i ? 'text-accent-cyan' : 'text-primary group-hover:text-white'}`}>{item.q}</span>
                  </div>
                  <div className={`w-10 h-10 flex items-center justify-center transition-all duration-500 ${activeFaq === i ? 'text-accent-cyan rotate-180' : 'text-secondary group-hover:text-white'}`}>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                      <path d="m6 9 6 6 6-6" />
                    </svg>
                  </div>
                </button>
                <div className={`faq-answer transition-all duration-500 ${activeFaq === i ? 'opacity-100' : 'opacity-0'}`}>
                  <div className="px-8 pb-8 pt-2 flex">
                    <div className="w-12 shrink-0" />
                    <p className="text-lg text-secondary/70 leading-relaxed max-w-2xl border-l-2 border-accent-cyan/20 pl-6">{item.a}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-24 relative overflow-hidden">
        <div className="container text-center relative z-10">
          <div className="p-16 lg:p-24 rounded-[4rem] bg-white/[0.02] relative overflow-hidden group">
            <div className="absolute inset-0 bg-gradient-to-br from-accent-cyan/[0.05] via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-1000" />
            <div className="absolute inset-0 bg-gradient-to-b from-accent-cyan/[0.03] to-transparent pointer-events-none" />
            
            <div className="relative z-10 flex flex-col items-center">
              <h2 className="text-4xl lg:text-5xl font-bold tracking-tight max-w-3xl mx-auto leading-tight mb-4">{t.cta?.title}</h2>
              <p className="text-xl text-secondary max-w-xl mx-auto mb-12">{t.cta?.subtitle}</p>
              
              <div className="flex flex-col md:flex-row items-center justify-center gap-12 w-full">
              <a href="#" className="btn-primary px-16 py-6 text-lg font-black">
                {t.cta?.download}
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3">
                  <path d="M5 12h14M12 5l7 7-7 7" />
                </svg>
              </a>
              <div className="flex flex-col items-center md:items-start gap-1.5 pl-12 h-14 justify-center">
                <span className="text-white text-xs font-black tracking-widest uppercase">{t.cta?.version}</span>
                <span className="text-secondary/40 text-[10px] font-bold uppercase tracking-[0.2em]">{t.cta?.requires}</span>
              </div>
              </div>
            </div>
          </div>
        </div>
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full h-full bg-accent-cyan/5 blur-[120px] -z-10" />
      </section>

      {/* Professional Footer */}
      <footer className="py-16 lg:py-24 bg-black relative z-[400]">
        <div className="container max-w-6xl">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-12 lg:gap-24 mb-16">
            {/* Brand */}
            <div className="col-span-1 md:col-span-1 flex flex-col gap-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-accent-cyan flex items-center justify-center shadow-[0_0_15px_rgba(0,216,192,0.3)]">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#000" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                    <polyline points="4 17 10 11 4 5" />
                    <line x1="12" y1="19" x2="20" y2="19" />
                  </svg>
                </div>
                <span className="text-xl font-bold text-white tracking-tight">{t.nav.title || "Zshrc Manager"}</span>
              </div>
              <p className="text-sm text-secondary leading-relaxed opacity-70">
                {t.footer?.tagline}
              </p>
            </div>

            {/* Product */}
            <div className="flex flex-col gap-4">
              <h4 className="text-sm font-bold text-white tracking-wider">{t.footer?.product || "Product"}</h4>
              <a href="#features" className="text-sm text-secondary hover:text-white transition-colors">{t.nav.features}</a>
              <a href="/docs" className="text-sm text-secondary hover:text-white transition-colors">{t.footer?.docs || "Documentation"}</a>
              <a href="/changelog" className="text-sm text-secondary hover:text-white transition-colors">{t.footer?.changelog || t.nav.changelog}</a>
            </div>

            {/* Support */}
            <div className="flex flex-col gap-4">
              <h4 className="text-sm font-bold text-white tracking-wider">{t.footer?.support || "Support"}</h4>
              <a href="#faq" className="text-sm text-secondary hover:text-white transition-colors">{t.nav.faq}</a>
              <a href="/contact" className="text-sm text-secondary hover:text-white transition-colors">{t.footer?.contact || "Contact Us"}</a>
            </div>

            {/* Legal */}
            <div className="flex flex-col gap-4">
              <h4 className="text-sm font-bold text-white tracking-wider">{t.footer?.legal || "Legal"}</h4>
              <a href="/privacy" className="text-sm text-secondary hover:text-white transition-colors">
                {t.footer?.links?.[0] || "Privacy Policy"}
              </a>
              <a href="/terms" className="text-sm text-secondary hover:text-white transition-colors">
                {t.footer?.links?.[1] || "Terms of Service"}
              </a>
              <a href="/refund" className="text-sm text-secondary hover:text-white transition-colors">
                {t.footer?.refund || "Refund Policy"}
              </a>
            </div>
          </div>

          <div className="pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-xs text-secondary opacity-50">
              {t.footer.copyright}
            </p>
            <div className="flex items-center gap-6">
              <a href="https://maczsh.com" className="text-xs font-semibold text-accent-cyan uppercase tracking-widest hover:opacity-70 transition-opacity">maczsh.com</a>
            </div>
          </div>
        </div>
      </footer>
    </main>
  );
}
