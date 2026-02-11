# 🚀 Quick Start: Deploy in 15 Minutes

This guide will get your Font Vault app deployed to production as fast as possible using Railway (the easiest option).

## Prerequisites (5 minutes)

1. **GitHub Account** - [Sign up](https://github.com/join) if you don't have one
2. **Railway Account** - [Sign up with GitHub](https://railway.app) (free $5 credit)
3. **Shopify Partner Account** - [Sign up](https://partners.shopify.com/signup)
4. **Node.js 18+** - [Download](https://nodejs.org/)
5. **Shopify CLI** - Install: `npm install -g @shopify/cli`

## Step-by-Step Deployment (10 minutes)

### 1. Push Code to GitHub (2 minutes)

```bash
# Navigate to your app directory
cd font-vault-shopify-custom-font-manager

# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit"

# Create GitHub repo using GitHub CLI
gh repo create font-vault-shopify --public --source=. --push

# OR create manually:
# 1. Go to github.com/new
# 2. Name: font-vault-shopify
# 3. Create repository
# 4. Follow instructions to push code
```

### 2. Deploy to Railway (3 minutes)

1. **Go to Railway**: https://railway.app
2. **Click "New Project"**
3. **Select "Deploy from GitHub repo"**
4. **Choose `font-vault-shopify`** repository
5. **Railway auto-detects Node.js** and starts deploying

✅ **First deployment will take ~2-3 minutes**

### 3. Add Database (1 minute)

1. **In your Railway project**, click **"+ New"**
2. **Select "Database" → "PostgreSQL"**
3. **Railway automatically sets `DATABASE_URL`** ✨

### 4. Configure Environment Variables (2 minutes)

In Railway dashboard, go to **Variables** tab:

```
SHOPIFY_API_KEY=<from Partner Dashboard>
SHOPIFY_API_SECRET=<from Partner Dashboard>
SCOPES=read_themes,write_themes,read_files,write_files
SHOPIFY_APP_URL=<your Railway URL>
NODE_ENV=production
```

**Get your Railway URL**: Click "Settings" → "Domains" → Copy the `*.up.railway.app` URL

**Get Shopify credentials**:
1. Go to [Partner Dashboard](https://partners.shopify.com)
2. Apps → Your App → App credentials
3. Copy Client ID (API Key) and Client Secret

Click **"Deploy"** to restart with new variables.

### 5. Update App Configuration (2 minutes)

```bash
# Open shopify.app.toml
nano shopify.app.toml

# Update these lines with your Railway URL:
application_url = "https://YOUR-APP.up.railway.app"

[auth]
redirect_urls = [
  "https://YOUR-APP.up.railway.app/auth/callback",
  "https://YOUR-APP.up.railway.app/auth/shopify/callback",
  "https://YOUR-APP.up.railway.app/api/auth/callback"
]

# Save and deploy
shopify app deploy
```

### 6. Test Your App! 🎉

```bash
shopify app open
```

This opens your production app in a development store.

**Test checklist:**
- [ ] App loads without errors
- [ ] Upload a font file
- [ ] Configure typography
- [ ] Apply to theme
- [ ] Check your store - font should be applied!

---

## 🎯 You're Done! What's Next?

### Option A: Start Using Immediately
Your app is live and functional. Use it in your own stores or share with friends.

### Option B: Submit to App Store (1-2 hours prep)

Follow **APP_STORE_SUBMISSION.md** for:
- Creating required pages (privacy policy, support)
- Taking screenshots
- Writing app description
- Submitting for review

### Option C: Add Custom Domain (Optional)

**In Railway:**
1. Settings → Domains
2. Click "Add Domain"
3. Enter your domain (e.g., `fonts.yourapp.com`)
4. Update DNS with provided CNAME record
5. Update `shopify.app.toml` with new domain
6. Run `shopify app deploy`

---

## 🆘 Troubleshooting

### "App won't install"
**Fix:** Make sure redirect URLs in `shopify.app.toml` match your Railway URL exactly. Then run `shopify app deploy`.

### "Database connection error"
**Fix:** Check that PostgreSQL database is running in Railway. DATABASE_URL should be set automatically.

### "Fonts not appearing"
**Fix:** Go to Settings page in app → Click "Regenerate & Re-inject CSS"

### "Railway deployment failed"
**Fix:** Check Railway logs. Usually a missing environment variable. Make sure all required vars are set.

---

## 💰 Costs

**Railway**: Free tier includes $5 credit (~1 month free), then ~$5/month  
**Domain** (optional): ~$12/year from Namecheap/Google Domains

---

## 📚 Additional Resources

- **Full Deployment Guide**: See `DEPLOYMENT.md`
- **App Store Submission**: See `APP_STORE_SUBMISSION.md`
- **Railway Docs**: https://docs.railway.app
- **Shopify App Docs**: https://shopify.dev/docs/apps

---

## ✨ Pro Tips

1. **Set up error monitoring** with [Sentry](https://sentry.io) (free tier available)
2. **Use Railway's Preview Deployments** for testing changes before production
3. **Enable automatic backups** in Railway database settings
4. **Monitor costs** in Railway dashboard (set spending alerts)
5. **Join Shopify Partners Community** for support and advice

---

**Need Help?** 
- Railway Support: https://railway.app/help
- Shopify Partners: partners@shopify.com
- Community: https://community.shopify.com

---

🎊 **Congratulations on deploying your Shopify app!**
