# MyChart FHIR App

A patient-facing mobile application integrating with Epic Systems via SMART on FHIR protocols.

## Features

- **SMART on FHIR Integration**: OAuth 2.0 Standalone Launch flow with PKCE
- **Bilingual Support**: English & Arabic with dynamic RTL/LTR switching
- **FHIR R4 Compliance**: Full support for Patient, Observation, MedicationRequest, and Appointment resources
- **Secure Token Storage**: OAuth tokens stored in device secure storage (Keychain/Keystore)
- **Service Layer Architecture**: Clean separation of concerns with isolated FHIR API calls

## Architecture

```
lib/
├── core/
│   ├── config/          # App configuration (Epic endpoints, credentials)
│   ├── constants/       # App-wide constants
│   ├── errors/          # Custom exception classes
│   └── utils/           # Utility functions (RTL helpers, etc.)
├── data/
│   ├── models/          # FHIR data models (Patient, Observation, etc.)
│   ├── repositories/    # Data repositories (future)
│   └── services/        # API services
│       ├── auth/        # Authentication service (EpicAuthService)
│       ├── fhir/        # FHIR service layer
│       └── storage/     # Secure storage service
├── localization/        # i18n resources (English & Arabic)
└── presentation/
    ├── providers/       # State management (future)
    ├── screens/         # UI screens (future)
    └── widgets/         # Reusable widgets (future)
```

## Setup

### 1. Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Epic Sandbox account (register at [open.epic.com](https://open.epic.com))

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Epic Sandbox

1. Copy the example config file:
```bash
cp lib/core/config/epic_config.dart.example lib/core/config/epic_config.dart
```

2. Update `lib/core/config/epic_config.dart` with your Epic Sandbox credentials:
   - `clientId`: Your registered app's client ID
   - `redirectUri`: Must match the redirect URI registered in Epic
   - Update endpoints if using a different Epic environment

### 4. Configure Deep Linking (Mobile)

For OAuth redirect handling, configure deep linking:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="mychartfhir" android:host="oauth" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>mychartfhir</string>
        </array>
    </dict>
</array>
```

### 5. Add Fonts (Optional)

Download and add Arabic-supporting fonts to `assets/fonts/`:
- Cairo: [Google Fonts](https://fonts.google.com/specimen/Cairo)
- Noto Sans Arabic: [Google Fonts](https://fonts.google.com/noto/specimen/Noto+Sans+Arabic)

## Usage

### Authentication Flow

```dart
final authService = EpicAuthService();

// 1. Launch authorization
await authService.launchAuthorization();

// 2. Handle callback (in your deep link handler)
await authService.handleAuthorizationCallback(
  authorizationCode: code,
  state: state,
  codeVerifier: codeVerifier, // Store this from buildAuthorizationUrl()
);

// 3. Check authentication status
final isAuthenticated = await authService.isAuthenticated();

// 4. Get valid access token (auto-refreshes if needed)
final token = await authService.getValidAccessToken();
```

### Fetching FHIR Resources

```dart
final fhirService = FhirService();

// Get patient information
final patientJson = await fhirService.getPatient();
final patient = PatientModel.fromFhirJson(patientJson);

// Get observations (labs & vitals)
final observationsJson = await fhirService.getObservations(
  category: 'laboratory', // or 'vital-signs'
);

// Get medications
final medicationsJson = await fhirService.getMedicationRequests();

// Get appointments
final appointmentsJson = await fhirService.getAppointments();
```

## Localization

The app supports English (LTR) and Arabic (RTL) with dynamic switching:

```dart
// Switch locale
Localizations.override(
  context: context,
  locale: const Locale('ar', ''),
  child: YourWidget(),
);

// Access translations
final localizations = AppLocalizations.of(context);
Text(localizations.appTitle);
```

## Security Best Practices

- ✅ OAuth tokens stored in secure storage (Keychain/Keystore)
- ✅ PKCE implementation for enhanced security
- ✅ No PHI/PII logging
- ✅ Automatic token refresh before expiry
- ✅ Secure HTTP interceptors for token injection

## Development

### Code Generation

If using JSON serialization:
```bash
flutter pub run build_runner build
```

### Linting

```bash
flutter analyze
```

## Project Status

✅ **Completed:**
- Project structure
- Authentication service (SMART App Launch with PKCE)
- Secure storage service
- FHIR service layer
- Data models (Patient, Observation, MedicationRequest, Appointment)
- i18n setup (English & Arabic)
- RTL/LTR support
- **State management (Provider-based)**
- **UI screens (Login, Dashboard, Labs, Medications, Appointments)**
- **Deep linking handler for OAuth callbacks**
- **Navigation and routing**

## UI Features

### Screens
1. **Login Screen**: OAuth authentication with Epic
2. **Dashboard**: Patient overview with quick access cards
3. **Labs & Vitals**: Tabbed view showing laboratory results and vital signs
4. **Medications**: List of current medications with dosage instructions
5. **Appointments**: Tabbed view for upcoming and past appointments

### State Management
- `AuthProvider`: Manages authentication state and OAuth flow
- `PatientProvider`: Handles patient data loading
- `ObservationsProvider`: Manages labs and vitals data
- `MedicationsProvider`: Handles medication requests
- `AppointmentsProvider`: Manages appointment data

### Deep Linking
- Automatic OAuth callback handling
- Secure PKCE state verification
- Seamless authentication flow

## License

[Your License Here]

## Support

For Epic FHIR documentation: [Epic FHIR Documentation](https://fhir.epic.com/)

