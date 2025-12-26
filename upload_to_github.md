# Upload Terms Page to GitHub

## Quick Git Commands

If you have Git installed, run these commands in your project folder:

```bash
# Navigate to your project folder
cd c:\mychart_fhir_app

# Copy terms.html to index.html (GitHub Pages needs this name)
copy terms.html index.html

# Initialize git (if not already done)
git init

# Add the remote repository
git remote add origin https://github.com/Mohaimen13/mychart-terms.git

# Add the file
git add index.html

# Commit
git commit -m "Add Terms and Conditions page"

# Push to GitHub
git branch -M main
git push -u origin main
```

## After Uploading

1. Go to your repository: https://github.com/Mohaimen13/mychart-terms
2. Click **Settings** → **Pages** (left sidebar)
3. Under **Source**, select:
   - Branch: **main**
   - Folder: **/ (root)**
4. Click **Save**

## Your Final URL

After enabling Pages, your URL will be:
```
https://mohaimen13.github.io/mychart-terms/
```

Wait 2-5 minutes for it to be available, then test it!

