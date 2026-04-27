import { AppWindow, ProBadge, StepIcon } from "../../../components/DocsComponents";

export default function CloudSyncDocs() {
  return (
    <div className="space-y-20">
      <section>
        <div className="flex items-center gap-4 mb-6">
          <h1 className="text-5xl font-black">iCloud Dynamic Sync <ProBadge /></h1>
        </div>
        <p className="text-xl text-secondary leading-relaxed max-w-3xl">
          Never lose your terminal configuration again. Zshrc Manager Pro seamlessly integrates with your 
          iCloud Drive to keep your aliases, environment paths, and plugins synchronized across every Mac you own.
        </p>
      </section>

      <div className="grid gap-16 lg-grid-2">
        <div className="space-y-12">
          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <StepIcon>1</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Enable iCloud Drive</h3>
                <p className="text-secondary">
                  Ensure iCloud Drive is enabled in your System Settings. Zshrc Manager uses a secure hidden container 
                  to store your configuration snapshots.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>2</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">One-Click Backup</h3>
                <p className="text-secondary">
                  Hit the "Sync Now" button to upload your local `.zshrc` and related scripts to the cloud. 
                  Conflict resolution is handled automatically.
                </p>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <StepIcon>3</StepIcon>
              <div>
                <h3 className="text-2xl font-bold mb-2">Restore Anywhere</h3>
                <p className="text-secondary">
                  On a new Mac, simply sign in to the same iCloud account, open Zshrc Manager, 
                  and your entire environment is ready to be restored in seconds.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg-order-2">
          <div className="glass rounded-3xl overflow-hidden border border-white/10 shadow-2xl">
            <img 
              src="/screenshots/sync.png" 
              alt="iCloud Sync Interface" 
              className="w-full h-auto block"
            />
          </div>
          <div className="mt-8 p-6 glass rounded-2xl border-purple-500/20 bg-purple-500/5">
             <h4 className="text-sm font-bold mb-4 uppercase tracking-widest text-purple-400">Pro Feature Status</h4>
             <div className="flex items-center justify-between">
                <div>
                   <p className="font-bold text-sm text-white">Full iCloud Integration</p>
                   <p className="text-xs text-secondary">Active & Monitoring Changes</p>
                </div>
                <div className="w-10 h-10 rounded-full bg-purple-500/20 flex items-center justify-center text-purple-400">⚡️</div>
             </div>
          </div>
        </div>
      </div>
    </div>
  );
}
