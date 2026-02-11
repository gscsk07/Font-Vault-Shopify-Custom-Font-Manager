# 🔤 Font Vault Shopify Custom Font Manager

A production-ready Shopify app built with **Remix + Shopify CLI** that gives merchants full control over custom fonts and typography across their entire store theme.

---

## 🚀 Quick Links - Get Started Now!

| What You Want | Go Here | Time | Cost |
|---|---|---|---|
| **Deploy 100% FREE** 🎉 | [DEPLOY_WITH_SUPABASE.md](./DEPLOY_WITH_SUPABASE.md) | 15 min | $0 |
| **Deploy right now** | [ONE_CLICK_DEPLOY.md](./ONE_CLICK_DEPLOY.md) | 10 min | ~$5/mo |
| **Step-by-step video-style guide** | [DEPLOYMENT_WALKTHROUGH.md](./DEPLOYMENT_WALKTHROUGH.md) | 15 min | ~$5/mo |
| **Detailed deployment options** | [DEPLOYMENT.md](./DEPLOYMENT.md) | 30 min | Varies |
| **App Store submission** | [APP_STORE_SUBMISSION.md](./APP_STORE_SUBMISSION.md) | 2 hours | - |
| **Local development setup** | See below ⬇️ | 5 min | $0 |

**💡 Recommended:** Start with [DEPLOY_WITH_SUPABASE.md](./DEPLOY_WITH_SUPABASE.md) for 100% free deployment!

---

## ✨ Features

### 📁 Font Management
- Upload **`.woff2`, `.woff`, `.ttf`, `.otf`** font files
- Fonts stored as **Shopify theme assets** (CDN-delivered)
- Auto-detects font family name and weight from filename
- Organize fonts by family with multiple weights/styles per family
- Preview each font with sample text before applying

### 🎨 Typography Controls
| Control | Options |
|---|---|
| **Heading Font** | Any uploaded font, per-level size (H1–H6) |
| **Body Font** | Family, size, weight, line height, letter spacing, color |
| **Button Font** | Family, size, weight, spacing, text transform |
| **Navigation Font** | Family, size, weight, spacing, transform |
| **Line Height** | Fine-grained control per element type |
| **Letter Spacing** | CSS em-based spacing per element type |
| **Font Color** | Per-element hex color |
| **Text Transform** | None / Uppercase / Lowercase / Capitalize |
| **Custom CSS** | Raw CSS editor for advanced overrides |

### 🔌 Theme Integration
- Injects `assets/font-vault.css` into your active Shopify theme
- Adds stylesheet `<link>` into `layout/theme.liquid` automatically
- Uses `!important` selectors to reliably override theme defaults
- Works with any Shopify theme (Dawn, Debut, Prestige, etc.)
- Remove/deactivate with one click to restore theme defaults

---

## 🚀 Getting Started

