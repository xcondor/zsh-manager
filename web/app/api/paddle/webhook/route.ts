import { NextRequest, NextResponse } from 'next/server';
import { LicenseManager } from '../../../lib/license';
import { sendLicenseEmail } from '../../../lib/email';

export const runtime = 'edge';

/**
 * 校验 Paddle Webhook 签名
 */
async function verifySignature(request: NextRequest, rawBody: string): Promise<boolean> {
  const signatureHeader = request.headers.get('paddle-signature');
  const secret = process.env.PADDLE_WEBHOOK_SECRET;

  if (!signatureHeader || !secret) {
    console.error('[Paddle Webhook] Missing signature header or secret');
    return false;
  }

  // 1. 解析签名头 (格式: ts=1681234567;h1=abcdef...)
  const parts = signatureHeader.split(';');
  const tsPart = parts.find(p => p.startsWith('ts='));
  const h1Part = parts.find(p => p.startsWith('h1='));

  if (!tsPart || !h1Part) return false;

  const ts = tsPart.split('=')[1];
  const h1 = h1Part.split('=')[1];

  // 2. 校验时间戳 (防止重放攻击，允许 5 分钟误差)
  const timestamp = parseInt(ts);
  const now = Math.floor(Date.now() / 1000);
  if (Math.abs(now - timestamp) > 300) {
    console.error('[Paddle Webhook] Timestamp expired');
    return false;
  }

  // 3. 计算本地哈希
  // Paddle v2 签名规则: ts + "." + rawBody
  const signedPayload = `${ts}.${rawBody}`;
  
  const encoder = new TextEncoder();
  const keyData = encoder.encode(secret);
  const data = encoder.encode(signedPayload);

  const cryptoKey = await crypto.subtle.importKey(
    'raw',
    keyData,
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );

  const signatureBuffer = await crypto.subtle.sign('HMAC', cryptoKey, data);
  const calculatedHash = Array.from(new Uint8Array(signatureBuffer))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');

  return calculatedHash === h1;
}

/**
 * Paddle Webhook 处理器
 */
export async function POST(req: NextRequest) {
  try {
    const body = await req.text();
    
    // 1. 安全校验：验证签名
    if (process.env.NODE_ENV === 'production') {
      const isValid = await verifySignature(req, body);
      if (!isValid) {
        return NextResponse.json({ error: 'Invalid signature' }, { status: 401 });
      }
    }

    const payload = JSON.parse(body);
    const eventType = payload.event_type;
    
    console.log(`[Paddle Webhook] Received event: ${eventType}`);

    // 2. 处理支付成功事件 (transaction.completed)
    if (eventType === 'transaction.completed') {
      const customerEmail = payload.data?.customer?.email;
      
      if (!customerEmail) {
        console.error('[Paddle Webhook Error] Customer email not found');
        return NextResponse.json({ success: false, error: 'Email missing' }, { status: 400 });
      }

      // 生成新的 CD-Key
      const newKey = await LicenseManager.generateKey();
      
      console.log(`[Success] Payment received from ${customerEmail}. Generated Key: ${newKey}`);

      // 3. 自动发送邮件给用户
      const emailResult = await sendLicenseEmail(customerEmail, newKey);
      
      return NextResponse.json({ 
        success: true, 
        message: emailResult.success ? 'License sent' : 'License generated, email failed'
      });
    }

    return NextResponse.json({ success: true, message: 'Event ignored' });
  } catch (error) {
    console.error('[Paddle Webhook Error]', error);
    return NextResponse.json({ success: false }, { status: 500 });
  }
}
