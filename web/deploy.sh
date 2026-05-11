#!/bin/bash

# Zshrc Manager Web - Cloudflare Pages One-Click Deploy Script

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Cloudflare Pages Deployment...${NC}"

# 1. Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
npm install --legacy-peer-deps

# 2. Build the project
echo -e "${YELLOW}🏗️  Building Next.js project...${NC}"
# We use @cloudflare/next-on-pages to build for Cloudflare
if ! npx -y @cloudflare/next-on-pages@latest; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

# 3. Check for KV namespace
echo -e "${YELLOW}🔍 Checking for Cloudflare KV namespace...${NC}"
# Try to create KV if it doesn't exist (this might fail if not logged in, but that's okay)
npx wrangler kv:namespace create FEEDBACK_KV 2>/dev/null

# 4. Deploy to Cloudflare Pages
echo -e "${YELLOW}☁️  Deploying to Cloudflare Pages...${NC}"
npx wrangler pages deploy .vercel/output/static --project-name zshrc-manager-web

echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${BLUE}🔗 Your site is being deployed to Cloudflare.${NC}"
echo -e "${YELLOW}Note: Make sure to bind the FEEDBACK_KV namespace in the Cloudflare Dashboard if you haven't already.${NC}"
