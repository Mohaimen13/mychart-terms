# Testing Guide - MyChart FHIR App

## Prerequisites Check

Before testing, ensure you have:

✅ **Flutter SDK** installed (version >=3.0.0)  
✅ **Android Studio** or **Xcode** (for mobile development)  
✅ **Device or Emulator** ready  
✅ **Client ID configured** in `epic_config.dart` ✅ (Already done!)  
✅ **Epic Sandbox account** (for testing authentication)

## Step 1: Install Dependencies

Open terminal in your project folder and run:

```bash
cd c:\mychart_fhir_app
flutter pub get
```

This installs all required packages from `pubspec.yaml`.

## Step 2: Check Flutter Setup

Verify Flutter is working:

```bash
flutter doctor
```

Make sure you see:
- ✅ Flutter (channel stable)
- ✅ Android toolchain (if testing on Android)
- ✅ iOS toolchain (if testing on iOS)
- ✅ Connected device or emulator

## Step 3: Verify Configuration

Check that your Client ID is set:

**File:** `lib/core/config/epic_config.dart`  
**Line 24:** Should show: `9c11bf83-22a3-4731-9c8a-bca4ed974c45`

✅ Already configured!

## Step 4: Set Up Device/Emulator

### Option A: Physical Device

**Android:**
1. Enable Developer Options on your phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter devices` to verify connection

**iOS:**
1. Connect iPhone via USB
2. Trust the computer on your phone
3. Run: `flutter devices` to verify

### Option B: Emulator/Simulator

**Android Emulator:**
1. Open Android Studio
2. Tools → Device Manager
3. Create/Start an emulator

**iOS Simulator:**
1. Open Xcode
2. Xcode → Open Developer Tool → Simulator
3. Choose a device (iPhone 14, etc.)

## Step 5: Run the App

### For Android:

```bash
flutter run
```

Or specify device:
```bash
flutter run -d <device-id>
```

### For iOS:

```bash
flutter run
```

Or for specific simulator:
```bash
flutter run -d iPhone
```

## Step 6: Test Authentication Flow

### What You Should See:

1. **Login Screen** appears first
2. **"Login with Epic"** button (or similar)
3. Click the login button

### Expected Flow:

1. ✅ Browser opens with Epic authentication page
2. ✅ You see Epic's login form
3. ✅ Enter Epic Sandbox credentials
4. ✅ Grant permissions to the app
5. ✅ Browser redirects back to app
6. ✅ App shows Dashboard screen

### Testing with Epic Sandbox:

**Epic Sandbox Test Credentials:**
- You'll need to use Epic's sandbox test accounts
- Visit: [open.epic.com](https://open.epic.com) for sandbox access
- Use test patient accounts provided by Epic

## Step 7: Verify Features

After successful login, test:

### ✅ Dashboard
- Patient name displays
- Quick access cards visible
- No errors shown

### ✅ Labs & Vitals
- Tap "Labs & Vitals" card
- Should show lab results (if available)
- Should show vital signs (if available)

### ✅ Medications
- Tap "Medications" card
- Should show current medications (if available)

### ✅ Appointments
- Tap "Appointments" card
- Should show upcoming/past appointments (if available)

## Step 8: Test Deep Linking

Deep linking should work automatically, but you can test manually:

**Android:**
```bash
adb shell am start -a android.intent.action.VIEW -d "mychartfhir://oauth/callback?code=TEST&state=TEST"
```

**iOS:**
```bash
xcrun simctl openurl booted "mychartfhir://oauth/callback?code=TEST&state=TEST"
```

## Common Issues & Solutions

### Issue: "No devices found"

**Solution:**
```bash
flutter devices
# If empty, start an emulator or connect a device
```

### Issue: "Client ID not found" or Authentication fails

**Solution:**
1. Verify Client ID in `epic_config.dart`
2. Check Epic portal - ensure app is registered
3. Verify redirect URI matches: `mychartfhir://oauth/callback`

### Issue: Deep link not working

**Solution:**
1. **Android:** Check `AndroidManifest.xml` has intent filter
2. **iOS:** Check `Info.plist` has URL scheme
3. Rebuild app after manifest changes: `flutter clean && flutter run`

### Issue: "Unable to launch authorization URL"

**Solution:**
- Check internet connection
- Verify Epic endpoints are correct
- Check browser is available on device/emulator

### Issue: App crashes on startup

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

## Debug Mode

Run with verbose logging:

```bash
flutter run -v
```

Check console for:
- Authentication flow logs
- API call logs
- Error messages

## Testing Checklist

- [ ] App launches without errors
- [ ] Login screen appears
- [ ] Login button opens Epic authentication
- [ ] Can authenticate with Epic Sandbox
- [ ] Redirects back to app after authentication
- [ ] Dashboard loads after login
- [ ] Patient information displays
- [ ] Can navigate to Labs screen
- [ ] Can navigate to Medications screen
- [ ] Can navigate to Appointments screen
- [ ] Logout works
- [ ] Deep linking works (OAuth callback)

## Next Steps After Testing

Once basic testing works:

1. ✅ Test with different Epic Sandbox patients
2. ✅ Test error handling (no internet, invalid credentials)
3. ✅ Test token refresh (wait for token expiry)
4. ✅ Test logout and re-login
5. ✅ Test on different devices/emulators
6. ✅ Test Arabic language support (if implemented)

## Getting Help

If you encounter issues:

1. Check `flutter doctor` output
2. Review console logs (`flutter run -v`)
3. Verify Epic portal configuration
4. Check `EPIC_SETUP_GUIDE.md` for setup issues
5. Review error messages in app

## Quick Commands Reference

```bash
# Install dependencies
flutter pub get

# Check setup
flutter doctor

# List devices
flutter devices

# Run app
flutter run

# Run with verbose logging
flutter run -v

# Clean build
flutter clean

# Check for issues
flutter analyze
```

Happy Testing! 🚀

