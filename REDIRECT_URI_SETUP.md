# Redirect URI Setup Guide

## What is a Redirect URI?

The Redirect URI is the URL that Epic will redirect to after the user completes authentication. For mobile apps, we use a **custom URL scheme** (like `mychartfhir://`) instead of a web URL.

## Why It Must Match Exactly

The Redirect URI must be **identical** in three places:
1. ✅ **Epic App Registration** (what you register in Epic's portal)
2. ✅ **Your App Code** (`epic_config.dart`)
3. ✅ **Platform Configuration** (Android manifest & iOS Info.plist)

If they don't match exactly, OAuth will fail with "Redirect URI mismatch" error.

## The Redirect URI We're Using

```
mychartfhir://oauth/callback
```

**Breaking it down:**
- `mychartfhir://` - Custom URL scheme (like `http://` but for apps)
- `oauth` - Host/path component
- `/callback` - Specific callback path

## Step-by-Step Setup

### Step 1: Register in Epic Portal

When registering your app at [https://fhir.epic.com/Developer/Apps](https://fhir.epic.com/Developer/Apps):

1. Find the **"Redirect URI"** field
2. Enter exactly: `mychartfhir://oauth/callback`
3. ⚠️ **No spaces, no typos, case-sensitive!**

**Screenshot location:** Usually in the "OAuth Settings" or "App Configuration" section

### Step 2: Verify in Your Code

**File:** `lib/core/config/epic_config.dart`

**Line 28** should have:
```dart
static const String redirectUri = 'mychartfhir://oauth/callback';
```

**Check:**
- ✅ No extra spaces
- ✅ Exact same text as Epic registration
- ✅ Single quotes around the string

### Step 3: Configure Android

**File:** `android/app/src/main/AndroidManifest.xml`

Add this inside your `<activity>` tag:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="mychartfhir"
        android:host="oauth" />
</intent-filter>
```

**What this does:**
- `android:scheme="mychartfhir"` - Matches the `mychartfhir://` part
- `android:host="oauth"` - Matches the `oauth` part
- The `/callback` path is handled automatically

### Step 4: Configure iOS

**File:** `ios/Runner/Info.plist`

Add this inside the root `<dict>` tag:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>mychartfhir</string>
        </array>
    </dict>
</array>
```

**What this does:**
- Registers `mychartfhir://` as a valid URL scheme
- iOS will route `mychartfhir://oauth/callback` to your app

## Verification Checklist

Before testing, verify all three match:

| Location | Should Be |
|----------|-----------|
| Epic Portal Registration | `mychartfhir://oauth/callback` |
| `epic_config.dart` line 28 | `'mychartfhir://oauth/callback'` |
| Android Manifest `android:scheme` | `mychartfhir` |
| Android Manifest `android:host` | `oauth` |
| iOS Info.plist `CFBundleURLSchemes` | `mychartfhir` |

## Common Mistakes to Avoid

### ❌ Wrong: Extra Spaces
```
mychartfhir://oauth/callback   ← extra space at end
```

### ❌ Wrong: Different Case
```
MyChartFHIR://oauth/callback   ← case mismatch
```

### ❌ Wrong: Missing Parts
```
mychartfhir://callback   ← missing "oauth"
```

### ❌ Wrong: Different in Epic vs Code
- Epic: `mychartfhir://oauth/callback`
- Code: `mychart://oauth/callback` ← different scheme!

### ✅ Correct: Exact Match Everywhere
```
mychartfhir://oauth/callback
```

## Testing the Redirect URI

### Test on Android

```bash
adb shell am start -W -a android.intent.action.VIEW -d "mychartfhir://oauth/callback?code=test&state=test" com.your.package.name
```

If your app opens, the deep link is working!

### Test on iOS

```bash
xcrun simctl openurl booted "mychartfhir://oauth/callback?code=test&state=test"
```

If your app opens, the deep link is working!

## Troubleshooting

### Error: "Redirect URI mismatch"

**Cause:** The redirect URI in Epic doesn't match your code.

**Solution:**
1. Check Epic portal - copy the exact redirect URI
2. Compare with `epic_config.dart` line 28
3. Ensure they match character-for-character
4. Re-register in Epic if needed

### Error: "Deep link not working"

**Cause:** Platform configuration missing or incorrect.

**Solution:**
1. Verify Android manifest has the intent filter
2. Verify iOS Info.plist has URL scheme
3. Rebuild app: `flutter clean && flutter run`
4. Test deep link manually (see testing above)

### Error: "App doesn't open from browser"

**Cause:** Deep link configuration incomplete.

**Solution:**
1. Double-check Android manifest syntax
2. Double-check iOS Info.plist syntax
3. Ensure app is installed on device
4. Try uninstalling and reinstalling app

## Quick Reference

**The Magic String:**
```
mychartfhir://oauth/callback
```

**Remember:**
- Use this **exact same string** in Epic portal
- Use this **exact same string** in `epic_config.dart`
- Configure platform files to recognize `mychartfhir://` scheme

## Still Having Issues?

1. **Double-check all three locations** match exactly
2. **Rebuild your app** after making changes
3. **Test deep linking** manually first
4. **Check app logs** for specific error messages
5. **Verify Epic registration** shows the correct redirect URI

## Example: Complete Setup

Here's what a complete setup looks like:

**Epic Portal:**
```
Redirect URI: mychartfhir://oauth/callback
```

**epic_config.dart:**
```dart
static const String redirectUri = 'mychartfhir://oauth/callback';
```

**Android Manifest:**
```xml
<data android:scheme="mychartfhir" android:host="oauth" />
```

**iOS Info.plist:**
```xml
<string>mychartfhir</string>
```

All pointing to the same redirect URI! ✅

