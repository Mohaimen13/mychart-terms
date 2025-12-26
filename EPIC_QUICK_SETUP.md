# Epic FHIR Quick Setup Checklist

## ✅ Step-by-Step Setup

### 1. Register Your App (5 minutes)

Go to: [https://fhir.epic.com/Developer/Apps](https://fhir.epic.com/Developer/Apps)

**When registering, you'll need:**
- App Name: `MyChart FHIR App`
- App Type: **Patient-Facing App**
- Redirect URI: `mychartfhir://oauth/callback` ⚠️ **Copy this exactly**
- Scopes: Select these checkboxes:
  - ✅ `patient/*.read` 
  - ✅ `patient/Patient.read`
  - ✅ `patient/Observation.read`
  - ✅ `patient/MedicationRequest.read`
  - ✅ `patient/Appointment.read`
  - ✅ `offline_access`

**After registration, Epic will give you:**
- 📋 **Client ID** - Copy this immediately!

### 2. Update Your App Configuration (2 minutes)

1. Open: `lib/core/config/epic_config.dart`
2. Find this line:
   ```dart
   static const String clientId = 'YOUR_CLIENT_ID_HERE';
   ```
3. Replace `YOUR_CLIENT_ID_HERE` with your actual Client ID from Epic
4. Save the file

### 3. Configure Deep Linking (5 minutes)

#### Android:
- Open: `android/app/src/main/AndroidManifest.xml`
- Add the intent filter (see `ANDROID_DEEP_LINKING.md`)

#### iOS:
- Open: `ios/Runner/Info.plist`
- Add URL scheme (see `IOS_DEEP_LINKING.md`)

### 4. Test Your App (5 minutes)

```bash
flutter pub get
flutter run
```

1. Tap "Login" button
2. You'll see Epic's login page
3. Use Epic Sandbox test credentials
4. After login, you'll be redirected back to your app
5. You should see the dashboard!

## 🔍 Verification Checklist

Before testing, verify:

- [ ] Client ID is set in `epic_config.dart`
- [ ] Redirect URI in code matches Epic registration: `mychartfhir://oauth/callback`
- [ ] Scopes in code match Epic registration
- [ ] Android manifest has deep link intent filter
- [ ] iOS Info.plist has URL scheme configured

## 🐛 Common Issues

| Issue | Solution |
|-------|----------|
| "Invalid Client ID" | Check `epic_config.dart` - no extra spaces |
| "Redirect URI mismatch" | Must match exactly: `mychartfhir://oauth/callback` |
| Deep link not working | Rebuild app after manifest changes |
| "Invalid scope" | Verify scopes match Epic registration |

## 📚 Need More Help?

- Full guide: See `EPIC_SETUP_GUIDE.md`
- Epic Documentation: [https://fhir.epic.com/](https://fhir.epic.com/)
- OAuth Tutorial: Available in Epic developer portal

## 🎯 What's Next?

After setup:
1. Test authentication flow
2. Verify patient data loads
3. Test all screens (Labs, Medications, Appointments)
4. Request production access when ready

