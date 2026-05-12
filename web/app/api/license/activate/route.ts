import { NextRequest, NextResponse } from 'next/server';
import { LicenseManager } from '../../../lib/license';

export const runtime = 'edge';

export async function POST(req: NextRequest) {
  try {
    const { key, machineId } = await req.json();

    if (!key || !machineId) {
      return NextResponse.json({ error: 'Missing key or machineId' }, { status: 400 });
    }

    // 1. 首先进行算法校验
    if (!(await LicenseManager.validateFormat(key))) {
      return NextResponse.json({ 
        success: false, 
        message: 'Invalid CD-Key format' 
      }, { status: 403 });
    }

    // 2. 进行激活（绑定机器码）
    // 在实际生产中，这里应该查询数据库，确认 Key 是否已被使用
    const activation = await LicenseManager.activate(key, machineId);

    return NextResponse.json(activation);
  } catch (error) {
    return NextResponse.json({ success: false, message: 'Server error' }, { status: 500 });
  }
}
