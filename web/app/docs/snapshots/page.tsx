import { AppWindow, StepIcon } from "../../../components/DocsComponents";

export default function SnapshotsDocs() {
  return (
    <div className="space-y-20">
      <section>
        <h1 className="text-5xl font-black mb-6">Time Machine for Zsh</h1>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          Zshrc Manager automatically creates snapshots of your configuration before every major change. 
          Roll back to any previous state with zero risk and absolute confidence.
        </p>
      </section>

      <div className="grid gap-16 lg-grid-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Auto-Versioning</h3>
                <p className="text-secondary">
                  Every time you "Publish" a change, a new local snapshot is generated. 
                  We keep the last 50 versions by default.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Instant Rollback</h3>
                <p className="text-secondary">
                  Select any version from the "Snapshots" tab and hit "Restore". 
                  The app will swap your `.zshrc` and restart your shell automatically.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Compare Diffs</h3>
                <p className="text-secondary">
                  See exactly what changed between iterations with a built-in diff viewer. 
                  Identify lines that might be causing performance issues.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg-order-2">
          <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl">
            <img 
              src="/screenshots/snapshots.png" 
              alt="Snapshots Library Interface" 
              className="w-full h-auto block"
            />
          </div>
          <div className="mt-6 p-4 bg-white/5 rounded-2xl border border-white/5">
             <p className="text-xs text-secondary italic text-center">
               The sidebar in the app (as shown above) allows you to quickly switch between distinct configuration contexts.
             </p>
          </div>
        </div>
      </div>
    </div>
  );
}
