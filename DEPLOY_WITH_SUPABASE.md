# 🚀 Deploy with Supabase (100% Free)

This guide shows you how to deploy Font Vault using **Supabase's free tier** for the database and **Railway free tier** for hosting.

**Total Cost: $0 for first month** (Railway gives $5 credit)

---

## Why Supabase?

✅ **500MB PostgreSQL database** - More than enough for this app  
✅ **Unlimited API requests** on free tier  
✅ **50,000 monthly active users** limit (way more than you'll need starting out)  
✅ **No credit card required** to start  
✅ **Automatic backups** included  
✅ **Never sleeps** (unlike Render free tier)

---

## Prerequisites (5 minutes setup)

1. **Supabase Account** - Sign up at https://supabase.com (free, no credit card)
2. **Railway Account** - Sign up at https://railway.app (free $5 credit)
3. **GitHub Account** - https://github.com
4. **Shopify Partner Account** - https://partners.shopify.com

---

## Step 1: Set Up Supabase Database (5 minutes)

### 1.1 Create Supabase Project

1. Go to https://supabase.com
2. Click **"Start your project"**
3. Sign in with GitHub
4. Click **"New project"**

### 1.2 Configure Project

Fill in the form:
- **Name:** `font-vault-db`
- **Database Password:** Generate a strong password (click the generate button)
- **Region:** Choose closest to your users (e.g., US West, EU Central)
- **Pricing Plan:** **Free** (selected by default)

Click **"Create new project"**

⏱️ Wait 2-3 minutes while Supabase provisions your database

### 1.3 Get Database Connection String

1. Once project is ready, click **"Project Settings"** (gear icon in sidebar)
2. Click **"Database"** in left menu
3. Scroll to **"Connection string"** section
4. Select **"URI"** tab
5. Copy the connection string - looks like:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
   ```
6. **Replace `[YOUR-PASSWORD]`** with the password you created in step 1.2
7. **Save this somewhere safe** - you'll need it soon!

### 1.4 Get Direct Connection (for Prisma)

Prisma needs a direct connection (not pooled):

1. In same **"Connection string"** section
2. Look for **"Connection pooling"** toggle
3. Copy the **Session mode** connection string
4. This looks like:
   ```
   postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-us-west-1.pooler.supabase.com:5432/postgres
   ```

**Save both connection strings:**
```
POOLED (for connection pooling): postgresql://postgres.xxxxx:...
DIRECT (for migrations): postgresql://postgres:...@db.xxxxx.supabase.co:5432/postgres
```

---

## Step 2: Push Code to GitHub (3 minutes)

```bash
# Navigate to extracted folder
cd font-vault-shopify-custom-font-manager

# Initialize git
git init
git add .
git commit -m "Initial commit - Font Vault with Supabase"

# Push to GitHub (using GitHub CLI)
gh repo create font-vault-shopify --public --source=. --push

# OR manually:
# 1. Create repo at github.com/new
# 2. Run these commands:
git remote add origin https://github.com/YOUR_USERNAME/font-vault-shopify.git
git branch -M main
git push -u origin main
```

---

## Step 3: Deploy to Railway (5 minutes)

### 3.1 Create Railway Project

1. Go to https://railway.app
2. Click **"Login with GitHub"**
3. Click **"New Project"**
4. Select **"Deploy from GitHub repo"**
5. Choose **`font-vault-shopify`**

Railway starts building immediately

### 3.2 Configure Environment Variables

1. Click your service in Railway
2. Go to **"Variables"** tab
3. Add these variables:

#### Required Variables:

**SHOPIFY_API_KEY**
```
your_client_id_from_partner_dashboard
```

**SHOPIFY_API_SECRET**
```
your_client_secret_from_partner_dashboard
```

**DATABASE_URL** (Pooled connection from Supabase)
```
postgresql://postgres.xxxxx:[YOUR-PASSWORD]@aws-0-us-west-1.pooler.supabase.com:5432/postgres
```

**DIRECT_URL** (Direct connection for migrations)
```
postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
```

**SCOPES**
```
read_themes,write_themes,read_files,write_files
```

**NODE_ENV**
```
production
```

### 3.3 Update Prisma Schema for Supabase

The schema needs a small tweak to use the direct connection for migrations:

1. In your local code, open `prisma/schema.prisma`
2. Update the datasource block:

```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")
}
```

3. Save and push to GitHub:
```bash
git add prisma/schema.prisma
git commit -m "Configure Prisma for Supabase"
git push
```

Railway will automatically redeploy with the updated schema.

### 3.4 Get Your Railway URL

1. In Railway, click **"Settings"** tab
2. Scroll to **"Domains"**
3. Click **"Generate Domain"** if none exists
4. Copy your URL (e.g., `font-vault-shopify-production.up.railway.app`)

---

## Step 4: Configure Shopify (2 minutes)

1. Open `shopify.app.toml` in a code editor
2. Update with your Railway URL:

```toml
application_url = "https://font-vault-shopify-production.up.railway.app"

