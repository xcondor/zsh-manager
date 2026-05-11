'use client';

import React from 'react';
import { useLanguage } from '../i18n';

export default function ContactUs() {
  const { t, mounted } = useLanguage();
  if (!mounted) return null;

  const tc = t.contact_page || {};

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
          <a href="/" className="text-sm font-medium text-secondary hover:text-white transition-colors">
            {t.common?.backToSite || "Back to Site"}
          </a>
        </div>
      </nav>

      <div className="container max-w-4xl py-24">
        <div className="glass rounded-3xl p-8 lg:p-16">
          <h1 className="text-4xl lg:text-5xl font-black mb-12">{tc.title || "Contact Us"}</h1>
          
          <div className="prose prose-invert max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-bold mb-4">{tc.get_in_touch || "Get in Touch"}</h2>
              <p className="text-secondary leading-relaxed">
                {tc.get_in_touch_desc || "Whether you have a question about features, pricing, need technical support, or anything else, our team is ready to answer all your questions."}
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">{tc.email_support || "Email Support"}</h2>
              <div className="text-secondary leading-relaxed">
                <p>{tc.email_support_desc || "For general inquiries and technical support, please email us directly at:"}</p>
                <br />
                <a href="mailto:support@maczsh.com" className="text-accent-cyan hover:underline font-bold text-xl">support@maczsh.com</a>
                <br /><br />
                <p className="text-sm opacity-60 italic">{tc.response_time || "We aim to respond to all inquiries within 24 hours during regular business days."}</p>
              </div>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">{tc.business || "Business & Partnerships"}</h2>
              <p className="text-secondary leading-relaxed">
                {tc.business_desc || "For media inquiries, enterprise licensing, or partnership opportunities, please reach out to us at:"}
                <br /><br />
                <a href="mailto:hello@maczsh.com" className="text-accent-cyan hover:underline font-bold">hello@maczsh.com</a>
              </p>
            </section>
          </div>
        </div>
      </div>
    </div>
  );
}
