# 🚀 Production Deployment Guide

## Pre-Deployment Checklist

### 1. Choose Your Hosting Platform

| Platform | Cost | Database | Recommended For |
|----------|------|----------|----------------|
| **Railway** | ~$5/mo | PostgreSQL included | Easiest setup |
| **Render** | Free tier available | PostgreSQL addon | Budget-friendly |
| **Fly.io** | ~$5/mo | Persistent SQLite | Performance |
| **Heroku** | ~$7/mo | Heroku Postgres | Enterprise-ready |

**Recommendation: Railway** (easiest for Shopify apps)

---

## Option 1: Deploy to Railway (Recommended)

### Step 1: Prepare Your Repository

```bash
cd font-vault-shopify-custom-font-manager
git init
git add .
git commit -m "Initial commit - Font Vault Shopify Custom Font Manager"

# Create GitHub repo and push
gh repo create font-vault-shopify --public --source=. --push
# OR manually create on github.com and:
git remote add origin https://github.com/YOUR_USERNAME/font-vault-shopify.git
git push -u origin main
```

### Step 2: Deploy to Railway

1. Go to [railway.app](https://railway.app)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your `font-vault-shopify` repository
5. Railway will auto-detect it's a Node.js app

### Step 3: Add PostgreSQL Database

1. In your Railway project, click **"+ New"**
2. Select **"Database" → "PostgreSQL"**
3. Railway will create a database and set `DATABASE_URL` automatically

### Step 4: Configure Environment Variables

In Railway dashboard, go to **Variables** tab and add:

```env
# Shopify Credentials (from Partner Dashboard)
SHOPIFY_API_KEY=your_api_key_here
SHOPIFY_API_SECRET=your_api_secret_here

# Scopes
SCOPES=read_themes,write_themes,read_files,write_files

# Railway provides DATABASE_URL automatically
# DATABASE_URL=postgresql://... (already set)

# App URL (Railway provides this, or use custom domain)
SHOPIFY_APP_URL=https://your-app.up.railway.app

# Node Environment
NODE_ENV=production
```

### Step 5: Update shopify.app.toml

Update your `shopify.app.toml` with production URL:

```toml
application_url = "https://your-app.up.railway.app"

[auth]
redirect_urls = [
  "https://your-app.up.railway.app/auth/callback",
  "https://your-app.up.railway.app/auth/shopify/callback",
  "https://your-app.up.railway.app/api/auth/callback"
]
```

### Step 6: Run Database Migration

Railway automatically runs `npm install` and `npm run build`.

Add to `package.json` scripts:

```json
"scripts": {
  "build": "remix vite:build && prisma generate",
  "start": "prisma migrate deploy && remix-serve ./build/server/index.js",
  "deploy": "npm run build"
}
```

Commit and push:
```bash
git add package.json shopify.app.toml
git commit -m "Configure for production deployment"
git push
```

Railway will auto-deploy!

### Step 7: Deploy App Configuration to Shopify

```bash
shopify app deploy
```

This pushes your `shopify.app.toml` configuration to Shopify.

---

## Option 2: Deploy to Render

### Step 1: Create Web Service

1. Go to [render.com](https://render.com)
2. Click **"New +" → "Web Service"**
3. Connect your GitHub repo
4. Configure:
   - **Name:** font-vault-shopify
   - **Environment:** Node
   - **Build Command:** `npm install && npm run build`
   - **Start Command:** `npm start`

### Step 2: Add PostgreSQL

1. Click **"New +" → "PostgreSQL"**
2. Name it `font-vault-db`
3. Copy the **Internal Database URL**

### Step 3: Environment Variables

Add in Render dashboard:

```env
SHOPIFY_API_KEY=your_key
SHOPIFY_API_SECRET=your_secret
SCOPES=read_themes,write_themes,read_files,write_files
DATABASE_URL=postgresql://... (from step 2)
SHOPIFY_APP_URL=https://font-vault-shopify.onrender.com
NODE_ENV=production
```

### Step 4: Deploy

Render auto-deploys on git push. Update `shopify.app.toml` with your Render URL and run:

```bash
shopify app deploy
```

---

## Option 3: Deploy to Fly.io

### Step 1: Install Fly CLI

```bash
curl -L https://fly.io/install.sh | sh
fly auth login
```

### Step 2: Initialize Fly App

```bash
cd font-vault-shopify-custom-font-manager
fly launch --no-deploy

# Choose app name: font-vault-shopify
# Choose region: closest to your target market
# Don't deploy yet
```

### Step 3: Configure fly.toml

Fly will generate `fly.toml`. Update it:

```toml
app = "font-vault-shopify"
primary_region = "sjc"

[build]
  [build.args]
    NODE_VERSION = "18"

[env]
  PORT = "8080"
  NODE_ENV = "production"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 512
```

### Step 4: Create Persistent Volume (for SQLite)

```bash
fly volumes create font_vault_data --region sjc --size 1
```

Update `fly.toml`:
```toml
[[mounts]]
  source = "font_vault_data"
  destination = "/data"
```

Set `DATABASE_URL` in `.env.production`:
```env
DATABASE_URL=file:/data/prod.db
```

### Step 5: Set Secrets

```bash
fly secrets set SHOPIFY_API_KEY=your_key
fly secrets set SHOPIFY_API_SECRET=your_secret
fly secrets set SCOPES=read_themes,write_themes,read_files,write_files
```

### Step 6: Deploy

```bash
fly deploy
```

Get your app URL:
```bash
fly info
# App URL: https://font-vault-shopify.fly.dev
```

Update `shopify.app.toml` and deploy config:
```bash
shopify app deploy
```

---

## Post-Deployment Steps

### 1. Test Your Live App

```bash
shopify app open
```

This opens your production app in a test store.

### 2. Verify Functionality

- [ ] Upload a font file
- [ ] Configure typography settings
- [ ] Apply to theme
- [ ] Check theme CSS injection
- [ ] Test font preview
- [ ] Verify dashboard stats

### 3. Monitor Logs

**Railway:** Click "View Logs" in dashboard  
**Render:** Go to "Logs" tab  
**Fly.io:** `fly logs`

### 4. Set Up Custom Domain (Optional)

**Railway:**
1. Go to Settings → Domains
2. Add custom domain
3. Update DNS CNAME record

**Render:**
1. Go to Settings → Custom Domain
2. Follow DNS instructions

**Fly.io:**
```bash
fly certs add yourdomain.com
```

---

## Shopify App Store Submission Requirements

### Required Pages

1. **Privacy Policy URL** — Host on your domain or use:
   - https://www.termsfeed.com/privacy-policy-generator/
   - https://www.freeprivacypolicy.com/

2. **Support URL** — Create a simple page:
   - Email: support@yourapp.com
   - Documentation link
   - FAQ section

3. **App Listing URL** — Your production app URL

### Required Assets

- [ ] **App Icon** — 1200x1200px PNG (square, no transparency)
- [ ] **Screenshots** — At least 3-5 screenshots of your app UI
  - Dashboard view
  - Font upload screen
  - Typography controls
  - Preview/settings

### Testing Checklist

- [ ] App installs successfully
- [ ] Fonts upload and appear in library
- [ ] Typography settings save correctly
- [ ] CSS injects into theme without errors
- [ ] App uninstalls cleanly (verify GDPR webhooks)
- [ ] No console errors in browser
- [ ] Mobile responsive (test on phone)

### Submission Process

1. Go to [Shopify Partner Dashboard](https://partners.shopify.com)
2. Select your app
3. Click **"App Store listing"**
4. Fill in:
   - App name: **Font Vault Shopify Custom Font Manager**
   - Tagline: *"Upload custom fonts and control typography across your entire store"*
   - Description: (from README)
   - Pricing: Free or set your plan
   - Privacy policy URL
   - Support URL
   - Screenshots
   - App icon
5. Click **"Submit for Review"**

**Review Time:** Usually 5-10 business days

---

## Monitoring & Maintenance

### 1. Error Tracking (Optional but Recommended)

Add Sentry for error tracking:

```bash
npm install @sentry/remix
```

Configure in `app/entry.server.tsx`:
```typescript
import * as Sentry from "@sentry/remix";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
});
```

### 2. Database Backups

**Railway:** Automatic daily backups included  
**Render:** Enable backups in dashboard  
**Fly.io:** Set up volume snapshots

### 3. Update Strategy

```bash
# Make changes locally
git add .
git commit -m "Feature: X"
git push

# Deploy updated config if needed
shopify app deploy
```

Railway/Render will auto-deploy on git push.

---

## Troubleshooting

### Issue: "App won't install"

**Check:**
- Redirect URLs in `shopify.app.toml` match production URL
- HTTPS is enabled
- App is deployed and accessible

**Fix:**
```bash
shopify app deploy
```

### Issue: "Database connection errors"

**Check:**
- `DATABASE_URL` environment variable is set
- Prisma migrations ran: `npx prisma migrate deploy`

**Fix on Railway:**
```bash
# In Railway dashboard, go to "Deploy" → "View Logs"
# Check if migrations ran
```

### Issue: "Fonts not appearing in theme"

**Check:**
- Typography settings are active (`isActive: true`)
- Theme ID is correct
- `assets/font-vault.css` exists in theme
- Link tag in `theme.liquid`

**Fix:**
Go to Settings page → Click "Regenerate & Re-inject CSS"

---

## Cost Estimates

| Hosting | Database | Monthly Cost | Free Tier |
|---------|----------|--------------|-----------|
| Railway | PostgreSQL | ~$5 | $5 credit |
| Render | PostgreSQL | ~$7 | Free (sleeps) |
| Fly.io | SQLite Volume | ~$3-5 | $5 credit |
| Heroku | Heroku Postgres | ~$7+ | ❌ |

**Recommended:** Railway — best developer experience for Shopify apps.

---

## Need Help?

- [Shopify App Review Guidelines](https://shopify.dev/docs/apps/store/review)
- [Railway Docs](https://docs.railway.app)
- [Render Docs](https://render.com/docs)
- [Fly.io Docs](https://fly.io/docs)

Good luck with your app submission! 🚀
