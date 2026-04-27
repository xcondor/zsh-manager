'use client';

import { useState, useEffect } from 'react';
import { translations, Language } from './translations';

export default function Home() {
  const [lang, setLang] = useState<Language>('en');

  useEffect(() => {
    const saved = localStorage.getItem('lang') as Language;
    if (saved && translations[saved]) {
      setLang(saved);
    } else {
      const browserLang = navigator.language.split('-')[0];
      if (browserLang === 'zh') {
        setLang(navigator.language.includes('Hant') || navigator.language.includes('TW') || navigator.language.includes('HK') ? 'zh_Hant' : 'zh');
      } else if (translations[browserLang as Language]) {
        setLang(browserLang as Language);
      }
    }
  }, []);

  const changeLang = (l: Language) => {
    setLang(l);
    localStorage.setItem('lang', l);
  };

  const t = translations[lang];

  return (
    <main className="relative min-h-screen overflow-hidden">
      <div className="bg-glow hero-glow" />
      
      {/* Navigation */}
      <nav className="sticky glass z-50">
        <div className="container flex h-20 items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white/10">
              <span className="text-xl font-black text-gradient">Z</span>
            </div>
            <span className="text-2xl font-black tracking-tight">Zshrc Manager</span>
          </div>
          
          <div className="flex items-center gap-8">
            <div className="hidden md:flex items-center gap-8 mr-4">
              <a href="#features" className="text-sm font-bold text-secondary hover:text-white transition-colors">{t.nav.features}</a>
              <a href="/docs" className="text-sm font-bold text-secondary hover:text-white transition-colors">{t.nav.docs}</a>
            </div>

            {/* Language Selector */}
            <div className="relative group">
              <button className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-white/5 border border-white/10 text-xs font-bold hover:bg-white/10 transition-all">
                <span className="opacity-60">🌐</span>
                {lang === 'en' ? 'English' : 
                 lang === 'zh' ? '简体中文' : 
                 lang === 'zh_Hant' ? '繁體中文' : 
                 lang === 'ko' ? '한국어' : 
                 lang === 'ja' ? '日本語' : 
                 lang === 'fr' ? 'Français' : 
                 lang === 'de' ? 'Deutsch' : 
                 lang === 'fi' ? 'Suomi' : 
                 lang === 'ru' ? 'Русский' : lang}
              </button>
              <div className="absolute right-0 top-full mt-2 w-40 glass rounded-xl border border-white/10 p-2 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all space-y-1 shadow-2xl">
                {(Object.keys(translations) as Language[]).map((l) => (
                  <button
                    key={l}
                    onClick={() => changeLang(l)}
                    className={`w-full text-left px-3 py-2 rounded-lg text-xs font-bold hover:bg-white/10 transition-colors ${lang === l ? 'text-blue-400 bg-white/5' : 'text-secondary'}`}
                  >
                    {l === 'en' ? 'English' : 
                     l === 'zh' ? '简体中文' : 
                     l === 'zh_Hant' ? '繁體中文' : 
                     l === 'ko' ? '한국어' : 
                     l === 'ja' ? '日本語' : 
                     l === 'fr' ? 'Français' : 
                     l === 'de' ? 'Deutsch' : 
                     l === 'fi' ? 'Suomi' : 
                     l === 'ru' ? 'Русский' : l}
                  </button>
                ))}
              </div>
            </div>

            <a href="https://musayp.com/buy" className="btn-primary" style={{ padding: '10px 24px', fontSize: '14px' }}>
              {t.nav.buy}
            </a>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="section text-center relative">
        <div className="container">
          <div className="mx-auto max-w-4xl">
            <div className="inline-flex rounded-full border border-white/10 bg-white/5 px-6 py-2 text-xs font-bold text-purple-400 mb-12 animate-pulse">
              {t.hero.version}
            </div>
            <h1 className="mb-8 text-7xl font-black lg:text-8xl tracking-tighter">
              {t.hero.title1} <br />
              <span className="text-gradient">{t.hero.title2}</span>
            </h1>
            <p className="mb-12 text-xl text-secondary max-w-2xl mx-auto leading-relaxed">
              {t.hero.subtitle}
            </p>
            <div className="flex items-center justify-center gap-6">
              <a href="#" className="btn-primary">{t.hero.download}</a>
              <a href="#features" className="btn-secondary">{t.hero.viewFeatures}</a>
            </div>
          </div>
          
          {/* App Preview Mockup */}
          <div className="mt-20 relative">
            <div className="animate-float glass rounded-3xl mx-auto max-w-4xl border border-white/20 p-2 shadow-[0_50px_100px_rgba(0,0,0,0.6)]">
              <div className="bg-[#050505] rounded-2xl overflow-hidden aspect-video">
                 {/* Simulated Content */}
                 <div className="flex h-full">
                    <div className="w-64 border-r border-white/5 bg-white/5 p-6 space-y-4">
                       {[1, 2, 3, 4].map(i => (
                         <div key={i} className={`h-8 rounded-lg bg-white/${i===1 ? '10' : '5'} w-full border border-white/5`} />
                       ))}
                    </div>
                    <div className="flex-1 p-12 space-y-8">
                       <div className="flex items-center justify-between">
                          <div className="h-12 w-64 bg-gradient-to-r from-blue-500/20 to-purple-500/20 border border-white/10 rounded-2xl" />
                          <div className="h-10 w-32 bg-blue-500/80 rounded-xl" />
                       </div>
                       <div className="grid grid-cols-2 gap-8">
                          {[1, 2, 3, 4].map(i => (
                            <div key={i} className="h-40 rounded-3xl bg-white/5 border border-white/5" />
                          ))}
                       </div>
                    </div>
                 </div>
              </div>
            </div>
            {/* Soft Glow Under App */}
            <div className="absolute -bottom-20 left-1/2 -translate-x-1/2 w-3/4 h-32 bg-blue-500/20 blur-100px" />
          </div>
        </div>
      </section>

      {/* Trusted By / Stats (Simulated) */}
      <section className="py-20 border-y border-white/5 bg-white/[0.02]">
        <div className="container flex flex-wrap justify-between items-center opacity-40 grayscale gap-12 px-12">
           <span className="text-2xl font-black italic tracking-tighter">APPLE SILICON</span>
           <span className="text-2xl font-black italic tracking-tighter">OH MY ZSH</span>
           <span className="text-2xl font-black italic tracking-tighter">POWERLEVEL10K</span>
           <span className="text-2xl font-black italic tracking-tighter">ICLOUD SYNC</span>
        </div>
      </section>

      {/* Features Grid */}
      <section id="features" className="section relative">
        <div className="bg-glow" style={{ right: '-200px', top: '20%' }} />
        <div className="container">
          <div className="text-center mb-20 space-y-4">
            <h2 className="text-6xl font-black uppercase tracking-tighter">
              {t.features.title}
            </h2>
            <p className="text-xl text-secondary max-w-2xl mx-auto">
              {t.features.subtitle}
            </p>
          </div>
          
          <div className="grid gap-8 md:grid-cols-3">
            {t.features.cards.map((card: any, i: number) => (
              <div key={i} className="feature-card">
                <div className="feature-card-icon">{i === 0 ? '🚀' : i === 1 ? '🧬' : '🩺'}</div>
                <h3 className="text-2xl font-black mb-4">
                  {card.title}
                </h3>
                <p className="text-secondary leading-relaxed opacity-80">
                  {card.desc}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing / CTA */}
      <section id="pricing" className="section relative">
        <div className="container">
          <div className="glass p-16 rounded-[48px] relative overflow-hidden flex flex-col items-center text-center">
            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-blue-500 to-transparent" />
            
            <div className="mb-8 inline-block px-4 py-1 rounded-full bg-blue-500/20 text-blue-400 text-xs font-black tracking-widest uppercase">
               {t.pricing.offer}
            </div>
            
            <h2 className="text-6xl font-black mb-8 leading-none tracking-tighter">
              {t.pricing.title} <br />
              <span className="text-gradient">Zshrc Manager Pro</span>
            </h2>
            
            <p className="mb-12 text-xl text-secondary max-w-2xl leading-relaxed">
              {t.pricing.subtitle}
            </p>
            
            <div className="flex items-baseline gap-4 mb-16">
               <span className="text-8xl font-black">$18</span>
               <span className="text-2xl text-secondary line-through font-bold opacity-40">$39.00</span>
            </div>
            
            <a href="https://musayp.com/buy" className="btn-primary" style={{ padding: '24px 80px', fontSize: '20px' }}>
              {t.pricing.buy}
            </a>
            
            <div className="mt-12 flex flex-wrap justify-center items-center gap-8 text-sm font-bold text-secondary uppercase tracking-widest opacity-60">
               {t.pricing.features.map((f: string, i: number) => (
                 <span key={i} className="flex items-center gap-8">
                   {i > 0 && <span>•</span>}
                   {f}
                 </span>
               ))}
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-20 border-t border-white/5">
        <div className="container flex flex-col md:flex-row justify-between items-center gap-12 text-center md:text-left">
          <div className="space-y-4">
            <div className="flex items-center justify-center md:justify-start gap-2">
               <div className="h-8 w-8 rounded-lg bg-white/10 flex items-center justify-center font-black">Z</div>
               <span className="text-2xl font-black tracking-tighter">Zshrc Manager</span>
            </div>
            <p className="text-sm text-secondary max-w-xs leading-relaxed">
              {t.footer.tagline}
            </p>
          </div>
          
          <div className="flex gap-16 text-sm font-bold uppercase tracking-widest">
             <div className="flex flex-col gap-4">
                <span className="text-xs text-secondary opacity-50 mb-2">{t.footer.product}</span>
                <a href="#features" className="hover:text-blue-500 transition-colors">{t.nav.features}</a>
                <a href="/docs" className="hover:text-blue-500 transition-colors">{t.nav.docs}</a>
                <a href="https://musayp.com/buy" className="hover:text-blue-500 transition-colors">{t.nav.buy}</a>
             </div>
             <div className="flex flex-col gap-4">
                <span className="text-xs text-secondary opacity-50 mb-2">{t.footer.connect}</span>
                <a href="#" className="hover:text-blue-500 transition-colors">Twitter</a>
                <a href="#" className="hover:text-blue-500 transition-colors">GitHub</a>
                <a href="mailto:musayp9527@gmail.com" className="hover:text-blue-500 transition-colors">Support</a>
             </div>
          </div>
        </div>
        <div className="container mt-20 pt-8 border-t border-white/5 text-center text-xs text-secondary font-medium tracking-widest uppercase opacity-40">
           {t.footer.copyright}
        </div>
      </footer>
    </main>
  );
}
