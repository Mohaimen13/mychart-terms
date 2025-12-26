# Epic FHIR App Setup Guide

This guide walks you through setting up your app with Epic's FHIR developer portal.

## Step 1: Register Your App in Epic

### 1.1 Access the Developer Portal
1. Go to [https://fhir.epic.com/Developer/Apps](https://fhir.epic.com/Developer/Apps)
2. Log in with your Epic account
3. Navigate to "My Apps" section

### 1.2 Create a New App
1. Click "Create New App" or "Register App"
2. Fill in the app registration form:

**Required Information:**
- **App Name**: `MyChart FHIR App` (or your preferred name)
- **App Type**: Select "Patient-Facing App"
- **Redirect URI**: `mychartfhir://oauth/callback`
  - ⚠️ **Important**: This must match exactly what's in your `epic_config.dart`
  - For mobile apps, use a custom URL scheme
  - 📖 **Need help?** See `REDIRECT_URI_SETUP.md` for detailed instructions
- **Can Register Dynamic Clients**: ❌ **NO** (leave unchecked)
  - This app uses a pre-registered client ID, not dynamic registration
- **Is Confidential Client**: ❌ **NO** (leave unchecked)
  - This is a **public client** (mobile app using PKCE)
  - Mobile apps cannot securely store client secrets
  - The app uses PKCE (Proof Key for Code Exchange) for security instead
- **Incoming APIs**: Select these FHIR resources:
  - ✅ **Patient** (for patient demographics)
  - ✅ **Observation** (for labs & vitals)
  - ✅ **MedicationRequest** (for medications)
  - ✅ **Appointment** (for appointments)
  - 📖 **Detailed guide**: See `EPIC_API_SELECTION.md`
- **Scopes**: Select the following scopes:
  - `patient/*.read` (or individual scopes)
  - `patient/Patient.read`
  - `patient/Observation.read`
  - `patient/MedicationRequest.read`
  - `patient/Appointment.read`
  - `offline_access` (for refresh tokens)

### 1.3 Save Your Client ID
After registration, Epic will provide you with:
- **Client ID**: Save this immediately (you'll need it for configuration)
- **Client Secret**: Usually not required for public mobile apps using PKCE

## Step 2: Configure Your App

### 2.1 Update Epic Configuration
1. Open `lib/core/config/epic_config.dart`
2. Replace `YOUR_CLIENT_ID_HERE` with your actual Client ID:

```dart
static const String clientId = 'your-actual-client-id-here';
```

### 2.2 Verify Redirect URI
Ensure the redirect URI in `epic_config.dart` matches what you registered:
```dart
static const String redirectUri = 'mychartfhir://oauth/callback';
```

### 2.3 Verify Scopes
Confirm the scopes match what you registered in Epic:
```dart
static const List<String> scopes = [
  'patient/*.read',
  'patient/Patient.read',
  'patient/Observation.read',
  'patient/MedicationRequest.read',
  'patient/Appointment.read',
  'offline_access',
];
```

## Step 3: Configure Deep Linking

### 3.1 Android Configuration
Follow the instructions in `ANDROID_DEEP_LINKING.md`:
- Add intent filter to `AndroidManifest.xml`
- Use scheme: `mychartfhir` and host: `oauth`

### 3.2 iOS Configuration
Follow the instructions in `IOS_DEEP_LINKING.md`:
- Add URL scheme to `Info.plist`
- Use scheme: `mychartfhir`

## Step 4: Test with Epic Sandbox

### 4.1 Access Sandbox
1. Go to [open.epic.com](https://open.epic.com)
2. Use the Epic Sandbox for testing
3. Test data is available for various patient scenarios

### 4.2 Test Authentication Flow
1. Run your app: `flutter run`
2. Tap "Login" button
3. You'll be redirected to Epic's authentication page
4. Use Epic Sandbox test credentials
5. After authentication, you'll be redirected back to your app

### 4.3 Verify Data Loading
- Check if patient information loads
- Verify labs, medications, and appointments appear
- Test error handling if data is unavailable

## Step 5: Common Configuration Issues

### Issue: "Invalid Client ID"
- **Solution**: Double-check your Client ID in `epic_config.dart`
- Ensure no extra spaces or characters

### Issue: "Redirect URI Mismatch"
- **Solution**: 
  - Verify redirect URI in Epic matches exactly: `mychartfhir://oauth/callback`
  - Check Android manifest and iOS Info.plist configuration
  - Ensure URL scheme is properly registered

### Issue: "Invalid Scope"
- **Solution**: 
  - Verify scopes in `epic_config.dart` match registered scopes
  - Some scopes may require additional approval

### Issue: Deep Link Not Working
- **Solution**:
  - Rebuild app after manifest/Info.plist changes
  - Test deep link manually (see testing guides)
  - Check logs for deep link errors

## Step 6: Production Deployment

### 6.1 Request Production Access
1. Contact Epic through their developer portal
2. Request production access for your app
3. Provide app details and use case
4. Epic will review and approve your request

### 6.2 Update Production Endpoints
When approved, update `epic_config.dart` with production endpoints:
```dart
// Production endpoints (provided by Epic)
static const String baseUrl = 'https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4';
```

### 6.3 Security Review
- Ensure all security best practices are followed
- Review Epic's security guidelines
- Complete any required security assessments

## Additional Resources

- **Epic FHIR Documentation**: [https://fhir.epic.com/](https://fhir.epic.com/)
- **OAuth 2.0 Tutorial**: Available in Epic developer portal
- **Patient-Facing Apps Guide**: Epic's specific guidelines for patient apps
- **Sandbox Test Data**: Information about available test patients

## Checklist

- [ ] Registered app in Epic developer portal
- [ ] Obtained Client ID
- [ ] Updated `epic_config.dart` with Client ID
- [ ] Verified redirect URI matches registration
- [ ] Configured Android deep linking
- [ ] Configured iOS deep linking
- [ ] Tested authentication flow in sandbox
- [ ] Verified data loading works
- [ ] Tested error handling
- [ ] Ready for production deployment (when applicable)

## Support

If you encounter issues:
1. Check Epic's troubleshooting documentation
2. Review error messages in app logs
3. Verify all configuration matches Epic registration
4. Contact Epic support through developer portal

