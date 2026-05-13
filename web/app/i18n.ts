'use client';

import { useState, useEffect } from 'react';
import { translations, Language } from './translations';

export function useLanguage() {
  const [lang, setLang] = useState<Language>('en');
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    
    // 1. 优先级最高：localStorage (用户之前的手动选择)
    let saved = localStorage.getItem('lang') as Language;
    
    // 2. 优先级次之：Cookie (Middleware 根据 IP/系统语言识别的结果)
    if (!saved || !translations[saved]) {
      const cookieValue = document.cookie
        .split('; ')
        .find(row => row.startsWith('lang='))
        ?.split('=')[1] as Language;
      
      if (cookieValue && translations[cookieValue]) {
        saved = cookieValue;
      }
    }

    if (saved && translations[saved]) {
      setLang(saved);
    } else {
      // 3. 最后兜底：浏览器 navigator 对象侦测
      const browserLang = navigator.language.split('-')[0];
      if (browserLang === 'zh') {
        setLang(navigator.language.includes('Hant') || navigator.language.includes('TW') || navigator.language.includes('HK') ? 'zh_Hant' : 'zh');
      } else if (translations[browserLang as Language]) {
        setLang(browserLang as Language);
      }
    }

    const handleStorageChange = (e: StorageEvent) => {
      if (e.key === 'lang' && translations[e.newValue as Language]) {
        setLang(e.newValue as Language);
      }
    };
    
    const handleCustomChange = (e: CustomEvent) => {
      setLang(e.detail);
    };

    window.addEventListener('storage', handleStorageChange);
    window.addEventListener('languagechange_custom' as any, handleCustomChange);

    return () => {
      window.removeEventListener('storage', handleStorageChange);
      window.removeEventListener('languagechange_custom' as any, handleCustomChange);
    };
  }, []);

  const changeLang = (l: Language) => {
    setLang(l);
    localStorage.setItem('lang', l);
    // 同时同步更新 Cookie，确保下次进入中间件时能识别
    document.cookie = `lang=${l}; path=/; max-age=${60 * 60 * 24 * 30}; samesite=lax`;
    window.dispatchEvent(new CustomEvent('languagechange_custom', { detail: l }));
  };

  const t = mounted ? translations[lang] : translations['en'];

  return { lang, changeLang, t, mounted };
}
