import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-inter",
});

// Note: For full SEO impact, page-specific metadata is used in individual page.tsx files
// using the generateMetadata function which consumes our translations.ts.
export const metadata: Metadata = {
  metadataBase: new URL("https://maczsh.com"),
  title: {
    default: "Zshrc Manager — Pro macOS Terminal Environment GUI",
    template: "%s | Zshrc Manager"
  },
  description: "Transform your macOS terminal with Zshrc Manager. The ultimate GUI for .zshrc optimization, alias management, environment detection, and cloud synchronization.",
  keywords: ["zsh", "macos", "terminal environment", "zshrc manager", "oh-my-zsh gui", "alias manager", "mac development tools", "terminal beautification", "zsh configuration"],
  authors: [{ name: "Zshrc Manager Team", url: "https://maczsh.com" }],
  creator: "Zshrc Manager",
  publisher: "Zshrc Manager",
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  openGraph: {
    title: "Zshrc Manager — Master Your macOS Terminal Environment",
    description: "The most intuitive macOS GUI to manage your terminal environment. One-click setup for Oh My Zsh, aliases, and more.",
    url: "https://maczsh.com",
    siteName: "Zshrc Manager",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "Zshrc Manager App Interface",
      },
    ],
    locale: "en_US",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Zshrc Manager — Pro macOS Terminal Environment GUI",
    description: "One-click beautification and management for your macOS terminal environment.",
    images: ["/og-image.png"],
    creator: "@zshrcmanager",
  },
  alternates: {
    canonical: "/",
    languages: {
      'en-US': '/en',
      'zh-CN': '/zh',
      'ja-JP': '/ja',
    },
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={`scroll-smooth ${inter.variable}`}>
      <body className="antialiased">{children}</body>
    </html>
  );
}
