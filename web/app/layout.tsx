import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: "Zshrc Manager — Master Your macOS Terminal Environment",
  description: "The most intuitive macOS GUI to manage your terminal environment. One-click beautification, environment management, and cloud sync.",
  keywords: ["zsh", "macos", "terminal", "ohmyzsh", "powerlevel10k", "zshrc", "alias manager"],
  authors: [{ name: "Zshrc Manager Team" }],
  openGraph: {
    title: "Zshrc Manager — Master Your macOS Terminal Environment",
    description: "The most intuitive macOS GUI to manage your terminal environment.",
    url: "https://zshrc.app",
    siteName: "Zshrc Manager",
    images: [
      {
        url: "https://zshrc.app/og-image.png",
        width: 1200,
        height: 630,
      },
    ],
    locale: "en_US",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Zshrc Manager — Master Your macOS Terminal Environment",
    description: "The most intuitive macOS GUI to manage your terminal environment.",
    images: ["https://zshrc.app/og-image.png"],
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
