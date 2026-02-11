#!/bin/bash

# Font Vault Shopify - Quick Deployment Script
# This script helps you deploy to Railway in minutes

echo "🚀 Font Vault Shopify - Deployment Helper"
echo "=========================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit - Font Vault Shopify Custom Font Manager"
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    echo ""
    echo "📤 Would you like to create a GitHub repository? (y/n)"
    read -r create_repo
    
    if [ "$create_repo" = "y" ]; then
        echo "Creating GitHub repository..."
        gh repo create font-vault-shopify --public --source=. --push
        echo "✅ GitHub repository created and pushed"
    fi
else
    echo ""
    echo "⚠️  GitHub CLI not found. Please create a repo manually:"
    echo "   1. Go to https://github.com/new"
    echo "   2. Create repository: font-vault-shopify"
    echo "   3. Run: git remote add origin YOUR_REPO_URL"
    echo "   4. Run: git push -u origin main"
fi

echo ""
echo "📋 Next Steps:"
echo ""
echo "1️⃣  Deploy to Railway:"
echo "   • Go to https://railway.app"
echo "   • Click 'New Project'"
echo "   • Select 'Deploy from GitHub repo'"
echo "   • Choose 'font-vault-shopify'"
echo ""
echo "2️⃣  Add PostgreSQL Database:"
echo "   • In Railway project, click '+ New'"
echo "   • Select 'Database' → 'PostgreSQL'"
echo "   • DATABASE_URL will be set automatically"
echo ""
echo "3️⃣  Set Environment Variables in Railway:"
echo "   SHOPIFY_API_KEY=your_key"
echo "   SHOPIFY_API_SECRET=your_secret"
echo "   SCOPES=read_themes,write_themes,read_files,write_files"
echo "   SHOPIFY_APP_URL=https://your-app.up.railway.app"
echo "   NODE_ENV=production"
echo ""
echo "4️⃣  Update shopify.app.toml with your Railway URL"
echo ""
echo "5️⃣  Deploy app configuration:"
echo "   shopify app deploy"
echo ""
echo "6️⃣  Test your app:"
echo "   shopify app open"
echo ""
echo "📖 See DEPLOYMENT.md for detailed instructions"
echo ""
echo "✨ Good luck with your deployment!"
