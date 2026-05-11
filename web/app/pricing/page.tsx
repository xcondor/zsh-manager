'use client';

import React from 'react';
import { useLanguage } from '../i18n';

export default function Pricing() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const tp = t.pricing_page || {};

  return (
    <div className="bg-[#050505] min-h-screen relative overflow-hidden selection:bg-accent-cyan/30">
      {/* Dynamic Background Elements */}
      <div className="absolute -top-[10%] -left-[10%] w-[50%] h-[50%] bg-accent-cyan/10 rounded-full blur-[150px] animate-pulse pointer-events-none" />
      <div className="absolute -bottom-[10%] -right-[10%] w-[50%] h-[50%] bg-purple-500/10 rounded-full blur-[150px] animate-pulse pointer-events-none" style={{ animationDelay: '2s' }} />
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full h-full bg-grid opacity-20 pointer-events-none" />

      <nav className="glass sticky top-0 z-[100] w-full">
        <div className="container flex h-20 items-center justify-between">
          <a href="/" className="flex items-center gap-3 group">
            <div className="h-10 w-10 rounded-xl bg-white/5 flex items-center justify-center transition-all group-hover:scale-110 group-hover:bg-accent-cyan/10">
              <span className="text-xl font-black text-gradient">Z</span>
            </div>
            <span className="text-2xl font-bold tracking-tighter">Zshrc Manager</span>
          </a>
          <a href="/" className="btn-secondary py-2 px-6 text-sm">
            {t.common?.backToSite || "Back to Site"}
          </a>
        </div>
      </nav>

      <main className="container relative z-10 pt-20 pb-40">
        {/* Hero Section */}
        <div className="text-center mb-24 space-y-6">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 backdrop-blur-md mb-4">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-accent-cyan opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-accent-cyan"></span>
            </span>
            <span className="text-xs font-bold tracking-widest uppercase text-secondary">
              {tp.trusted_by || "Trusted by 10,000+ developers worldwide"}
            </span>
          </div>
          <h1 className="text-6xl lg:text-8xl font-black tracking-tighter text-white leading-[0.9]">
            {tp.title || "Simple, Transparent Pricing"}
          </h1>
          <p className="text-xl text-secondary max-w-2xl mx-auto opacity-70">
            {tp.subtitle || "One-time payment. Lifetime access. No recurring subscriptions."}
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-12 items-center max-w-6xl mx-auto">
          {/* Main Pricing Card */}
          <div className="relative group">
            <div className="absolute -inset-1 bg-gradient-to-r from-accent-cyan to-purple-500 rounded-[2.5rem] blur opacity-10 group-hover:opacity-30 transition duration-1000 group-hover:duration-200"></div>
            <div className="relative glass rounded-[2.5rem] p-10 lg:p-14 flex flex-col h-full shadow-2xl overflow-hidden">
              <div className="absolute top-0 left-0 w-full h-full bg-gradient-to-b from-white/[0.02] to-transparent pointer-events-none" />
              <div className="relative z-10 flex justify-between items-start mb-10">
                <div>
                  <h3 className="text-3xl font-black mb-2 text-white">{tp.lifetime_license || "Lifetime License"}</h3>
                  <p className="text-secondary text-lg">{tp.lifetime_desc || "Everything you need to master your terminal."}</p>
                </div>
                <div className="h-14 w-14 rounded-2xl bg-accent-cyan/10 flex items-center justify-center">
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" className="text-accent-cyan" strokeWidth="2.5">
                    <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                  </svg>
                </div>
              </div>

              <div className="mb-12 flex items-baseline gap-4">
                <span className="text-8xl font-black text-white tracking-tighter">$29</span>
                <div className="flex flex-col">
                  <span className="text-xl text-secondary line-through opacity-40">$59</span>
                  <span className="text-accent-cyan font-bold uppercase tracking-widest text-sm">{tp.forever || "forever"}</span>
                </div>
              </div>

              <ul className="space-y-6 mb-12 flex-1">
                {(tp.features || []).map((feature: string, i: number) => (
                  <li key={i} className="flex items-center gap-4 text-lg text-secondary group/item">
                    <div className="w-6 h-6 rounded-full bg-white/5 flex items-center justify-center shrink-0 group-hover/item:bg-accent-cyan group-hover/item:text-black transition-all">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="4">
                        <path d="M20 6L9 17l-5-5" />
                      </svg>
                    </div>
                    <span className="group-hover/item:text-white transition-colors">{feature}</span>
                  </li>
                ))}
              </ul>

              <button className="w-full py-6 rounded-2xl bg-white text-black font-black text-xl hover:bg-accent-cyan transition-all hover:scale-[1.02] active:scale-[0.98] shadow-[0_20px_50px_rgba(255,255,255,0.1)] hover:shadow-accent-cyan/30">
                {tp.buy_now || "Get Started Now"}
              </button>
              
              <div className="mt-8 flex items-center justify-center gap-2 text-secondary opacity-50 text-sm font-medium">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                  <path d="M7 11V7a5 5 0 0110 0v4" />
                </svg>
                {tp.guarantee || "Includes 30-day money back guarantee."}
              </div>
            </div>
          </div>

          {/* Trust & Details Column */}
          <div className="space-y-8 lg:pl-12">
            <div className="glass rounded-3xl p-8 transition-colors bg-white/[0.02] hover:bg-white/[0.04]">
              <div className="h-12 w-12 rounded-2xl bg-blue-500/10 flex items-center justify-center mb-6">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" className="text-blue-400" strokeWidth="2">
                  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                </svg>
              </div>
              <h4 className="text-xl font-bold mb-2 text-white">{tp.safe_secure || "Safe & Secure"}</h4>
              <p className="text-secondary leading-relaxed opacity-70">
                {tp.safe_desc || "Your data never leaves your device. iCloud sync is end-to-end encrypted."}
              </p>
            </div>

            <div className="glass rounded-3xl p-8 transition-colors bg-white/[0.02] hover:bg-white/[0.04]">
              <div className="h-12 w-12 rounded-2xl bg-green-500/10 flex items-center justify-center mb-6">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" className="text-green-400" strokeWidth="2">
                  <circle cx="12" cy="12" r="10" />
                  <path d="M16 8l-4 4-4-4" />
                  <path d="M12 12v6" />
                </svg>
              </div>
              <h4 className="text-xl font-bold mb-2 text-white">{tp.money_back || "30-Day Money Back"}</h4>
              <p className="text-secondary leading-relaxed opacity-70">
                {tp.money_desc || "If you're not satisfied, we'll refund your purchase within 30 days."}
              </p>
            </div>

            <div className="p-8">
              <p className="text-lg text-secondary italic opacity-80 leading-relaxed">
                "{tp.testimonial_text || "Zshrc Manager has completely transformed how I manage my terminal environment. The one-time payment was the best investment I've made for my dev setup."}"
              </p>
              <div className="mt-4 flex items-center gap-3">
                <div className="h-10 w-10 rounded-full bg-white/10" />
                <div>
                  <div className="font-bold text-white text-sm">{tp.testimonial_author || "Alex Rivera"}</div>
                  <div className="text-xs text-secondary opacity-50">{tp.testimonial_role || "Senior DevOps Engineer"}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>

      <footer className="container py-20 relative z-10">
        <div className="flex flex-col md:flex-row justify-between items-center gap-8 text-secondary opacity-50 text-sm">
          <p>{t.footer?.copyright || "© 2026 Zshrc Manager. All rights reserved."}</p>
          <div className="flex gap-8">
            <a href="/privacy" className="hover:text-white transition-colors">{t.footer?.links?.[0] || "Privacy"}</a>
            <a href="/terms" className="hover:text-white transition-colors">{t.footer?.links?.[1] || "Terms"}</a>
            <a href="/refund" className="hover:text-white transition-colors">{t.footer?.refund || "Refund"}</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
