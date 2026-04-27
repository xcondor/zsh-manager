import { AppWindow, StepIcon } from "../../../components/DocsComponents";

export default function ManualDocs() {
  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">Expert Mode: Manual Edits</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          While automation is our core, we respect your expertise. Zshrc Manager provides a 
          high-performance internal editor for manual `.zshrc` refinements with real-time linting.
        </p>
      </section>

      <div className="grid gap-16 lg-grid-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Integrated Editor</h3>
                <p className="text-secondary">
                  Access the "Expert" tab to view your raw configuration files. 
                  We use the same text engine underlying top-tier macOS code editors.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Safe Sandbox</h3>
                <p className="text-secondary">
                  Changes made manually are validated by the "Config Doctor" before being applied 
                  to your system, preventing accidental shell lockout.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Modular Source</h3>
                <p className="text-secondary">
                  Manage external exports and modular script sourcing easily. 
                  Drag and drop files to generate the correct `source` commands instantly.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg-order-2">
          <AppWindow title=".zshrc — Pro Editor">
            <div className="p-0 font-mono text-sm leading-relaxed overflow-hidden">
               <div className="flex bg-white/5 border-b border-white/5 px-4 py-2 text-[10px] uppercase font-bold tracking-widest text-secondary gap-6">
                  <span className="text-blue-400">Main .zshrc</span>
                  <span className="opacity-40">.zsh_aliases</span>
                  <span className="opacity-40">.zsh_env</span>
               </div>
               <div className="p-6 space-y-2">
                  <div className="flex gap-4">
                    <span className="opacity-30 w-4">1</span>
                    <p><span className="text-purple-400">export</span> ZSH=<span className="text-green-400">"$HOME/.oh-my-zsh"</span></p>
                  </div>
                  <div className="flex gap-4">
                    <span className="opacity-30 w-4">2</span>
                    <p><span className="text-purple-400">ZSH_THEME</span>=<span className="text-green-400">"powerlevel10k/powerlevel10k"</span></p>
                  </div>
                  <div className="flex gap-4">
                    <span className="opacity-30 w-4">3</span>
                    <p><span className="text-secondary"># Load user custom scripts</span></p>
                  </div>
                  <div className="flex gap-4">
                    <span className="opacity-30 w-4">4</span>
                    <p><span className="text-purple-400">source</span> ~/scripts/custom_init.sh</p>
                  </div>
                  <div className="flex gap-4 bg-white/5 border-l-2 border-blue-500 pl-4 py-1">
                    <span className="opacity-30 w-4">5</span>
                    <p>alias <span className="text-yellow-400">gs</span>=<span className="text-green-400">'git status'</span>|</p>
                  </div>
               </div>
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}
