import React from 'react';

export default function TermsOfService() {
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
          <h1 className="text-4xl lg:text-5xl font-black mb-12">Terms of Service</h1>
          
          <div className="prose prose-invert max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-bold mb-4">1. Acceptance of Terms</h2>
              <p className="text-secondary leading-relaxed">
                By downloading, installing, or using Zshrc Manager ("the Software"), you agree to be bound by these Terms of Service. If you do not agree to these terms, do not use the Software.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">2. License Grant</h2>
              <p className="text-secondary leading-relaxed">
                We grant you a personal, non-exclusive, non-transferable, limited license to use the Software on your macOS devices. The Software is provided as a permanent, one-time purchase with no recurring subscription fees.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">3. Restrictions</h2>
              <p className="text-secondary leading-relaxed">
                You may not: (a) modify, reverse engineer, decompile, or disassemble the Software; (b) distribute, rent, lease, or sublicense the Software; (c) remove or alter any proprietary notices or labels on the Software.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">4. Updates and Support</h2>
              <p className="text-secondary leading-relaxed">
                Your permanent license includes access to minor and major version updates as determined by our development roadmap, along with priority email support.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">5. Disclaimer of Warranties</h2>
              <p className="text-secondary leading-relaxed">
                The Software is provided "as is" and "as available", without warranty of any kind. We do not guarantee that the Software will meet your specific requirements or be uninterrupted, secure, or error-free.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">6. Limitation of Liability</h2>
              <p className="text-secondary leading-relaxed">
                In no event shall Zshrc Manager or its developers be liable for any indirect, incidental, special, or consequential damages, including loss of data or business interruption, arising out of the use or inability to use the Software.
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
