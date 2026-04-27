import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Zshrc Manager — Master Your macOS Terminal Environment",
  description: "The most intuitive macOS GUI to manage your terminal environment. One-click beautification, environment management, and cloud sync.",
  keywords: ["zsh", "macos", "terminal", "ohmyzsh", "powerlevel10k", "zshrc", "alias manager"],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <body>{children}</body>
    </html>
  );
}