[auth]
redirect_urls = [
  "https://font-vault-shopify-production.up.railway.app/auth/callback",
  "https://font-vault-shopify-production.up.railway.app/auth/shopify/callback",
  "https://font-vault-shopify-production.up.railway.app/api/auth/callback"
]
```

3. Deploy configuration:
```bash
shopify app deploy
```

---

## Step 5: Test Your App! 🎉

```bash
shopify app open
```

Your app should:
- ✅ Load without errors
- ✅ Allow font uploads
- ✅ Save typography settings to Supabase
- ✅ Inject CSS into themes

---

## 🎯 What You Get on Free Tier

### Supabase Free Tier:
- ✅ **500 MB database storage** (enough for ~10,000 fonts)
- ✅ **Unlimited API requests**
- ✅ **50,000 monthly active users**
- ✅ **1 GB file storage** (for any future file features)
- ✅ **Automatic backups** (7 days retention)
- ✅ **SSL connections** included
- ✅ **No credit card required**
- ✅ **Project stays active forever** (doesn't pause)

### Railway Free Tier:
- ✅ **$5 free credit** (lasts ~1 month with light usage)
- ✅ After credit: ~$5/month for app hosting
- ✅ **512 MB RAM, 1 vCPU**
- ✅ **100 GB bandwidth**

**Total first month: FREE**  
**After: ~$5/month** (just Railway hosting)

---

## 🔍 Verify Your Setup

### Check Supabase Connection:

1. Go to Supabase dashboard
2. Click **"Table Editor"** in sidebar
3. After your app runs migrations, you should see tables:
   - `Session`
   - `FontFile`
   - `TypographySettings`

If tables don't appear:
- Check Railway logs for migration errors
- Verify `DIRECT_URL` is set correctly
- Make sure Prisma schema was updated

### Check Railway Deployment:

1. Railway dashboard → Click "Deployments"
2. Latest deployment should show **"Success"**
3. Click deployment → View logs
4. Look for: `✓ Migrations deployed successfully`

---

## 🆘 Troubleshooting

### Problem: "P1001: Can't reach database server"

**Cause:** Connection string is wrong

**Fix:**
1. Go to Supabase project settings
2. Database → Connection string
3. Copy again carefully
4. Make sure you replaced `[YOUR-PASSWORD]` with actual password
5. Update in Railway variables

### Problem: "SSL connection error"

**Fix:** Add `?sslmode=require` to end of connection string:
```
postgresql://postgres:password@db.xxxxx.supabase.co:5432/postgres?sslmode=require
```

### Problem: "Migration failed"

**Fix:**
1. Make sure `DIRECT_URL` is set (not pooled URL)
2. Check Supabase project is running (not paused)
3. Try running migrations manually:
   - SSH into Railway: `railway run`
   - Run: `npx prisma migrate deploy`

### Problem: "Too many connections"

**Cause:** Using direct URL instead of pooled URL for `DATABASE_URL`

**Fix:**
- `DATABASE_URL` = Pooled connection (has `.pooler.supabase.com`)
- `DIRECT_URL` = Direct connection (has `db.xxxxx.supabase.co`)

---

## 📊 Monitor Your Usage

### Supabase Dashboard:

1. Go to project dashboard
2. See database size, API requests, active users
3. Free tier limits are generous - you likely won't hit them

### Railway Dashboard:

1. See estimated monthly cost
2. Monitor memory/CPU usage
3. Set spending alerts if needed

---

## 🚀 Upgrade Paths (When You Grow)

### Supabase Pro ($25/month):
- 8 GB database
- 100 GB file storage
- 200,000 monthly active users
- Daily backups (30 days retention)

### Railway ($20/month):
- Shared vCPU → Dedicated vCPU
- 8 GB RAM
- Priority support

**But start free!** You won't need to upgrade for months.

---

## 💡 Pro Tips

1. **Enable Supabase Auth** (for future features):
   - Could add user authentication to your app
   - Email/password, OAuth, magic links

2. **Use Supabase Storage**:
   - Could store font files in Supabase instead of theme assets
   - Free 1 GB included

3. **Set up Supabase Edge Functions**:
   - Run serverless functions on Supabase
   - Could process fonts before upload

4. **Enable Point-in-Time Recovery**:
   - Available on Pro plan
   - Restore database to any point in time

---

## 🎓 Learning Resources

- **Supabase Docs:** https://supabase.com/docs
- **Railway Docs:** https://docs.railway.app
- **Prisma + Supabase:** https://www.prisma.io/docs/guides/database/supabase

---

## ✅ Success Checklist

After deployment:

- [ ] Supabase project created
- [ ] Database tables created (visible in Table Editor)
- [ ] Railway app deployed successfully
- [ ] Environment variables set correctly
- [ ] App installs in Shopify development store
- [ ] Can upload fonts
- [ ] Fonts save to Supabase (check Table Editor)
- [ ] Typography settings save
- [ ] CSS injects into theme

**All checked?** 🎉 **You're running on 100% free tier!**

---

## 🌟 Why This Setup Rocks

1. **Zero cost to start** - Perfect for testing and early users
2. **Scales easily** - Upgrade Supabase/Railway as you grow
3. **Professional infrastructure** - Same setup used by production apps
4. **No maintenance** - Supabase handles database updates
5. **Great developer experience** - Nice dashboards, good docs

---

**Questions?**
- Supabase Discord: https://discord.supabase.com
- Railway Discord: https://discord.gg/railway
- Shopify Community: https://community.shopify.com

Happy deploying! 🚀
