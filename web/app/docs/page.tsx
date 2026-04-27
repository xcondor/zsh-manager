export default function DocsHome() {
  return (
    <div className="space-y-10">
      <div>
        <h1 className="text-5xl font-black mb-4">Introduction</h1>
        <p className="text-xl text-secondary leading-relaxed">
          Zshrc Manager is the ultimate macOS desktop application designed to simplify 
          your shell environment management. Whether you're a seasoned developer or 
          just starting out, our tool provides a professional GUI to master Zsh.
        </p>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <div className="bg-white/5 rounded-2xl p-6 border border-white/5">
          <h3 className="text-lg font-bold mb-2">GUI First</h3>
          <p className="text-sm text-secondary">No more editing hidden dotfiles in Vim. Manage everything via a beautiful Native macOS interface.</p>
        </div>
        <div className="bg-white/5 rounded-2xl p-6 border border-white/5">
          <h3 className="text-lg font-bold mb-2">Safe & Reliable</h3>
          <p className="text-sm text-secondary">Every change is validated and backed up. One click restoration if anything goes wrong.</p>
        </div>
      </div>

      <div className="space-y-6">
        <h2 className="text-2xl font-bold">Visual Preview</h2>
        <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl">
          <img 
            src="/screenshots/terminal-master.png" 
            alt="Zshrc Manager Dashboard" 
            className="w-full h-auto block"
          />
        </div>
      </div>

      <div>
        <h2 className="text-3xl font-bold mb-6">Key Documentation Sections</h2>
        <ul className="space-y-4">
          <li>
            <a href="/docs/installation" className="group block">
              <h4 className="font-bold group-hover:text-blue-400 transition-colors">Installation →</h4>
              <p className="text-sm text-secondary">Step-by-step guide to get Zshrc Manager running on your Mac.</p>
            </a>
          </li>
          <li>
            <a href="/docs/terminal-master" className="group block">
              <h4 className="font-bold group-hover:text-blue-400 transition-colors">Terminal Master →</h4>
              <p className="text-sm text-secondary">Learn how to install themes like Powerlevel10k and Nerd Fonts automatically.</p>
            </a>
          </li>
          <li>
            <a href="/docs/config-doctor" className="group block">
              <h4 className="font-bold group-hover:text-blue-400 transition-colors">Config Doctor →</h4>
              <p className="text-sm text-secondary">Understand how the diagnostic engine detects and fixes path issues.</p>
            </a>
          </li>
        </ul>
      </div>

      <div className="p-8 bg-blue-500/10 rounded-3xl border border-blue-500/20">
         <h4 className="font-bold mb-2">Need help?</h4>
         <p className="text-sm text-secondary mb-4">Can't find what you're looking for? Reach out to our support team.</p>
         <a href="mailto:musayp9527@gmail.com" className="text-blue-400 text-sm font-bold hover:underline">Contact Support</a>
      </div>
    </div>
  );
}
