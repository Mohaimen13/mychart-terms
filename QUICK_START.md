# Quick Start Guide

## Prerequisites

1. Flutter SDK (>=3.0.0)
2. Epic Sandbox account at [open.epic.com](https://open.epic.com)
3. Android Studio / Xcode for mobile development

## Setup Steps

### 1. Install Dependencies

```bash
cd mychart_fhir_app
flutter pub get
```

### 2. Configure Epic Sandbox

1. Register your app at [open.epic.com](https://open.epic.com)
2. Note your Client ID and configure redirect URI: `mychartfhir://oauth/callback`
3. Copy the config template:
   ```bash
   cp lib/core/config/epic_config.dart.example lib/core/config/epic_config.dart
   ```
4. Edit `lib/core/config/epic_config.dart` and add your Client ID

### 3. Configure Deep Linking

#### Android
Follow instructions in `ANDROID_DEEP_LINKING.md`

#### iOS
Follow instructions in `IOS_DEEP_LINKING.md`

### 4. Run the App

```bash
flutter run
```

## Usage Flow

1. **Launch App**: App starts with login screen
2. **Tap Login**: Opens Epic authentication in browser
3. **Authenticate**: User logs in with Epic credentials
4. **Callback**: App receives OAuth callback via deep link
5. **Dashboard**: User sees patient dashboard with quick access cards
6. **Navigate**: Tap cards to view Labs, Medications, or Appointments

## Testing

### Test Authentication
1. Make sure you have valid Epic Sandbox credentials
2. The app will automatically handle the OAuth flow
3. Check logs for any authentication errors

### Test Deep Linking
- **Android**: Use `adb` command (see ANDROID_DEEP_LINKING.md)
- **iOS**: Use `xcrun simctl` command (see IOS_DEEP_LINKING.md)

## Troubleshooting

### Authentication Fails
- Verify Client ID in `epic_config.dart`
- Check redirect URI matches Epic configuration
- Ensure deep linking is properly configured

### Deep Link Not Working
- Verify manifest/Info.plist configuration
- Check URL scheme matches `epic_config.dart`
- Rebuild app after configuration changes

### No Data Loading
- Verify authentication is successful
- Check Epic Sandbox has test data
- Review error messages in UI

## Next Steps

- Customize UI themes and colors
- Add more FHIR resources (AllergyIntolerance, Condition, etc.)
- Implement offline data caching
- Add search and filtering capabilities
- Enhance error handling and retry logic

