import { AppWindow, StepIcon, ProBadge } from "@/components/DocsComponents";

export default function ConfigDoctorDocs() {
  return (
    <div className="space-y-20">
      <section className="space-y-6">
        <h1 className="text-5xl font-black mb-4">Config Doctor</h1>
        <p className="text-xl text-secondary max-w-3xl">
          Keep your shell environment in peak condition with automated health checks 
          and intelligent healing.
        </p>
      </section>

      {/* Feature 1: Intelligent Scanning */}
      <section className="grid gap-12 lg:grid-cols-2 items-center">
        <div className="space-y-6">
          <StepIcon colorClass="bg-green-500">1</StepIcon>
          <h2 className="text-3xl font-bold">Comprehensive Scanning</h2>
          <p className="text-secondary leading-relaxed">
            Config Doctor performs a deep audit of your <code>~/.zshrc</code>, <code>~/.zprofile</code>, 
            and <code>$PATH</code> variables. It identifies dead links, broken exports, and 
            redundant configurations that slow down your shell startup.
          </p>
          <div className="p-4 rounded-xl bg-white/5 border border-white/5 space-y-3">
             <div className="flex items-center gap-2 text-xs text-green-400 font-bold">
                <span>●</span> Diagnostic Routine Active
             </div>
             <div className="h-1.5 w-full bg-white/10 rounded-full overflow-hidden">
                <div className="h-full w-2/3 bg-green-500 rounded-full animate-pulse"></div>
             </div>
          </div>
        </div>
        <AppWindow title="Environment Diagnostic">
          <div className="p-6">
             <div className="space-y-4">
                <div className="flex items-center justify-between p-3 rounded-lg border border-red-500/20 bg-red-500/5">
                   <div className="flex items-center gap-3">
                      <span className="text-red-500">⚠</span>
                      <span className="text-[10px] font-mono">Invalid Path Detected</span>
                   </div>
                   <span className="text-[9px] text-red-500/50 uppercase font-black">Broken</span>
                </div>
                <div className="flex items-center justify-between p-3 rounded-lg border border-green-500/20 bg-green-500/5">
                   <div className="flex items-center gap-3">
                      <span className="text-green-500">✓</span>
                      <span className="text-[10px] font-mono">Syntax Integrity OK</span>
                   </div>
                   <span className="text-[9px] text-green-500/50 uppercase font-black">Healthy</span>
                </div>
             </div>
          </div>
        </AppWindow>
      </section>

      {/* Feature 2: Automated Healing */}
      <section className="grid gap-12 lg:grid-cols-2 items-center">
        <div className="lg:order-2 space-y-6">
          <StepIcon colorClass="bg-blue-500">2</StepIcon>
          <h2 className="text-3xl font-bold">One-Click Remediation</h2>
          <p className="text-secondary leading-relaxed">
            When an issue is found, Zshrc Manager offers a safe remediation path. 
            Before any fix is applied, the app creates a <strong>Snapshot</strong> 
            of your current configuration, allowing you to revert at any time.
          </p>
          <div className="flex gap-4">
             <button className="px-6 py-2 rounded-xl bg-blue-500 text-sm font-bold shadow-xl shadow-blue-500/20">
                Fix All Issues
             </button>
             <button className="px-6 py-2 rounded-xl glass text-sm font-medium border border-white/10">
                Scan Again
             </button>
          </div>
        </div>
        <div className="lg:order-1">
          <AppWindow title="Healing Center">
            <div className="p-6 flex flex-col items-center text-center space-y-4">
               <div className="w-16 h-16 rounded-full bg-blue-500/10 flex items-center justify-center text-3xl">🩺</div>
               <div>
                  <h4 className="font-bold">Optimization Complete</h4>
                  <p className="text-[10px] text-secondary">3 Path entries repaired. Startup time optimized by 12ms.</p>
               </div>
               <div className="w-full h-px bg-white/5"></div>
               <div className="text-[9px] text-secondary italic">Snapshot created: 2024-04-21_1527</div>
            </div>
          </AppWindow>
        </div>
      </section>
    </div>
  );
}
