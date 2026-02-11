# 🎥 Deployment Walkthrough Script

This is a step-by-step guide you can follow like a video tutorial.

---

## ⏱️ Total Time: 15 Minutes

**What you'll need:**
- Computer with internet
- Credit card for Railway (free $5 credit, no charge initially)
- 15 minutes of focused time

---

## 📍 Part 1: Get Your Shopify Credentials (5 minutes)

### Step 1.1: Access Partner Dashboard

1. Open browser
2. Go to: **https://partners.shopify.com**
3. Click **"Log in"** (or sign up if you don't have account)
4. Sign in with your credentials

### Step 1.2: Create or Find Your App

**If you already created an app:**
1. Click **"Apps"** in left sidebar
2. Click your app name
3. **Skip to Step 1.3**

**If you need to create an app:**
1. Click **"Apps"** in left sidebar
2. Click **"Create app"** button
3. Select **"Create app manually"**
4. Fill in:
   - App name: `Font Vault Test` (you can change later)
   - App URL: `https://temporary.com` (we'll update this)
5. Click **"Create app"**

### Step 1.3: Copy Your Credentials

1. You're now on your app's page
2. Look for **"Client credentials"** section (might need to scroll)
3. Click **"Show"** next to "Client secret"
4. Open a text editor (Notepad, TextEdit, etc.)
5. Copy and paste:
   ```
   SHOPIFY_API_KEY: [paste Client ID here]
   SHOPIFY_API_SECRET: [paste Client secret here]
   ```
6. **Keep this window open** - you'll need these soon!

---

## 📍 Part 2: Set Up GitHub (3 minutes)

### Step 2.1: Extract the App Files

1. **Find** the zip file you downloaded: `font-vault-shopify-custom-font-manager-PRODUCTION.zip`
2. **Right-click** → Extract All (or double-click on Mac)
3. **Open Terminal/Command Prompt**:
   - Mac: Applications → Utilities → Terminal
   - Windows: Press Win+R, type `cmd`, press Enter
4. **Navigate** to the extracted folder:
   ```bash
   cd path/to/font-vault-shopify-custom-font-manager
   ```
   (Tip: Type `cd ` then drag folder into terminal window)

### Step 2.2: Initialize Git

```bash
# Initialize repository
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - Font Vault Shopify"
```

### Step 2.3: Push to GitHub

**Option A - With GitHub CLI (if installed):**
```bash
gh repo create font-vault-shopify --public --source=. --push
```

**Option B - Manual way:**

1. Go to **https://github.com/new**
2. Repository name: `font-vault-shopify`
3. Public or Private: **Public** (easier)
4. Click **"Create repository"**
5. Copy the commands shown (should look like):
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/font-vault-shopify.git
   git branch -M main
   git push -u origin main
   ```
6. Paste into terminal, press Enter
7. Wait for upload to complete (might ask for GitHub login)

✅ **Checkpoint:** Your code is now on GitHub!

---

## 📍 Part 3: Deploy to Railway (5 minutes)

### Step 3.1: Create Railway Account

1. Go to **https://railway.app**
2. Click **"Login"** → **"Login with GitHub"**
3. Authorize Railway to access your GitHub account
4. Complete signup (free $5 credit, no card required initially)

### Step 3.2: Create New Project

1. You're on Railway dashboard
2. Click **"New Project"** (big purple button)
3. Select **"Deploy from GitHub repo"**
4. You'll see a list of your repositories
5. Click **"font-vault-shopify"**
6. Railway starts deploying automatically!

🕐 **Wait 2-3 minutes for initial deploy**

You'll see:
- ⚙️ Building...
- 📦 Deploying...
- ✅ Success! (hopefully)

### Step 3.3: Add PostgreSQL Database

1. In your Railway project view
2. Click **"+ New"** button (top right)
3. Select **"Database"**
4. Click **"Add PostgreSQL"**
5. Railway creates database and links it automatically
6. You'll see `DATABASE_URL` variable appear

✅ **Checkpoint:** Your app and database are running!

### Step 3.4: Configure Environment Variables

1. Click on your **app service** (should say "font-vault-shopify-custom-font-manager")
2. Go to **"Variables"** tab
3. Click **"+ New Variable"**

**Add these one by one:**

**Variable 1:**
- Key: `SHOPIFY_API_KEY`
- Value: [paste from Step 1.3]

**Variable 2:**
- Key: `SHOPIFY_API_SECRET`
- Value: [paste from Step 1.3]

**Variable 3:**
- Key: `SCOPES`
- Value: `read_themes,write_themes,read_files,write_files`

**Variable 4:**
- Key: `NODE_ENV`
- Value: `production`

4. Railway **automatically redeploys** with new variables

### Step 3.5: Get Your App URL

1. Stay on your app service page
2. Click **"Settings"** tab
3. Scroll to **"Domains"** section
4. You'll see a URL like: `font-vault-shopify-production.up.railway.app`
5. **Copy this URL** - you need it for next step!

If no URL appears:
- Click **"Generate Domain"**
- Copy the generated URL

---

## 📍 Part 4: Configure Shopify (2 minutes)

### Step 4.1: Update Configuration File

1. **Open** the extracted folder in a code editor (VS Code, Sublime, or even Notepad)
2. **Find and open:** `shopify.app.toml`
3. **Find this line** (around line 5):
   ```toml
   application_url = "https://YOUR_APP_URL.com"
   ```
4. **Replace with your Railway URL:**
   ```toml
   application_url = "https://font-vault-shopify-production.up.railway.app"
   ```
5. **Find the [auth] section** (around line 20):
   ```toml
   [auth]
   redirect_urls = [
     "https://YOUR_APP_URL.com/auth/callback",
     "https://YOUR_APP_URL.com/auth/shopify/callback",
     "https://YOUR_APP_URL.com/api/auth/callback"
   ]
   ```
6. **Replace all three URLs** with your Railway URL
7. **Save the file**

### Step 4.2: Deploy Configuration to Shopify

Back in terminal:

```bash
# Make sure you're in the app directory
cd path/to/font-vault-shopify-custom-font-manager

# Deploy configuration
shopify app deploy
```

Follow prompts:
- Select your app
- Confirm deployment
- Wait for confirmation

✅ **Checkpoint:** Shopify now knows your app's location!

---

## 📍 Part 5: Test Your App! (2 minutes)

### Step 5.1: Install in Development Store

```bash
shopify app open
```

This command:
1. Opens your browser
2. Shows list of development stores
3. You select one
4. App installs automatically
5. Opens app in Shopify admin

### Step 5.2: Quick Test

Once app opens:

1. ✅ **Dashboard loads?** You should see "Font Vault Shopify Custom Font Manager"
2. ✅ **Click "Font Library"** - page loads?
3. ✅ **Try uploading a font** - works?
4. ✅ **Go to Typography** - settings save?

**If all worked:** 🎉 **CONGRATULATIONS! Your app is deployed!**

**If something failed:** See Troubleshooting below

---

## 🆘 Troubleshooting

### Problem: "App won't open" or "Can't install"

**Check:**
1. Railway app is running (green checkmark in Railway dashboard)
2. All environment variables are set correctly
3. URLs in `shopify.app.toml` match your Railway URL exactly
4. You ran `shopify app deploy` after updating the file

**Fix:**
```bash
# Update shopify.app.toml again
# Then redeploy
shopify app deploy
```

### Problem: "Database connection error"

**Check:** 
- PostgreSQL database exists in Railway
- DATABASE_URL variable is set

**Fix:**
- Go to Railway → "+ New" → "Add PostgreSQL"
- Railway auto-links it

### Problem: "Build failed" in Railway

**Check Railway logs:**
1. Click your app service
2. Click "Deployments" tab  
3. Click the failed deployment
4. Read error message

**Common causes:**
- Missing dependencies (Railway should auto-install)
- Wrong Node version (we need 18+)
- Out of memory (upgrade Railway plan if needed)

### Problem: "Shopify CLI not found"

**Install it:**
```bash
npm install -g @shopify/cli
```

Then try again.

---

## 📊 What You've Accomplished

✅ Set up Shopify Partner account and app  
✅ Pushed code to GitHub  
✅ Deployed to Railway with PostgreSQL  
✅ Configured all environment variables  
✅ Connected app to Shopify  
✅ Tested in development store  

**Your app is now LIVE in production!**

---

## 🎯 Next Steps

### Immediate:
1. **Test thoroughly** - upload multiple fonts, try all features
2. **Invite beta testers** - other merchants to try it
3. **Monitor Railway logs** - watch for errors

### Within a week:
1. **Create required pages:**
   - Privacy policy (use TermsFeed.com generator)
   - Support page (simple email contact is fine)
2. **Take screenshots** of your app (3-5 high quality images)
3. **Design app icon** (1200x1200 PNG)

### App Store submission:
1. Follow **APP_STORE_SUBMISSION.md** checklist
2. Submit to Shopify App Store
3. Wait 5-10 days for review
4. Launch! 🚀

---

## 💰 Ongoing Costs

**Railway:**
- $5 free credit (lasts ~1 month)
- After: ~$5-7/month
- Monitor usage in Railway dashboard

**Optional:**
- Custom domain: ~$12/year
- Error monitoring (Sentry): Free tier available
- Email service (SendGrid): Free tier available

---

## 🎊 Congratulations!

You've successfully deployed a production Shopify app!

**Share your success:**
- Tweet about it (tag @Shopify, @Railway)
- Post in Shopify Community
- Tell other developers

**Need help later?**
- Railway docs: https://docs.railway.app
- Shopify docs: https://shopify.dev
- Community: https://community.shopify.com

---

**Pro tip:** Bookmark your Railway dashboard URL for easy access to logs and settings!