### Prerequisites
- [Node.js 18+](https://nodejs.org/)
- [Shopify CLI](https://shopify.dev/docs/api/shopify-cli) — `npm install -g @shopify/cli @shopify/theme`
- A [Shopify Partner account](https://partners.shopify.com) with an app created
- A development store

### 1. Clone & Install

```bash
git clone <your-repo>
cd font-vault-shopify
npm install
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Fill in your `.env`:
```env
SHOPIFY_API_KEY="from_partner_dashboard"
SHOPIFY_API_SECRET="from_partner_dashboard"
SCOPES="read_themes,write_themes,read_files,write_files"
DATABASE_URL="file:./dev.db"
```

### 3. Set Up Database

```bash
npx prisma migrate dev --name init
npx prisma generate
```

### 4. Link App to Shopify

```bash
shopify app config link
```

### 5. Run Development Server

```bash
shopify app dev
```

This starts a local tunnel via Cloudflare and opens your app in a development store.

---

## 📋 shopify.app.toml Reference

```toml
name = "Font Vault - Custom Font Manager"
client_id = "YOUR_CLIENT_ID"
embedded = true

[access_scopes]
scopes = "read_themes,write_themes,read_files,write_files"

[webhooks]
api_version = "2025-01"

  [[webhooks.subscriptions]]
  topics = ["app/uninstalled"]
  uri = "/webhooks"

  [[webhooks.subscriptions]]
  compliance_topics = ["customers/redact", "customers/data_request", "shop/redact"]
  uri = "/webhooks/compliance"
```

### Required API Scopes

| Scope | Purpose |
|---|---|
| `read_themes` | List available themes |
| `write_themes` | Upload CSS and font assets to theme |
| `read_files` | Read `theme.liquid` to inject stylesheet link |
| `write_files` | Modify `theme.liquid` to add Font Vault link tag |

---

## 🏗 Architecture

```
font-vault-shopify-custom-font-manager/
├── app/
│   ├── shopify.server.ts      # Shopify auth + API setup
│   ├── root.tsx               # App shell
│   ├── lib/
│   │   └── font.server.ts     # Core logic: CSS generation, theme injection
│   └── routes/
│       ├── app.tsx            # Authenticated layout with NavMenu
│       ├── app._index.tsx     # Dashboard
│       ├── app.fonts.tsx      # Font library (upload/manage/preview)
│       ├── app.typography.tsx # Typography controls
│       ├── app.settings.tsx   # Settings & theme management
│       ├── auth.$.tsx         # OAuth callback handler
│       └── webhooks.tsx       # Webhook handler (GDPR + uninstall)
├── prisma/
│   └── schema.prisma          # FontFile + TypographySettings models
├── shopify.app.toml           # Shopify CLI config
└── .env                       # Secrets (not committed)
```

### Data Flow

```
Merchant uploads font
        ↓
Font stored as Shopify theme asset (assets/font-name.woff2)
        ↓
Font metadata saved to local SQLite (FontFile model)
        ↓
Merchant configures typography settings
        ↓
CSS generated with @font-face + selectors
        ↓
CSS uploaded as assets/font-vault.css
        ↓
<link> tag injected into layout/theme.liquid
        ↓
Shopify CDN serves fonts globally
```

---

## 🎯 Generated CSS Example

```css
@font-face {
  font-family: "Playfair Display";
  src: url("https://cdn.shopify.com/...playfair-display-700.woff2") format("woff2");
  font-weight: 700;
  font-style: normal;
  font-display: swap;
}

h1, h2, h3, h4, h5, h6 {
  font-family: "Playfair Display", sans-serif !important;
  font-weight: 700 !important;
  line-height: 1.2 !important;
  letter-spacing: -0.02em !important;
}

body, p, span, li, a {
  font-family: "Inter", sans-serif !important;
  font-size: 1rem !important;
  line-height: 1.6 !important;
}

button, .btn, input[type="submit"] {
  font-family: "Montserrat", sans-serif !important;
  text-transform: uppercase !important;
  letter-spacing: 0.1em !important;
}
```

---

## 🚢 Deploying to App Store

### 1. Deploy Configuration

```bash
shopify app deploy
```

### 2. Set Up Production Database

Replace SQLite with PostgreSQL for production:
```env
DATABASE_URL="postgresql://user:pass@host:5432/font_vault"
```

```bash
npx prisma migrate deploy
```

### 3. Hosting Options

| Platform | Notes |
|---|---|
| **Railway** | One-click Node.js deploy, managed Postgres |
| **Render** | Free tier available, auto-deploy from GitHub |
| **Fly.io** | Edge deployment, SQLite persistent volumes |
| **Heroku** | Classic choice, Heroku Postgres addon |

### 4. App Store Listing Requirements
- App must be embedded (`embedded = true` in TOML)
- GDPR webhooks required (included ✅)
- App uninstall webhook required (included ✅)
- Privacy policy URL required
- At least 3 screenshots of the app UI

---

## 🚀 Production Deployment

### Quick Deploy to Railway (15 minutes)

The fastest way to get your app live. See **[QUICK_START.md](./QUICK_START.md)** for step-by-step guide.

```bash
# 1. Push to GitHub
git init && git add . && git commit -m "Initial commit"
gh repo create font-vault-shopify --public --source=. --push

# 2. Deploy to Railway (via dashboard)
# 3. Add PostgreSQL database (via dashboard)
# 4. Set environment variables (via dashboard)
# 5. Deploy configuration
shopify app deploy
```

### Deployment Options

See **[DEPLOYMENT.md](./DEPLOYMENT.md)** for detailed guides:
- **Railway** (recommended) - One-click deploy with auto-provisioned database
- **Render** - Free tier available, great for testing
- **Fly.io** - Global edge deployment with SQLite
- **Docker** - Flexible deployment to any platform

### App Store Submission

Ready to launch publicly? See **[APP_STORE_SUBMISSION.md](./APP_STORE_SUBMISSION.md)** for:
- Complete submission checklist
- Required assets (screenshots, icons)
- Privacy policy requirements
- Testing guidelines
- Post-submission tips

---

## 🔮 Roadmap / Future Features

- [ ] Google Fonts integration (browse + import directly)
- [ ] Adobe Fonts (Typekit) integration
- [ ] Font pairing suggestions via AI
- [ ] Multi-theme support (apply different fonts to dev/staging themes)
- [ ] Font performance analytics (load time impact)
- [ ] Variable font support (OpenType font-variation-settings)
- [ ] Import/export typography presets
- [ ] Font subsetting for performance optimization
- [ ] Per-page typography overrides via metafields
- [ ] Shopify Theme Editor integration

---

## 🛠 Development Tips

### Swapping Font in One Click

To change all heading/body/button fonts in a single operation, use the **Quick Font Swap** sidebar in Typography settings.

### Testing Without Real Fonts

Use free fonts from Google Fonts (download WOFF2 versions):
- Headings: Playfair Display, Cormorant Garamond
- Body: Lato, Source Sans Pro
- Buttons: Montserrat, Raleway

### Debugging CSS Injection

Check your theme assets in Shopify Admin → Online Store → Themes → Edit Code → Assets → `font-vault.css`

---

## 📄 License

MIT — feel free to fork and customize.
