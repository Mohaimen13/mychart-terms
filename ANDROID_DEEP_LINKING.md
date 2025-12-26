# Android Deep Linking Configuration

To enable OAuth callback handling on Android, you need to configure deep linking in your Android manifest.

## Steps

1. Open `android/app/src/main/AndroidManifest.xml`

2. Add the following intent filter inside the `<activity>` tag for your main activity (usually `MainActivity`):

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme"
    ...>
    
    <!-- Existing intent filters -->
    
    <!-- Deep Link Intent Filter for OAuth Callback -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="mychartfhir"
            android:host="oauth" />
    </intent-filter>
</activity>
```

3. Make sure the scheme (`mychartfhir`) and host (`oauth`) match the `redirectUri` in your `epic_config.dart`:
   - `redirectUri = 'mychartfhir://oauth/callback'`

4. Rebuild your app:
```bash
flutter clean
flutter pub get
flutter run
```

## Testing

After configuration, you can test deep linking with:
```bash
adb shell am start -W -a android.intent.action.VIEW -d "mychartfhir://oauth/callback?code=test123&state=teststate" com.your.package.name
```

Replace `com.your.package.name` with your actual package name from `android/app/build.gradle`.

