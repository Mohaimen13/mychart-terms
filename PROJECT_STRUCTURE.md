# Project Structure

## Directory Tree

```
mychart_fhir_app/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   ├── epic_config.dart              # Epic Sandbox configuration
│   │   │   └── epic_config.dart.example      # Configuration template
│   │   ├── constants/
│   │   │   └── app_constants.dart            # App-wide constants
│   │   ├── errors/
│   │   │   └── fhir_exceptions.dart          # Custom exception classes
│   │   └── utils/
│   │       └── rtl_utils.dart                 # RTL/LTR utility functions
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── patient_model.dart            # Patient FHIR model
│   │   │   ├── observation_model.dart         # Observation FHIR model
│   │   │   ├── medication_request_model.dart # MedicationRequest FHIR model
│   │   │   └── appointment_model.dart        # Appointment FHIR model
│   │   │
│   │   └── services/
│   │       ├── auth/
│   │       │   ├── epic_auth_service.dart    # SMART on FHIR authentication
│   │       │   └── auth_state_manager.dart    # PKCE state management
│   │       ├── fhir/
│   │       │   └── fhir_service.dart          # FHIR API service layer
│   │       └── storage/
│   │           └── secure_storage_service.dart # Secure token storage
│   │
│   ├── localization/
│   │   └── app_localizations.dart            # i18n (English & Arabic)
│   │
│   └── main.dart                             # App entry point
│
├── assets/
│   └── fonts/                                # Arabic-supporting fonts
│
├── pubspec.yaml                              # Dependencies
├── analysis_options.yaml                     # Linting rules
├── README.md                                 # Project documentation
└── .gitignore                                # Git ignore rules
```

## Key Components

### Authentication Service (`epic_auth_service.dart`)
- Implements OAuth 2.0 Standalone Launch flow
- PKCE (Proof Key for Code Exchange) for security
- Automatic token refresh
- Secure token storage integration

### FHIR Service (`fhir_service.dart`)
- Isolated service layer for all FHIR API calls
- Automatic token injection via interceptors
- Error handling and transformation
- Methods for Patient, Observation, MedicationRequest, Appointment

### Secure Storage Service (`secure_storage_service.dart`)
- Uses Flutter Secure Storage (Keychain/Keystore)
- Stores OAuth tokens securely
- Never stores PHI/PII in plain text

### Data Models
- Type-safe FHIR resource models
- Factory constructors from FHIR JSON
- Equatable for value comparison

### Localization (`app_localizations.dart`)
- English (LTR) and Arabic (RTL) support
- Dynamic locale switching
- RTL-aware utilities

## Next Steps

1. **UI Screens**: Create patient dashboard, labs view, medications view, appointments view
2. **State Management**: Add Provider/Riverpod for app state
3. **Deep Linking**: Implement OAuth callback handler
4. **Error Handling UI**: User-friendly error messages
5. **Loading States**: Loading indicators for async operations

