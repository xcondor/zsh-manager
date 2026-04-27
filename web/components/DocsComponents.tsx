import React from 'react';

export const AppWindow = ({ title, children, className = "" }: { title: string, children: React.ReactNode, className?: string }) => (
  <div className={`glass rounded-2xl overflow-hidden border border-white/10 shadow-2xl ${className}`}>
    <div className="bg-white/5 px-4 py-2 flex items-center justify-between border-b border-white/5">
      <div className="flex gap-1.5">
        <div className="w-2.5 h-2.5 rounded-full bg-[#FF5F57]"></div>
        <div className="w-2.5 h-2.5 rounded-full bg-[#FFBD2E]"></div>
        <div className="w-2.5 h-2.5 rounded-full bg-[#28C840]"></div>
      </div>
      <div className="text-10px font-medium text-secondary uppercase tracking-widest">{title}</div>
      <div className="w-10"></div>
    </div>
    <div className="p-1">
       <div className="bg-[#050505] rounded-xl overflow-hidden">
          {children}
       </div>
    </div>
  </div>
);

export const StepIcon = ({ children, colorClass = "bg-blue-500" }: { children: React.ReactNode, colorClass?: string }) => (
  <div className={`w-8 h-8 ${colorClass} rounded-full flex items-center justify-center font-bold text-white mb-4`}>
    {children}
  </div>
);

export const ProBadge = () => (
  <span className="bg-purple-500/20 text-purple-400 text-10px font-bold px-2 py-0.5 rounded-full border border-purple-500/30 ml-2 align-middle">PRO</span>
);
