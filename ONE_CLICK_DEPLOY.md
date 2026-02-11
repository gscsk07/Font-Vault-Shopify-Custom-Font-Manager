# 🚀 One-Click Deployment

## Deploy to Railway (Fastest Option)

### Method 1: Deploy Button (Easiest)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/shopify-font-vault)

**Click the button above** and Railway will:
- ✅ Create a new project
- ✅ Clone this repository
- ✅ Provision PostgreSQL database
- ✅ Deploy your app automatically

**After clicking:**

1. **Sign in to Railway** (free $5 credit)
2. **Configure environment variables** in the form:
   ```
   SHOPIFY_API_KEY=<your_key>
   SHOPIFY_API_SECRET=<your_secret>
   SCOPES=read_themes,write_themes,read_files,write_files
   ```
3. Click **"Deploy"** - Railway builds and deploys automatically
4. **Copy your app URL** from Railway dashboard (Settings → Domains)
5. **Update Shopify configuration**:
   ```bash
   # Update shopify.app.toml with your Railway URL
   # Then run:
   shopify app deploy
   ```

---

## Method 2: Railway CLI (Power Users)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Link to PostgreSQL
railway add postgresql

# Set environment variables
railway variables set SHOPIFY_API_KEY="your_key_here"
railway variables set SHOPIFY_API_SECRET="your_secret_here"
railway variables set SCOPES="read_themes,write_themes,read_files,write_files"
railway variables set NODE_ENV="production"

# Deploy
railway up

# Get your URL
railway domain
```

---

## Method 3: GitHub + Railway Dashboard

This is the most common method and takes about 10 minutes:

### Step 1: Push to GitHub (3 minutes)

```bash
# Clone the zip and navigate
cd font-vault-shopify-custom-font-manager

# Initialize git
git init
git add .
git commit -m "Initial commit"

# Option A: Using GitHub CLI (fastest)
gh repo create font-vault-shopify --public --source=. --push

# Option B: Manual
# 1. Create repo at github.com/new
# 2. Name it: font-vault-shopify
# 3. Run:
git remote add origin https://github.com/YOUR_USERNAME/font-vault-shopify.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy on Railway (5 minutes)

1. **Go to** https://railway.app (sign in with GitHub)

2. **Click "New Project"**

3. **Select "Deploy from GitHub repo"**

4. **Choose** your `font-vault-shopify` repository

5. **Railway auto-deploys** (takes ~2 minutes)

6. **Add Database:**
   - Click "+ New" in your project
   - Select "Database" → "PostgreSQL"
   - DATABASE_URL is set automatically ✨

7. **Set Environment Variables:**
   - Click your service
   - Go to "Variables" tab
   - Click "New Variable" and add:
   
   ```
   SHOPIFY_API_KEY
   Value: <from Partner Dashboard>
   
   SHOPIFY_API_SECRET
   Value: <from Partner Dashboard>
   
   SCOPES
   Value: read_themes,write_themes,read_files,write_files
   
   NODE_ENV
   Value: production
   ```

8. **Get Your App URL:**
   - Click "Settings" → "Domains"
   - Copy the `*.up.railway.app` URL
   - Or click "Generate Domain" if none exists

### Step 3: Configure Shopify (2 minutes)

```bash
# Open shopify.app.toml
# Replace YOUR_APP_URL with your Railway URL

# Example:
application_url = "https://font-vault-shopify-production.up.railway.app"

[auth]
redirect_urls = [
  "https://font-vault-shopify-production.up.railway.app/auth/callback",
  "https://font-vault-shopify-production.up.railway.app/auth/shopify/callback",
  "https://font-vault-shopify-production.up.railway.app/api/auth/callback"
]

# Save and deploy configuration
shopify app deploy
```

### Step 4: Test Your App 🎉

```bash
shopify app open
```

Your app opens in a development store - test uploading fonts!

---

## Get Your Shopify Credentials

You need these to fill in the environment variables:

1. **Go to** [Shopify Partner Dashboard](https://partners.shopify.com)
2. **Select** "Apps" from left sidebar
3. **Click** your app name (or create new app)
4. **Go to** "App credentials" section
5. **Copy:**
   - Client ID → This is your `SHOPIFY_API_KEY`
   - Client secret → This is your `SHOPIFY_API_SECRET`

---

## Alternative: Deploy to Render (Free Tier)

If you want a free option (with some limitations):

1. **Go to** https://render.com
2. **Click "New +"** → "Web Service"
3. **Connect** your GitHub repository
4. **Configure:**
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`
5. **Add PostgreSQL:**
   - Click "New +" → "PostgreSQL"
   - Copy Internal Database URL
6. **Set Environment Variables** in Render dashboard
7. **Deploy**

**Note:** Render free tier sleeps after 15 minutes of inactivity.

---

## Alternative: Deploy to Fly.io (Global Edge)

For the lowest latency worldwide:

```bash
# Install Fly CLI
curl -L https://fly.io/install.sh | sh

# Authenticate
fly auth login

# Launch app (don't deploy yet)
fly launch --no-deploy

# Create volume for database
fly volumes create font_vault_data --size 1

# Set secrets
fly secrets set SHOPIFY_API_KEY="your_key"
fly secrets set SHOPIFY_API_SECRET="your_secret"
fly secrets set SCOPES="read_themes,write_themes,read_files,write_files"

# Deploy
fly deploy

# Get your URL
fly info
```

---

## Troubleshooting

### "I don't have a Shopify Partner account"

1. Go to https://partners.shopify.com/signup
2. Sign up (it's free)
3. Create a development store
4. Create an app

### "I don't have a GitHub account"

1. Go to https://github.com/join
2. Sign up (it's free)
3. Come back to these instructions

### "Railway says my build failed"

Check the logs in Railway dashboard. Common issues:
- Missing environment variables
- Database not connected
- Wrong Node version (we need 18+)

### "App won't install in Shopify"

Make sure:
1. You updated `shopify.app.toml` with correct URLs
2. You ran `shopify app deploy`
3. Your app is actually running (check Railway logs)
4. HTTPS is enabled (Railway does this automatically)

---

## Costs

**Railway:**
- First $5 free (lasts ~1 month)
- Then ~$5/month for app + database
- $0.25/GB data transfer (usually <$1/month)

**Render:**
- Free tier available (sleeps after inactivity)
- Paid: $7/month web service + $7/month database

**Fly.io:**
- First $5 free credit
- ~$3-5/month for small app
- Good for multiple regions

---

## Still Need Help?

If you're stuck at any step:

1. **Check the logs** in your hosting dashboard
2. **Review** QUICK_START.md for detailed steps
3. **Ask** in Shopify Community: https://community.shopify.com
4. **Email** Railway support: team@railway.app (they're very responsive!)

---

## Success Checklist

Once deployed, verify:

- [ ] App URL loads (shows "Font Vault" login)
- [ ] Can install in development store
- [ ] Dashboard loads after installation
- [ ] Can upload a font file
- [ ] Font appears in library
- [ ] Can configure typography
- [ ] CSS injects into theme
- [ ] Font appears on storefront

✨ **If all checked, you're ready for App Store submission!**
