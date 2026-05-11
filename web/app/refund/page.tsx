import React from 'react';

export default function RefundPolicy() {
  return (
    <div className="bg-grid min-h-screen">
      <nav className="glass sticky top-0 z-50 w-full border-b border-white/5">
        <div className="container flex h-16 items-center justify-between">
          <div className="flex items-center gap-2">
            <a href="/" className="flex items-center gap-2">
              <div className="h-8 w-8 rounded-lg bg-white/10 flex items-center justify-center">
                <span className="text-lg font-bold text-gradient">Z</span>
              </div>
              <span className="text-xl font-bold tracking-tight">Zshrc Manager</span>
            </a>
          </div>
          <a href="/" className="text-sm font-medium text-secondary hover:text-white transition-colors">Back to Site</a>
        </div>
      </nav>

      <div className="container max-w-4xl py-24">
        <div className="glass rounded-3xl p-8 lg:p-16">
          <h1 className="text-4xl lg:text-5xl font-black mb-12">Refund Policy</h1>
          
          <div className="prose prose-invert max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-bold mb-4">1. 30-Day Money-Back Guarantee</h2>
              <p className="text-secondary leading-relaxed">
                Zshrc Manager is sold through our official merchant of record, Paddle.com. In accordance with Paddle's consumer policies and our absolute commitment to your satisfaction, we offer a hassle-free 30-day money-back guarantee. If you are not completely satisfied with your purchase for any reason, you may request a full refund within 30 days of the original purchase date.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">2. Eligibility criteria</h2>
              <p className="text-secondary leading-relaxed">
                To be eligible for a refund, your request must be submitted within exactly 30 days from the time of purchase. Refund requests made after this 30-day window will not be accepted. We do not require any specific justification for the refund, though your honest feedback is always highly appreciated to help us improve the product.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">3. How to Request a Refund</h2>
              <p className="text-secondary leading-relaxed">
                To initiate a refund, you can either:
              </p>
              <ul className="list-disc list-inside space-y-2 mt-4 text-secondary">
                <li>Reply directly to your original purchase receipt email from Paddle.com.</li>
                <li>Contact our support team directly at <strong className="text-white">support@maczsh.com</strong> with your order number.</li>
              </ul>
              <p className="text-secondary leading-relaxed mt-4">
                Once your request is received and your order number is verified, the refund will be processed promptly on our end.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">4. Processing Time</h2>
              <p className="text-secondary leading-relaxed">
                Once the refund is processed by Paddle, it typically takes 3-5 business days for the funds to appear back on your original payment method (e.g., Credit Card, PayPal, or Apple Pay), depending on your bank or credit card issuer's internal processing times.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">5. License Revocation</h2>
              <p className="text-secondary leading-relaxed">
                Please note that once a refund is successfully issued, your associated license key will be immediately deactivated. You will no longer have access to the premium features of Zshrc Manager and the app will revert to an unactivated state.
              </p>
            </section>
            
            <p className="text-sm text-secondary/60 pt-8 mt-12 border-t border-white/10">
              Last updated: May 2026
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
