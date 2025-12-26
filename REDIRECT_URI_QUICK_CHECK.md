# Redirect URI Quick Check

## ⚡ 30-Second Verification

### 1. Check Epic Portal
- [ ] Go to [https://fhir.epic.com/Developer/Apps](https://fhir.epic.com/Developer/Apps)
- [ ] Find your app's Redirect URI
- [ ] Should be: `mychartfhir://oauth/callback`

### 2. Check Your Code
- [ ] Open `lib/core/config/epic_config.dart`
- [ ] Line 28 should be: `'mychartfhir://oauth/callback'`
- [ ] Copy both and compare - they must match exactly!

### 3. Check Platform Configs

**Android:**
- [ ] Open `android/app/src/main/AndroidManifest.xml`
- [ ] Find `<data android:scheme="mychartfhir" android:host="oauth" />`
- [ ] Should be inside an `<intent-filter>`

**iOS:**
- [ ] Open `ios/Runner/Info.plist`
- [ ] Find `<string>mychartfhir</string>`
- [ ] Should be inside `CFBundleURLSchemes` array

## ✅ All Match? You're Good!

If all three match exactly, your redirect URI is configured correctly.

## ❌ Don't Match? 

See `REDIRECT_URI_SETUP.md` for detailed help.

