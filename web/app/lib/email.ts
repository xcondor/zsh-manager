
/**
 * 发送激活码邮件 (使用 Resend API)
 */
export async function sendLicenseEmail(to: string, key: string) {
  const apiKey = process.env.RESEND_API_KEY;
  const from = process.env.EMAIL_FROM || 'onboarding@resend.dev';

  if (!apiKey) {
    console.error('[Email Error] RESEND_API_KEY is not set');
    return { success: false, error: 'API Key missing' };
  }

  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      from,
      to: [to],
      subject: 'Your Zshrc Manager Pro License Key',
      html: `
        <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 10px;">
          <h2 style="color: #00D8C0;">Thank you for your purchase!</h2>
          <p>Your Zshrc Manager Pro license is ready to use.</p>
          
          <div style="background: #f9f9f9; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center;">
            <p style="font-size: 12px; color: #666; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 10px;">Your CD-Key</p>
            <code style="font-size: 24px; font-weight: bold; color: #333; letter-spacing: 2px;">${key}</code>
          </div>

          <h3 style="font-size: 16px; color: #333;">How to activate:</h3>
          <ol style="color: #555; line-height: 1.6;">
            <li>Open Zshrc Manager on your Mac.</li>
            <li>Go to <strong>Settings</strong> > <strong>License</strong>.</li>
            <li>Copy and paste the CD-Key above.</li>
            <li>Click <strong>Activate</strong>.</li>
          </ol>

          <p style="margin-top: 30px; font-size: 14px; color: #999;">
            If you have any questions, just reply to this email. <br/>
            Happy coding!
          </p>
        </div>
      `,
    }),
  });

  const data = await res.json();
  
  if (res.ok) {
    console.log(`[Email Success] Sent to ${to}. ID: ${data.id}`);
    return { success: true, id: data.id };
  } else {
    console.error('[Email Error]', data);
    return { success: false, error: data };
  }
}
