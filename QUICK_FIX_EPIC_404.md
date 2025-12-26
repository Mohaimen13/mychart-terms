# Quick Fix for Epic 404 Error

## The Problem

Epic returns 404 because the redirect URI isn't registered or doesn't match.

## Solution 1: Double-Check Epic Portal

1. **Go to Epic Portal:** https://fhir.epic.com/Developer/Apps
2. **Find your app** (Client ID: `9c11bf83-22a3-4731-9c8a-bca4ed974c45`)
3. **Check Redirect URI field:**
   - Should be: `http://localhost:3000/oauth/callback`
   - **NO trailing slash**
   - **Lowercase only**
   - **Exact match**

4. **Make sure you clicked SAVE/UPDATE button**
   - Some portals have a separate "Save" button
   - Wait 2-5 minutes after saving

## Solution 2: Try 127.0.0.1 Instead

If Epic doesn't accept `localhost`, try:

1. **In Epic Portal, change redirect URI to:**
   ```
   http://127.0.0.1:3000/oauth/callback
   ```

2. **Access your app using:**
   ```
   http://127.0.0.1:3000
   ```
   (instead of localhost)

3. **Save in Epic portal and wait 2 minutes**

## Solution 3: Use ngrok (Recommended for Testing)

This creates a public HTTPS URL for your localhost:

1. **Download ngrok:** https://ngrok.com/download
   - Or: `choco install ngrok` (if you have Chocolatey)

2. **Start ngrok:**
   ```powershell
   ngrok http 3000
   ```

3. **Copy the HTTPS URL** (looks like: `https://abc123.ngrok.io`)

4. **In Epic Portal, set redirect URI to:**
   ```
   https://your-ngrok-url.ngrok.io/oauth/callback
   ```
   (Replace `your-ngrok-url` with your actual ngrok URL)

5. **Update your app config** - I'll help you with this

## Solution 4: Check What's Actually Being Sent

1. **Open browser Developer Tools** (F12)
2. **Go to Network tab**
3. **Click "Login with Epic"**
4. **Look at the authorization URL**
5. **Check the `redirect_uri` parameter**
6. **Make sure it matches Epic portal EXACTLY**

## Most Likely Issue

**The redirect URI wasn't saved properly in Epic portal.**

### Double-Check:
- [ ] You're editing the CORRECT app (check Client ID matches)
- [ ] You clicked SAVE/UPDATE button
- [ ] You waited 2-5 minutes after saving
- [ ] The redirect URI has NO trailing slash
- [ ] The redirect URI is exactly: `http://localhost:3000/oauth/callback`

## Quick Test

1. Go to Epic portal
2. Check your app's redirect URI
3. Copy it exactly
4. Compare with what your app sends (check browser Network tab)
5. They must match EXACTLY

## Still Not Working?

Try ngrok - it's the most reliable way to test OAuth with localhost.

Let me know which solution you want to try!

