
/**
 * Zshrc Manager 授权算法核心库 (Edge Compatible)
 * 
 * 逻辑：
 * 1. License Key 格式：ZRC-XXXX-XXXX-XXXX-XXXX (20位)
 * 2. 校验逻辑：前12位为随机码，后8位为基于随机码+Secret的签名校验位
 */

const SECRET_SALT = process.env.LICENSE_SECRET || 'zshrc-manager-premium-salt-2024';

export class LicenseManager {
  /**
   * 生成一个新的 CD-Key
   */
  static async generateKey(): Promise<string> {
    const randomBytesArray = new Uint8Array(6);
    crypto.getRandomValues(randomBytesArray);
    const randomPart = Array.from(randomBytesArray)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .toUpperCase(); // 12 chars
      
    const signature = await this.calculateSignature(randomPart);
    return `ZRC-${randomPart.slice(0, 4)}-${randomPart.slice(4, 8)}-${randomPart.slice(8, 12)}-${signature}`;
  }

  /**
   * 计算签名位 (基于随机部分)
   */
  private static async calculateSignature(randomPart: string): Promise<string> {
    const encoder = new TextEncoder();
    const keyData = encoder.encode(SECRET_SALT);
    const data = encoder.encode(randomPart);
    
    const cryptoKey = await crypto.subtle.importKey(
      'raw',
      keyData,
      { name: 'HMAC', hash: 'SHA-256' },
      false,
      ['sign']
    );
    
    const signatureBuffer = await crypto.subtle.sign('HMAC', cryptoKey, data);
    const signatureArray = Array.from(new Uint8Array(signatureBuffer));
    return signatureArray
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .slice(0, 4)
      .toUpperCase();
  }

  /**
   * 验证 CD-Key 是否符合算法规范（离线第一层校验）
   */
  static async validateFormat(key: string): Promise<boolean> {
    const parts = key.split('-');
    if (parts.length !== 5 || parts[0] !== 'ZRC') return false;
    
    const randomPart = parts[1] + parts[2] + parts[3];
    const signature = parts[4];
    
    const calculated = await this.calculateSignature(randomPart);
    return calculated === signature;
  }

  /**
   * 在线激活逻辑：绑定机器 ID (Machine ID)
   */
  static async activate(key: string, machineId: string) {
    if (!(await this.validateFormat(key))) {
      throw new Error('INVALID_FORMAT');
    }
    
    const encoder = new TextEncoder();
    const keyData = encoder.encode(SECRET_SALT);
    const data = encoder.encode(`${key}:${machineId}`);
    
    const cryptoKey = await crypto.subtle.importKey(
      'raw',
      keyData,
      { name: 'HMAC', hash: 'SHA-256' },
      false,
      ['sign']
    );
    
    const signatureBuffer = await crypto.subtle.sign('HMAC', cryptoKey, data);
    const activationToken = Array.from(new Uint8Array(signatureBuffer))
      .map(b => b.toString(16).padStart(2, '0'))
      .join('');
      
    return {
      success: true,
      token: activationToken,
      licenseType: 'LIFETIME_PRO',
      activatedAt: new Date().toISOString()
    };
  }
}
