'use client';

import React, { useState } from 'react';
import { useLanguage } from '../../i18n';

export default function LicenseCheckPage() {
  const { t } = useLanguage();
  const [key, setKey] = useState('');
  const [result, setResult] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const checkLicense = async () => {
    if (!key.trim()) return;
    setLoading(true);
    setError('');
    setResult(null);

    try {
      // 简单模拟查询逻辑，实际可扩展为查询数据库
      // 这里的逻辑是调用我们之前写的算法进行本地预校验
      const res = await fetch('/api/license/activate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ key, machineId: 'QUERY_ONLY' })
      });
      
      const data = await res.json();
      if (res.status === 403) {
        setError(t.pricing_page.starter === 'Starter' ? 'Invalid CD-Key' : '无效的授权码');
      } else {
        setResult(data);
      }
    } catch (err) {
      setError('Connection failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-black min-h-screen text-white flex flex-col items-center justify-center p-6 antialiased selection:bg-accent-cyan/30">
      <div className="max-w-md w-full space-y-10 text-center">
        
        <div className="space-y-4">
          <div className="w-16 h-16 rounded-2xl bg-accent-cyan/10 border border-accent-cyan/20 flex items-center justify-center mx-auto mb-6">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#00D8C0" strokeWidth="2.5">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
              <path d="M7 11V7a5 5 0 0110 0v4" />
            </svg>
          </div>
          <h1 className="text-4xl font-bold tracking-tighter italic">License Checker</h1>
          <p className="text-zinc-500 font-medium">{t.footer.check_license}</p>
        </div>

        <div className="space-y-4">
          <input 
            type="text" 
            placeholder="ZRC-XXXX-XXXX-XXXX-XXXX"
            value={key}
            onChange={(e) => setKey(e.target.value.toUpperCase())}
            className="w-full bg-zinc-900 border border-white/10 rounded-2xl px-6 py-4 font-mono text-center text-accent-cyan focus:outline-none focus:border-accent-cyan/50 transition-all placeholder:text-zinc-700"
          />
          <button 
            onClick={checkLicense}
            disabled={loading}
            className="w-full h-14 rounded-2xl bg-white text-black font-bold uppercase text-xs tracking-widest hover:brightness-90 active:scale-[0.98] transition-all disabled:opacity-50"
          >
            {loading ? 'Checking...' : 'Verify License'}
          </button>
        </div>

        {error && (
          <div className="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-500 text-xs font-bold uppercase tracking-widest animate-in fade-in zoom-in duration-300">
            {error}
          </div>
        )}

        {result && (
          <div className="p-8 rounded-[32px] bg-accent-cyan/5 border border-accent-cyan/20 text-left space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="flex items-center justify-between">
              <span className="text-[10px] font-bold text-accent-cyan uppercase tracking-widest">Status</span>
              <span className="px-2 py-0.5 rounded-md bg-accent-cyan text-black text-[9px] font-black uppercase">Valid</span>
            </div>
            <div className="space-y-1">
              <label className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest">License Type</label>
              <p className="text-lg font-bold italic tracking-tight">{result.licenseType}</p>
            </div>
            <div className="pt-4 border-t border-white/5 flex items-center gap-3">
              <div className="w-2 h-2 rounded-full bg-accent-cyan shadow-[0_0_10px_#00D8C0]" />
              <p className="text-[11px] text-zinc-400 font-medium">Ready for App Activation</p>
            </div>
          </div>
        )}

        <div className="pt-10">
          <a href="/" className="text-[10px] text-zinc-600 hover:text-white transition-colors font-bold uppercase tracking-[0.2em]">
            ← Back to Home
          </a>
        </div>
      </div>
    </div>
  );
}
