'use client';

import React, { useState } from 'react';

export default function AdminLicensePage() {
  const [keys, setKeys] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [count, setCount] = useState(5);

  const generateKeys = async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/license/generate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ count })
      });
      const data = await res.json();
      if (data.success) {
        setKeys(data.keys);
      }
    } catch (err) {
      alert('Generation failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-black min-h-screen text-white p-12 font-sans selection:bg-accent-cyan/30">
      <div className="max-w-4xl mx-auto space-y-12 pt-20">
        
        <header className="space-y-4">
          <div className="inline-flex px-3 py-1 rounded-full bg-accent-cyan/10 border border-accent-cyan/20 text-accent-cyan text-[10px] font-bold tracking-widest uppercase">
            Internal Tool
          </div>
          <h1 className="text-5xl font-bold tracking-tighter">License Generator</h1>
          <p className="text-zinc-500 font-medium">Generate professional CD-Keys for Zshrc Manager Lifetime access.</p>
        </header>

        <section className="p-10 rounded-[32px] bg-zinc-900/50 border border-white/5 space-y-8">
          <div className="flex items-center gap-6">
            <div className="flex-1 space-y-2">
              <label className="text-[10px] uppercase tracking-widest text-zinc-500 font-bold">Quantity</label>
              <input 
                type="number" 
                value={count}
                onChange={(e) => setCount(parseInt(e.target.value))}
                className="w-full bg-black border border-white/10 rounded-xl px-4 py-3 font-mono text-accent-cyan focus:outline-none focus:border-accent-cyan/50 transition-colors"
              />
            </div>
            <button 
              onClick={generateKeys}
              disabled={loading}
              className="mt-6 px-10 h-[52px] rounded-xl bg-accent-cyan text-black font-bold uppercase text-xs tracking-widest hover:brightness-110 active:scale-95 transition-all disabled:opacity-50"
            >
              {loading ? 'Generating...' : 'Generate Keys'}
            </button>
          </div>

          {keys.length > 0 && (
            <div className="space-y-4 animate-in fade-in slide-in-from-bottom-4 duration-500">
              <div className="flex justify-between items-center">
                <h3 className="text-[10px] uppercase tracking-widest text-zinc-500 font-bold">Generated Keys</h3>
                <button 
                  onClick={() => {
                    navigator.clipboard.writeText(keys.join('\n'));
                    alert('All keys copied to clipboard');
                  }}
                  className="text-[10px] text-accent-cyan hover:underline font-bold uppercase tracking-widest"
                >
                  Copy All
                </button>
              </div>
              <div className="grid gap-2">
                {keys.map((key, i) => (
                  <div key={i} className="flex items-center justify-between p-4 bg-black rounded-xl border border-white/5 hover:border-white/10 transition-colors group">
                    <code className="text-accent-cyan font-mono tracking-wider">{key}</code>
                    <button 
                      onClick={() => navigator.clipboard.writeText(key)}
                      className="opacity-0 group-hover:opacity-100 transition-opacity px-3 py-1 rounded-lg bg-white/5 text-[10px] font-bold uppercase"
                    >
                      Copy
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}
        </section>

        <footer className="pt-12 border-t border-white/5">
          <p className="text-[10px] text-zinc-600 font-medium leading-relaxed">
            SECURITY NOTE: These keys use HMAC-SHA256 signatures. They are verified locally by the Zshrc Manager app. 
            Keep the LICENSE_SECRET environment variable safe.
          </p>
        </footer>
      </div>
    </div>
  );
}
