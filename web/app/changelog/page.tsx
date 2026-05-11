'use client';

import React from 'react';
import { useLanguage } from '../i18n';

export default function Changelog() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const tc = t.changelog_page || {};

  return (
    <div className="bg-grid min-h-screen">
      <nav className="glass sticky top-0 z-50 w-full border-b border-white/5">
        <div className="container flex h-16 items-center justify-between">
          <div className="flex items-center gap-2">
            <a href="/" className="flex items-center gap-2">
              <div className="h-8 w-8 rounded-lg bg-white/10 flex items-center justify-center">
                <span className="text-lg font-bold text-gradient">Z</span>
              </div>
              <span className="text-xl font-bold tracking-tight">Zshrc Manager</span>
            </a>
          </div>
          <a href="/" className="text-sm font-medium text-secondary hover:text-white transition-colors">
            {t.common?.backToSite || "Back to Site"}
          </a>
        </div>
      </nav>

      <div className="container max-w-4xl py-24">
        <div className="glass rounded-3xl p-8 lg:p-16">
          <h1 className="text-4xl lg:text-5xl font-black mb-12">{tc.title || "Changelog"}</h1>
          
          <div className="prose prose-invert max-w-none space-y-16 pl-6">
            
            <section className="relative">
              <div className="absolute -left-12 top-2 h-4 w-4 rounded-full bg-accent-cyan shadow-[0_0_10px_rgba(0,216,192,0.5)]"></div>
              <h2 className="text-3xl font-bold mb-2">Version 2.1.0</h2>
              <p className="text-sm text-secondary/60 mb-6 font-bold uppercase tracking-widest">May 10, 2026</p>
              <ul className="space-y-3 text-secondary leading-relaxed list-disc list-inside">
                <li><strong className="text-white">{tc.new || "New"}:</strong> Complete UI overhaul with high-end dark mode aesthetics.</li>
                <li><strong className="text-white">{tc.new || "New"}:</strong> Added comprehensive multi-language support (9 languages).</li>
                <li><strong className="text-white">{tc.improved || "Improved"}:</strong> Enhanced macOS iCloud sync stability for environment variables.</li>
                <li><strong className="text-white">{tc.fixed || "Fixed"}:</strong> Resolved issue where Python virtual environments were not correctly detected.</li>
              </ul>
            </section>

            <section className="relative">
              <div className="absolute -left-12 top-2 h-4 w-4 rounded-full bg-white/20"></div>
              <h2 className="text-3xl font-bold mb-2 text-white/60">Version 2.0.0</h2>
              <p className="text-sm text-secondary/40 mb-6 font-bold uppercase tracking-widest">January 15, 2026</p>
              <ul className="space-y-3 text-secondary/60 leading-relaxed list-disc list-inside">
                <li><strong className="text-white/60">{tc.new || "New"}:</strong> Transitioned to a permanent license one-time purchase model.</li>
                <li><strong className="text-white/60">{tc.new || "New"}:</strong> Introduced intelligent conflict resolution during sync.</li>
                <li><strong className="text-white/60">{tc.improved || "Improved"}:</strong> Faster parsing of large .zshrc configuration files.</li>
              </ul>
            </section>

          </div>
        </div>
      </div>
    </div>
  );
}
