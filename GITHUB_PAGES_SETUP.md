# GitHub Pages Setup Guide

## Quick Setup Steps

Follow these steps to create your Terms and Conditions page on GitHub Pages:

### Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **"+"** icon in the top right → **"New repository"**
3. Repository name: `mychart-terms` (or any name you prefer)
4. Description: "Terms and Conditions for MyChart FHIR App"
5. Make it **Public** (required for free GitHub Pages)
6. **DO NOT** initialize with README, .gitignore, or license
7. Click **"Create repository"**

### Step 2: Upload the HTML File

**Option A: Using GitHub Web Interface (Easiest)**

1. In your new repository, click **"uploading an existing file"**
2. Drag and drop the `terms.html` file
3. **Rename it to `index.html`** (this is important!)
4. Add commit message: "Add Terms and Conditions page"
5. Click **"Commit changes"**

**Option B: Using Git (If you have Git installed)**

```bash
# Navigate to your project folder
cd c:\mychart_fhir_app

# Initialize git (if not already done)
git init

# Add the remote repository (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/mychart-terms.git

# Copy terms.html to index.html
cp terms.html index.html

# Add and commit
git add index.html
git commit -m "Add Terms and Conditions page"

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Enable GitHub Pages

1. In your repository, go to **Settings** (top menu)
2. Scroll down to **"Pages"** in the left sidebar
3. Under **"Source"**, select:
   - Branch: **main** (or **master**)
   - Folder: **/ (root)**
4. Click **"Save"**

### Step 4: Get Your URL

GitHub will provide your URL. It will be:
```
https://YOUR-USERNAME.github.io/mychart-terms/
```

**Note:** It may take a few minutes for the page to be available.

### Step 5: Customize Before Going Live

**Before using the URL in Epic, update these in `index.html`:**

1. **Contact Information** (Section 12):
   - Replace `[YOUR-EMAIL@EXAMPLE.COM]` with your email
   - Replace `[YOUR-WEBSITE.COM]` with your website (if any)

2. **Governing Law** (Section 13):
   - Replace `[YOUR JURISDICTION]` with your location (e.g., "the State of California, United States")

3. **Last Updated Date**:
   - Update the date at the top of the page

### Step 6: Test Your URL

1. Visit your GitHub Pages URL
2. Verify it loads correctly
3. Test on mobile device (should be responsive)
4. Check that it uses HTTPS (secure)

### Step 7: Use in Epic Portal

Enter your GitHub Pages URL in Epic's registration form:
```
https://YOUR-USERNAME.github.io/mychart-terms/
```

## Troubleshooting

### Page Not Loading?
- Wait 5-10 minutes after enabling Pages (takes time to deploy)
- Make sure the file is named `index.html` (not `terms.html`)
- Verify the repository is Public
- Check Settings → Pages to ensure it's enabled

### Want to Update the Content?
1. Edit `index.html` in GitHub (click the file, then pencil icon)
2. Make your changes
3. Commit changes
4. Updates will be live in a few minutes

### Want a Custom Domain?
GitHub Pages supports custom domains. See GitHub's documentation for setup.

## File Structure

Your repository should look like:
```
mychart-terms/
└── index.html
```

That's it! Just one file.

## Security Note

✅ GitHub Pages automatically provides HTTPS  
✅ Your URL will be secure (required by Epic)  
✅ No additional SSL setup needed  

## Next Steps

1. ✅ Create repository
2. ✅ Upload `index.html` (rename from `terms.html`)
3. ✅ Enable GitHub Pages
4. ✅ Customize contact info
5. ✅ Test the URL
6. ✅ Use in Epic portal

Your Terms and Conditions page will be live and ready for Epic!

