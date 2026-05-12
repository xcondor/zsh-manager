import { NextRequest, NextResponse } from 'next/server';
import { LicenseManager } from '../../../lib/license';

export const runtime = 'edge';

/**
 * 生产环境下此接口必须增加身份验证 (Admin Auth)
 */
export async function POST(req: NextRequest) {
  try {
    const { count = 1, secret } = await req.json();

    // 简单的安全校验（建议在 .env 中设置 ADMIN_SECRET）
    if (secret !== process.env.ADMIN_SECRET && process.env.NODE_ENV === 'production') {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const keys = [];
    for (let i = 0; i < count; i++) {
      keys.push(await LicenseManager.generateKey());
    }

    return NextResponse.json({ 
      success: true, 
      keys,
      generatedAt: new Date().toISOString()
    });
  } catch (error) {
    return NextResponse.json({ success: false, message: 'Generation failed' }, { status: 500 });
  }
}
