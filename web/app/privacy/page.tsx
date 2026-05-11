import React from 'react';

export default function PrivacyPolicy() {
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
          <h1 className="text-4xl lg:text-5xl font-black mb-12">Privacy Policy</h1>
          
          <div className="prose prose-invert max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-bold mb-4">1. Information We Collect</h2>
              <p className="text-secondary leading-relaxed">
                Zshrc Manager is designed with privacy in mind. Because our application is a native macOS tool, it operates locally on your machine. We do not collect, transmit, or store any of your personal shell configurations, environment variables, or alias data on our servers. All processing happens on your local device.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">2. iCloud Sync (Pro Version)</h2>
              <p className="text-secondary leading-relaxed">
                If you use the iCloud Sync feature, your configurations are securely synchronized using Apple's native CloudKit technology. This data is stored entirely within your personal iCloud account. We do not have access to this data, nor is it shared with any third-party services.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">3. Application Analytics</h2>
              <p className="text-secondary leading-relaxed">
                We may collect anonymous, non-personally identifiable usage statistics to help us improve the application (e.g., crash reports and basic feature usage). You can opt out of this telemetry at any time from the application's preferences panel.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">4. Payment Processing</h2>
              <p className="text-secondary leading-relaxed">
                When you purchase the permanent license, your payment is processed securely by our payment provider (e.g., Stripe or Lemon Squeezy). We do not store or process your credit card details on our servers.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">5. Contact Us</h2>
              <p className="text-secondary leading-relaxed">
                If you have any questions or concerns about this Privacy Policy, please contact our support team at support@maczsh.com.
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
