'use client';

import React, { useState, useEffect } from 'react';
import { useLanguage } from '../i18n';
import { Language, translations } from '../translations';
import Script from 'next/script';

declare global {
  interface Window {
    Paddle: any;
  }
}

export default function Pricing() {
  const { lang, changeLang, t, mounted } = useLanguage();
  const [showLangMenu, setShowLangMenu] = useState(false);
  
  useEffect(() => {
    if (typeof window !== 'undefined' && window.Paddle) {
      const token = process.env.NEXT_PUBLIC_PADDLE_CLIENT_TOKEN || '';
      window.Paddle.Initialize({ 
        token: token,
        environment: token.startsWith('test_') ? 'sandbox' : 'production'
      });
    }
  }, []);

  const openCheckout = (priceId: string) => {
    if (window.Paddle) {
      window.Paddle.Checkout.open({
        settings: {
          displayMode: 'overlay',
          theme: 'dark',
          locale: lang === 'zh' ? 'zh-Hans' : 'en',
        },
        items: [
          {
            priceId: priceId,
            quantity: 1
          }
        ]
      });
    }
  };

  const tp = t.pricing_page;

  if (!mounted) return null;

  return (
    <div className="bg-black min-h-screen text-white antialiased selection:bg-accent-cyan/30">
      <Script 
        src="https://cdn.paddle.com/paddle/v2/paddle.js" 
        onLoad={() => {
          if (window.Paddle) {
            const token = process.env.NEXT_PUBLIC_PADDLE_CLIENT_TOKEN || '';
            window.Paddle.Initialize({ 
              token: token,
              environment: token.startsWith('test_') ? 'sandbox' : 'production'
            });
          }
        }}
      />
      <style jsx global>{`
        body { background: #000; color: #fff; }
        .spline-card { 
          background: #0a0a0a; 
          border: 1px solid #1a1a1a; 
          border-radius: 32px;
          display: flex;
          flex-direction: column;
          height: 100%;
          padding: 56px;
          transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
          position: relative;
        }
        .spline-card:hover {
          border-color: #333;
          background: #0f0f0f;
          transform: translateY(-10px);
          box-shadow: 0 40px 80px rgba(0,0,0,0.5);
        }
        .btn-pricing {
          width: 100%;
          height: 54px;
          display: flex;
          align-items: center;
          justify-content: center;
          border-radius: 16px;
          font-size: 13px;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.12em;
          transition: all 0.3s ease;
          margin-top: auto;
          border: none;
          text-decoration: none;
        }
        @keyframes popular-glow {
          0%, 100% { box-shadow: 0 0 20px rgba(0, 216, 192, 0.2); }
          50% { box-shadow: 0 0 40px rgba(0, 216, 192, 0.5); }
        }
        .popular-badge {
          background: #00D8C0;
          color: #000;
          font-size: 8px;
          font-weight: 900;
          padding: 4px 10px;
          border-radius: 99px;
          display: flex;
          align-items: center;
          gap: 4px;
          box-shadow: 0 4px 15px rgba(0, 216, 192, 0.4);
          animation: popular-glow 2s infinite;
          text-transform: uppercase;
          letter-spacing: 0.1em;
        }
      `}</style>

      {/* Navigation */}
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
            <a href="/pricing" className="text-white transition-colors">{t.nav.pricing}</a>
            <a href="/docs" className="hover:text-white transition-colors">{t.footer?.docs || "Documentation"}</a>
          </div>

          <div className="flex items-center gap-4">
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

      {/* Main Content */}
      <main className="container pb-40" style={{ paddingTop: '200px' }}>
        {/* Hero Section with Refined Spacing */}
        <div className="text-center mb-64 space-y-10">
          <p className="text-[11px] font-semibold uppercase tracking-[0.45em] text-accent-cyan">{tp.plans_label}</p>
          <h1 className="text-6xl md:text-8xl font-bold leading-[1.05] tracking-tighter">
            {tp.title?.split('.').map((part: string, i: number) => part && (
              <React.Fragment key={i}>
                {part}{i === 0 && <br className="hidden md:block" />}
              </React.Fragment>
            ))}
          </h1>
          <p className="text-xl text-zinc-500 max-w-none mx-auto font-normal leading-relaxed pt-8 md:whitespace-nowrap">
            {tp.subtitle}
          </p>
        </div>

        {/* Premium License Panel */}
        <div className="flex justify-center items-center py-20 px-4">
          <div 
            style={{
              width: '100%',
              maxWidth: '500px',
              backgroundColor: '#111111',
              borderRadius: '24px',
              border: '1px solid #222222',
              padding: '48px',
              boxShadow: '0 40px 100px rgba(0,0,0,0.5)',
              textAlign: 'center'
            }}
          >
            {/* Header */}
            <div style={{ marginBottom: '40px' }}>
              <div style={{
                display: 'inline-block',
                padding: '4px 12px',
                borderRadius: '100px',
                backgroundColor: 'rgba(0, 216, 192, 0.1)',
                border: '1px solid rgba(0, 216, 192, 0.2)',
                color: '#00D8C0',
                fontSize: '10px',
                fontWeight: 'bold',
                letterSpacing: '0.2em',
                textTransform: 'uppercase',
                marginBottom: '16px'
              }}>
                {tp.pro}
              </div>
              <h2 style={{ fontSize: '32px', fontWeight: '700', color: '#FFF', letterSpacing: '-0.02em', margin: '0' }}>
                Lifetime License
              </h2>
            </div>

            {/* Price */}
            <div style={{ marginBottom: '48px' }}>
              <div style={{ fontSize: '72px', fontWeight: '800', color: '#FFF', letterSpacing: '-0.04em', lineHeight: '1' }}>
                {tp.pro_price}
              </div>
              <div style={{ color: '#666', fontSize: '13px', marginTop: '12px', fontWeight: '500' }}>
                {tp.activation_method}
              </div>
            </div>

            {/* Features List */}
            <div style={{ 
              textAlign: 'left', 
              backgroundColor: 'rgba(255,255,255,0.02)', 
              borderRadius: '16px', 
              padding: '24px',
              marginBottom: '40px',
              border: '1px solid rgba(255,255,255,0.05)'
            }}>
              <ul style={{ listStyle: 'none', padding: '0', margin: '0', display: 'grid', gap: '16px' }}>
                {tp.features?.pro?.map((f: string, i: number) => (
                  <li key={i} style={{ display: 'flex', alignItems: 'center', gap: '12px', fontSize: '14px', color: '#AAA' }}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#00D8C0" strokeWidth="3">
                      <path d="M20 6L9 17l-5-5" />
                    </svg>
                    {f}
                  </li>
                ))}
              </ul>
            </div>

            {/* CTA Button */}
            <button 
              style={{
                width: '100%',
                height: '60px',
                backgroundColor: '#FFF',
                color: '#000',
                border: 'none',
                borderRadius: '14px',
                fontSize: '15px',
                fontWeight: '800',
                cursor: 'pointer',
                transition: 'all 0.2s',
                marginBottom: '20px'
              }}
              onMouseOver={(e) => e.currentTarget.style.backgroundColor = '#EEE'}
              onMouseOut={(e) => e.currentTarget.style.backgroundColor = '#FFF'}
              onClick={() => openCheckout(process.env.NEXT_PUBLIC_PADDLE_PRICE_ID || '12345')}
            >
              {tp.get_pro || '立即获取终身访问权限'}
            </button>

            {/* Footer Info */}
            <div style={{ opacity: '0.5' }}>
              <p style={{ color: '#666', fontSize: '11px', margin: '0 0 12px 0', lineHeight: '1.5' }}>
                {tp.license_footer}
              </p>
              <div style={{ display: 'flex', justifyContent: 'center', gap: '16px' }}>
                 <span style={{ fontSize: '10px', fontWeight: 'bold', color: '#444' }}>VISA</span>
                 <span style={{ fontSize: '10px', fontWeight: 'bold', color: '#444' }}>MASTERCARD</span>
                 <span style={{ fontSize: '10px', fontWeight: 'bold', color: '#444' }}>PAYPAL</span>
              </div>
            </div>
          </div>
        </div>

        {/* Comparison Footer */}
        <div className="mt-64 grid md:grid-cols-2 gap-24 py-32 border-t border-white/5">
           <div className="space-y-6">
              <h4 className="text-xs font-semibold uppercase tracking-[0.25em] text-zinc-500">{tp.native_title}</h4>
              <p className="text-[16px] text-zinc-500 leading-relaxed font-normal opacity-70">
                {tp.native_desc}
              </p>
           </div>
           <div className="space-y-6">
              <h4 className="text-xs font-semibold uppercase tracking-[0.25em] text-zinc-500">{tp.private_title}</h4>
              <p className="text-[16px] text-zinc-500 leading-relaxed font-normal opacity-70">
                {tp.private_desc}
              </p>
           </div>
        </div>
      </main>

      <footer className="container py-24 border-t border-white/5 opacity-40">
        <div className="flex justify-between items-center text-[10px] font-normal uppercase tracking-[0.35em]">
          <p>© 2026 ZSHRC MANAGER</p>
          <div className="flex gap-12">
            <a href="/privacy" className="hover:text-white transition-colors">{t.footer.links[0].split(' ')[0]}</a>
            <a href="/terms" className="hover:text-white transition-colors">{t.footer.links[1].split(' ')[0]}</a>
            <a href="/refund" className="hover:text-white transition-colors">{t.footer.refund}</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
