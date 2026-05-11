'use client';

import { useState, useEffect } from 'react';
import { translations, Language } from './translations';

export function useLanguage() {
  const [lang, setLang] = useState<Language>('en');
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    const saved = localStorage.getItem('lang') as Language;
    if (saved && translations[saved]) {
      setLang(saved);
    } else {
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
    window.dispatchEvent(new CustomEvent('languagechange_custom', { detail: l }));
  };

  const t = mounted ? translations[lang] : translations['en'];

  return { lang, changeLang, t, mounted };
}
