import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const { nextUrl, cookies, headers } = request;
  
  // 1. 如果用户已经手动设置过语言（存储在 Cookie 中），则跳过自动侦测
  if (cookies.has('lang')) {
    return NextResponse.next();
  }

  // 2. 获取地理位置信息 (Cloudflare 注入的请求头)
  const country = headers.get('cf-ipcountry') || '';
  
  // 3. 获取浏览器偏好语言
  const acceptLang = headers.get('accept-language') || '';

  let detectedLang = 'en'; // 默认语言

  // 4. 基于 IP 的国家代码映射逻辑
  const countryMap: Record<string, string> = {
    'CN': 'zh',
    'TW': 'zh_Hant',
    'HK': 'zh_Hant',
    'MO': 'zh_Hant',
    'JP': 'ja',
    'KR': 'ko',
    'FR': 'fr',
    'DE': 'de',
    'FI': 'fi',
    'RU': 'ru',
  };

  if (countryMap[country]) {
    detectedLang = countryMap[country];
  } else {
    // 5. 如果 IP 无法确定，退而求其次使用浏览器语言识别
    if (acceptLang.includes('zh-TW') || acceptLang.includes('zh-HK')) {
      detectedLang = 'zh_Hant';
    } else if (acceptLang.includes('zh')) {
      detectedLang = 'zh';
    } else {
      const primaryLang = acceptLang.split(',')[0].split('-')[0];
      const supported = ['en', 'ja', 'ko', 'fr', 'de', 'fi', 'ru'];
      if (supported.includes(primaryLang)) {
        detectedLang = primaryLang;
      }
    }
  }

  // 6. 将识别到的语言写入 Cookie，并重定向或继续
  const response = NextResponse.next();
  response.cookies.set('lang', detectedLang, {
    path: '/',
    maxAge: 60 * 60 * 24 * 30, // 有效期 30 天
    sameSite: 'lax',
  });

  return response;
}

// 仅在主路由和定价等页面运行，排除静态资源
export const config = {
  matcher: ['/', '/pricing', '/download', '/changelog', '/docs/:path*'],
};
