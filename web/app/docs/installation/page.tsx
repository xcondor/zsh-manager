'use client';

import { useLanguage } from '../../i18n';

export default function InstallationDocs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const s = t.docs_subpages || {};

  return (
    <div className="space-y-10">
      <div>
        <h1 className="text-5xl font-black mb-4">
          {s.install_title || "Installation"}
        </h1>
        <p className="text-xl text-secondary">
          {s.install_desc || "Zshrc Manager is distributed as a standard macOS DMG package."}
        </p>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">{s.install_req || "System Requirements"}</h2>
        <ul className="list-disc list-inside text-secondary space-y-2 ml-4">
          <li>macOS 12.0 (Monterey) or later</li>
          <li>Apple Silicon (M1/M2/M3) or Intel processor</li>
          <li>Zsh (Default on modern macOS)</li>
        </ul>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">{s.install_step1 || "Step 1: Download"}</h2>
        <p className="text-secondary">
          {s.install_step1_desc || "Download the latest version of Zshrc Manager from the official website."}
        </p>
        <div className="bg-white/5 rounded-xl p-4 font-mono text-sm border border-white/5">
          ZshrcManager-v1.2.0.dmg
        </div>
      </div>

      <div className="space-y-8">
        <div className="flex items-center gap-4">
           <div className="flex h-10 w-10 items-center justify-center rounded-full bg-blue-500 text-white font-black">2</div>
           <h2 className="text-2xl font-bold">{s.install_step2 || "Drag to Applications"}</h2>
        </div>
        <p className="text-secondary">
          {s.install_step2_desc || "Open the downloaded DMG and drag the Zshrc Manager icon into your Applications folder."}
        </p>
        <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl max-w-2xl mx-auto">
          <img 
            src="/screenshots/installation.png" 
            alt="DMG Installation Window" 
            className="w-full h-auto block"
          />
        </div>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">{s.install_step3 || "Step 3: Initial Setup"}</h2>
        <p className="text-secondary">
          {s.install_step3_desc || "Upon first launch, Zshrc Manager will perform a quick scan of your ~/.zshrc file."}
        </p>
        <div className="p-4 bg-yellow-500/10 border border-yellow-500/20 rounded-xl text-sm text-yellow-400">
           <strong>{s.install_note || "Note: You may need to grant Full Disk Access to allow the application to modify configuration files in your home directory."}</strong>
        </div>
      </div>

      <div className="pt-10 border-t border-white/5">
        <div className="bg-accent-cyan/5 rounded-3xl p-8 lg:p-12">
          <div className="flex items-center gap-4 mb-6">
            <div className="h-12 w-12 rounded-2xl bg-accent-cyan/10 flex items-center justify-center">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" className="text-accent-cyan" strokeWidth="2.5">
                <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
              </svg>
            </div>
            <h2 className="text-3xl font-bold">{s.install_brew || "Install via Homebrew"}</h2>
          </div>
          <p className="text-secondary mb-8 text-lg">
            {s.install_brew_desc || "The fastest way for power users to install Zshrc Manager using the command line."}
          </p>
          <div className="relative group">
            <div className="absolute -inset-1 bg-accent-cyan/20 blur opacity-0 group-hover:opacity-100 transition duration-500 rounded-xl"></div>
            <div className="relative bg-black rounded-xl p-6 font-mono text-sm border border-white/10 flex justify-between items-center group-hover:border-accent-cyan/30 transition-colors">
              <code className="text-accent-cyan">brew install --cask zshrc-manager</code>
              <button 
                onClick={() => navigator.clipboard.writeText('brew install --cask zshrc-manager')}
                className="p-2 hover:bg-white/10 rounded-lg transition-colors text-secondary hover:text-white"
                title="Copy to clipboard"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                  <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
