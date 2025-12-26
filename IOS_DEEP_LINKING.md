# iOS Deep Linking Configuration

To enable OAuth callback handling on iOS, you need to configure URL schemes in your iOS project.

## Steps

1. Open `ios/Runner/Info.plist`

2. Add the following configuration inside the root `<dict>` tag:

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

3. Make sure the URL scheme (`mychartfhir`) matches the scheme in your `redirectUri` in `epic_config.dart`:
   - `redirectUri = 'mychartfhir://oauth/callback'`

4. Rebuild your app:
```bash
flutter clean
flutter pub get
flutter run
```

## Testing

After configuration, you can test deep linking on a simulator or device:
```bash
xcrun simctl openurl booted "mychartfhir://oauth/callback?code=test123&state=teststate"
```

Or on a physical device, you can use Safari to navigate to the deep link URL.

## Additional Notes

- The URL scheme must be unique to avoid conflicts with other apps
- Make sure to register the same redirect URI in your Epic Sandbox app configuration
- The deep link handler will automatically parse the OAuth callback parameters

