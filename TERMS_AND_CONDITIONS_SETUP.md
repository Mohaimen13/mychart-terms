# Terms and Conditions URL Setup Guide

## For Epic Portal Registration

Epic requires a **secure HTTPS URL** where users can review Terms and Conditions before authorizing access to their health data.

## Field in Epic Portal

**Label:** "Terms and Conditions Secure URL"  
**Format:** `https://appTerms.yourSite.com`  
**Requirement:** Must be a publicly accessible HTTPS URL

## Requirements

✅ **HTTPS Required** - Must use secure connection (SSL/TLS)  
✅ **Publicly Accessible** - No login or authentication required  
✅ **Mobile-Friendly** - Should be readable on mobile devices  
✅ **Patient-Friendly** - Clear, plain language  
✅ **Content Requirements** - Should cover:
   - Data access and use
   - Privacy and security measures
   - User responsibilities
   - Limitations and disclaimers

## Quick Setup Options

### Option 1: GitHub Pages (Recommended for Quick Setup)

**Steps:**
1. Create a new GitHub repository (e.g., `mychart-terms`)
2. Create an `index.html` file with your Terms content
3. Go to repository Settings → Pages
4. Select branch (usually `main`) and save
5. Your URL will be: `https://[username].github.io/mychart-terms/`

**Example HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms and Conditions - MyChart FHIR App</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; }
        h1 { color: #333; }
        h2 { color: #555; margin-top: 30px; }
    </style>
</head>
<body>
    <h1>Terms and Conditions</h1>
    <p><strong>Last Updated: [DATE]</strong></p>
    
    <!-- Paste content from TERMS_AND_CONDITIONS_CONTENT.md here -->
    
</body>
</html>
```

### Option 2: Your Own Domain

If you have a website:
1. Create a page at: `https://yourdomain.com/terms`
2. Ensure SSL certificate is valid
3. Make it publicly accessible
4. Use this URL: `https://yourdomain.com/terms`

### Option 3: Static Site Hosting Services

**Netlify (Free):**
1. Create account at netlify.com
2. Create new site from Git or drag & drop
3. Deploy your HTML file
4. URL: `https://your-site-name.netlify.app/terms`

**Vercel (Free):**
1. Create account at vercel.com
2. Import your project
3. Deploy
4. URL: `https://your-site-name.vercel.app/terms`

**Firebase Hosting (Free):**
1. Create Firebase project
2. Use Firebase CLI to deploy
3. URL: `https://your-project.web.app/terms`

## What to Include in Your Terms

Based on Epic's requirements and best practices, your Terms should cover:

1. **Service Description** - What the app does
2. **Data Access** - What health data is accessed and why
3. **Privacy & Security** - How data is protected
4. **User Responsibilities** - What users must do
5. **Limitations** - Disclaimers about medical advice, data accuracy
6. **Contact Information** - How to reach you

See `TERMS_AND_CONDITIONS_CONTENT.md` for a complete template.

## Testing Your URL

Before submitting to Epic, verify:

✅ URL loads in browser  
✅ Uses HTTPS (not HTTP)  
✅ No login required  
✅ Mobile-friendly (responsive)  
✅ Content is complete and professional  
✅ Contact information is included  

## Example URLs (Format Only)

```
https://mychartfhir.app/terms
https://yourcompany.com/mychart/terms-and-conditions
https://yourusername.github.io/mychart-terms
https://mychart-terms.netlify.app
```

## For Epic Portal

When filling out the Epic registration form:

**Field:** "Terms and Conditions Secure URL"  
**Enter:** Your HTTPS URL (e.g., `https://yourdomain.com/terms`)

## Important Notes

⚠️ **Epic will verify the URL** - Make sure it's live and accessible  
⚠️ **HTTPS is mandatory** - HTTP URLs will be rejected  
⚠️ **Keep it updated** - Update Terms if your app's data usage changes  
⚠️ **Legal review recommended** - Consider having a lawyer review for production use  

## Next Steps

1. ✅ Choose hosting option (GitHub Pages recommended for quick setup)
2. ✅ Customize the template in `TERMS_AND_CONDITIONS_CONTENT.md`
3. ✅ Create HTML page and deploy
4. ✅ Test the URL in browser and on mobile
5. ✅ Enter URL in Epic portal registration form

## Support

If you need help:
- See `TERMS_AND_CONDITIONS_CONTENT.md` for content template
- GitHub Pages documentation: https://pages.github.com/
- Epic may provide guidance on their requirements

