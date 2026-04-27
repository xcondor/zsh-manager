import React from 'react';

export default function DocsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const sidebarItems = [
    { title: "Getting Started", items: [
      { name: "Introduction", href: "/docs" },
      { name: "Installation", href: "/docs/installation" },
    ]},
    { title: "Core Features", items: [
      { name: "Terminal Master", href: "/docs/terminal-master" },
      { name: "Config Doctor", href: "/docs/config-doctor" },
      { name: "iCloud Sync (Pro)", href: "/docs/cloud-sync" },
      { name: "Snapshots", href: "/docs/snapshots" },
    ]},
    { title: "Advanced", items: [
      { name: "Python Manager", href: "/docs/python-manager" },
      { name: "Manual Configurations", href: "/docs/manual" },
    ]}
  ];

  return (
    <div className="bg-grid min-h-screen">
      <nav className="glass sticky top-0 z-50 w-full border-b border-white/5">
        <div className="container flex h-16 items-center justify-between">
          <div className="flex items-center gap-2">
            <a href="/" className="flex items-center gap-2">
              <div className="h-8 w-8 rounded-lg bg-white/10 flex items-center justify-center">
                <span className="text-lg font-bold text-gradient">Z</span>
              </div>
              <span className="text-xl font-bold tracking-tight">Zshrc Docs</span>
            </a>
          </div>
          <a href="/" className="text-sm font-medium text-secondary hover:text-white transition-colors">Back to Site</a>
        </div>
      </nav>

      <div className="container py-12">
        <div className="grid gap-12 lg-grid-docs">
          {/* Docs Sidebar */}
          <aside className="sticky top-28 h-fit space-y-8 md:block hidden">
            {sidebarItems.map(section => (
              <div key={section.title} className="space-y-3">
                <h4 className="text-xs font-bold uppercase tracking-wider text-secondary">{section.title}</h4>
                <ul className="space-y-1">
                  {section.items.map(item => (
                    <li key={item.name}>
                      <a href={item.href} className="block py-1.5 text-sm font-medium text-secondary hover:text-white transition-colors">
                        {item.name}
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </aside>

          {/* Docs Content */}
          <div className="glass rounded-3xl p-8 lg:p-12 min-h-[600px]">
            <div className="prose prose-invert max-w-none">
              {children}
            </div>
            
            <div className="mt-20 pt-8 border-t border-white/5 flex justify-between items-center text-sm text-secondary">
               <p>© 2024 Zshrc Manager Documentation</p>
               <div className="flex gap-4">
                  <a href="#" className="hover:text-white">Edit on GitHub</a>
                  <a href="/" className="hover:text-white">Main Site</a>
               </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
