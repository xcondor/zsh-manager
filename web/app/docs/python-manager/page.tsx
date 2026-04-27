import { AppWindow, StepIcon } from "../../../components/DocsComponents";

export default function PythonDocs() {
  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">Python & Conda Environment</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          Managing Python environments on macOS can be a nightmare. Zshrc Manager simplifies this 
          by providing a visual hook for Conda, Homebrew Python, and custom virtual environments.
        </p>
      </section>

      <div className="grid gap-16 lg-grid-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Automated Init</h3>
                <p className="text-secondary">
                  Automatically detect installed Conda or Mamba installations and inject the 
                  required initialization code into your shell without manual copying.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Alias Shortcuts</h3>
                <p className="text-secondary">
                  Create quick-switch aliases for different Python versions. Toggle between 
                  Python 3.9 and 3.12 with single-character commands defined in the UI.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Path Intelligence</h3>
                <p className="text-secondary">
                  Zshrc Manager analyzes your `$PATH` to ensure Python binaries are prioritized 
                  correctly, avoiding the common "command not found" pitfalls after updates.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg-order-2">
          <AppWindow title="Environment Manager">
            <div className="p-8 space-y-8">
               <div className="space-y-4">
                  <div className="flex items-center justify-between">
                     <span className="text-sm font-bold">Base Interpreter</span>
                     <span className="text-xs text-blue-400 font-mono">/usr/local/bin/python3</span>
                  </div>
                  <div className="h-2 w-full bg-white/5 rounded-full">
                     <div className="h-full w-full bg-green-500/50 rounded-full"></div>
                  </div>
               </div>

               <div className="grid grid-cols-2 gap-4">
                  <div className="p-4 glass rounded-2xl border-white/5 text-center space-y-2">
                     <p className="text-xs text-secondary uppercase font-bold tracking-widest">Conda</p>
                     <p className="text-lg font-black text-green-400">Linked</p>
                  </div>
                  <div className="p-4 glass rounded-2xl border-white/5 text-center space-y-2">
                     <p className="text-xs text-secondary uppercase font-bold tracking-widest">Homebrew</p>
                     <p className="text-lg font-black">Active</p>
                  </div>
               </div>
               
               <div className="p-4 bg-white/5 rounded-2xl border border-white/5 font-mono text-[11px] text-secondary">
                  $ which python <br />
                  <span className="text-white">/opt/homebrew/bin/python3</span>
               </div>
            </div>
          </AppWindow>
        </div>
      </div>
    </div>
  );
}
