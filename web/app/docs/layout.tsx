'use client';

import React from 'react';
import { useLanguage } from '../i18n';

export default function DocsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};

  const sidebarItems = [
    { title: t.docs?.intro_title || "Getting Started", items: [
      { name: t.docs?.intro_title || "Introduction", href: "/docs" },
      { name: s.install_title || "Installation", href: "/docs/installation" },
    ]},
    { title: t.nav?.features || "Core Features", items: [
      { name: s.tm_title || "Terminal Master", href: "/docs/terminal-master" },
      { name: s.cd_title || "Config Doctor", href: "/docs/config-doctor" },
      { name: s.sync_title || "iCloud Sync (Pro)", href: "/docs/cloud-sync" },
      { name: s.snap_title || "Snapshots", href: "/docs/snapshots" },
    ]},
    { title: t.common?.advanced || "Advanced", items: [
      { name: s.python_title || "Python Manager", href: "/docs/python-manager" },
      { name: s.manual_title || "Manual Configurations", href: "/docs/manual" },
    ]}
  ];

  return (
    <div className="bg-grid min-h-screen">
      <nav className="glass sticky top-0 z-50 w-full border-b border-white/5">
        <div className="container max-w-6xl mx-auto flex h-16 items-center justify-between">
          <div className="flex items-center gap-2">
            <a href="/" className="flex items-center gap-2">
              <div className="h-8 w-8 rounded-lg bg-white/10 flex items-center justify-center">
                <span className="text-lg font-bold text-gradient">Z</span>
              </div>
              <span className="text-xl font-bold tracking-tight">Zshrc Docs</span>
            </a>
          </div>
          <a href="/" className="text-sm font-medium text-secondary hover:text-white transition-colors">
            {t.common?.backToSite || "Back to Site"}
          </a>
        </div>
      </nav>

      <div className="container max-w-6xl mx-auto py-12" style={{ display: 'flex', gap: '3rem' }}>
        <aside style={{ width: '256px', flexShrink: 0 }}>
          <div className="sticky top-24 space-y-8">
            {sidebarItems.map((group, i) => (
              <div key={i}>
                <h4 className="font-bold text-white mb-3 text-sm tracking-wider uppercase opacity-80">{group.title}</h4>
                <div className="flex flex-col gap-2">
                  {group.items.map((item, j) => (
                    <a 
                      key={j} 
                      href={item.href}
                      className="text-secondary hover:text-white transition-colors text-sm py-1"
                    >
                      {item.name}
                    </a>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </aside>
        <main className="max-w-3xl" style={{ flex: 1 }}>
          {children}
        </main>
      </div>
    </div>
  );
}
