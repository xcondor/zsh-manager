import { NextResponse } from 'next/server';

export const runtime = 'edge';

export async function POST(request: Request) {
  try {
    const data = await request.json();
    const { message, contact, version, platform } = data;

    if (!message) {
      return NextResponse.json({ error: 'Message is required' }, { status: 400 });
    }

    const feedbackEntry = {
      id: Date.now().toString(),
      timestamp: new Date().toISOString(),
      message,
      contact: contact || 'Anonymous',
      version: version || 'Unknown',
      platform: platform || 'macOS',
    };

    // Use Cloudflare KV for storage
    // Ensure you have a KV namespace bound to 'FEEDBACK_KV'
    const FEEDBACK_KV = (process.env as any).FEEDBACK_KV;

    if (FEEDBACK_KV) {
      // Store in KV: Key is timestamp/id, value is the entry
      // We also maintain a list of keys to simulate a "message book"
      await FEEDBACK_KV.put(`feedback:${feedbackEntry.id}`, JSON.stringify(feedbackEntry));
      
      // Update the index list (optional, but helpful for GET)
      const existingListJson = await FEEDBACK_KV.get('feedback_list');
      let feedbackList = existingListJson ? JSON.parse(existingListJson) : [];
      feedbackList.push(feedbackEntry);
      
      // Keep only last 1000 messages to avoid KV size limits
      if (feedbackList.length > 1000) feedbackList.shift();
      
      await FEEDBACK_KV.put('feedback_list', JSON.stringify(feedbackList));
    } else {
      console.warn('FEEDBACK_KV binding not found. Feedback not persisted.');
    }

    return NextResponse.json({ success: true, id: feedbackEntry.id });
  } catch (error) {
    console.error('Feedback submission error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function GET() {
  try {
    const FEEDBACK_KV = (process.env as any).FEEDBACK_KV;
    if (FEEDBACK_KV) {
      const feedbackListJson = await FEEDBACK_KV.get('feedback_list');
      return NextResponse.json(feedbackListJson ? JSON.parse(feedbackListJson) : []);
    }
    return NextResponse.json({ error: 'Storage not configured' }, { status: 500 });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch feedback' }, { status: 500 });
  }
}
