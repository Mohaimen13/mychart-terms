# Epic API Selection Guide

When registering your app in Epic's portal, you'll need to select which **Incoming APIs** (FHIR resources) your app needs access to.

## Required APIs for This App

Based on the features in your MyChart FHIR app, you need to select these APIs:

### ✅ Core APIs (Required)

1. **Patient**
   - **Why**: To display patient demographics and information
   - **Used in**: Dashboard screen, patient profile
   - **Scope**: `patient/Patient.read`

2. **Observation**
   - **Why**: To display lab results and vital signs
   - **Used in**: Labs & Vitals screen
   - **Scope**: `patient/Observation.read`
   - **Note**: This covers both laboratory results and vital signs

3. **MedicationRequest**
   - **Why**: To display current medications and prescriptions
   - **Used in**: Medications screen
   - **Scope**: `patient/MedicationRequest.read`

4. **Appointment**
   - **Why**: To display upcoming and past appointments
   - **Used in**: Appointments screen
   - **Scope**: `patient/Appointment.read`

### 📋 How to Select in Epic Portal

When registering your app at [https://fhir.epic.com/Developer/Apps](https://fhir.epic.com/Developer/Apps):

1. Look for a section called **"Incoming APIs"**, **"FHIR Resources"**, or **"API Access"**
2. You'll see a list of checkboxes or a multi-select dropdown
3. Check/Select these resources:
   - ✅ **Patient**
   - ✅ **Observation**
   - ✅ **MedicationRequest**
   - ✅ **Appointment**

### 🔍 Alternative Names in Epic Portal

Epic might use different terminology. Look for:
- "FHIR Resources"
- "Available APIs"
- "Resource Access"
- "API Permissions"
- "Incoming FHIR APIs"

### 📝 Scopes vs APIs

**Important:** There's a difference between:
- **APIs/Resources**: What FHIR resources your app can access (Patient, Observation, etc.)
- **Scopes**: The OAuth permissions (patient/Patient.read, etc.)

You need to configure **both**:
1. **APIs**: Select Patient, Observation, MedicationRequest, Appointment
2. **Scopes**: Select the corresponding read scopes (already in your code)

### 🎯 Complete Checklist

When registering in Epic portal, ensure you have:

**APIs/Resources Selected:**
- [X] Patient
- [X] Observation
- [X] MedicationRequest
- [X] Appointment

**Scopes Selected:**
- [ ] `patient/*.read` (or individual scopes)
- [ ] `patient/Patient.read`
- [ ] `patient/Observation.read`
- [ ] `patient/MedicationRequest.read`
- [ ] `patient/Appointment.read`
- [ ] `offline_access` (for refresh tokens)

### 🚫 APIs You DON'T Need (For Now)

These are NOT required for the current app features:
- ❌ Condition (diagnoses)
- ❌ AllergyIntolerance
- ❌ Encounter
- ❌ Procedure
- ❌ DiagnosticReport
- ❌ Immunization

**Note:** You can add these later if you want to expand features.

### 💡 Future Expansion

If you want to add more features later, you might need:
- **Condition**: For diagnoses/medical conditions
- **AllergyIntolerance**: For allergies
- **Immunization**: For vaccination records
- **DiagnosticReport**: For imaging and other reports

### ❓ Can't Find the API Selection?

If you don't see an "Incoming APIs" section:

1. **Check if it's automatic**: Some Epic portals automatically grant access based on scopes
2. **Look in "Advanced Settings"**: Might be in a collapsible section
3. **Contact Epic Support**: They can help you enable the right APIs
4. **Check Documentation**: Epic's developer docs might have updated instructions

### 🔄 After Selection

After selecting the APIs:

1. **Save your app registration**
2. **Note your Client ID** (you'll need it for `epic_config.dart`)
3. **Verify scopes match** what you selected
4. **Test in sandbox** to ensure data loads correctly

### ✅ Verification

After setup, test that each API works:

1. **Patient API**: Dashboard should show patient name
2. **Observation API**: Labs screen should show lab results
3. **MedicationRequest API**: Medications screen should show prescriptions
4. **Appointment API**: Appointments screen should show appointments

If any screen shows "No data" or errors, verify that API is selected in Epic portal.

## Quick Reference

**Minimum Required APIs:**
```
✅ Patient
✅ Observation  
✅ MedicationRequest
✅ Appointment
```

**Matching Scopes:**
```
✅ patient/Patient.read
✅ patient/Observation.read
✅ patient/MedicationRequest.read
✅ patient/Appointment.read
✅ offline_access
```

## Still Confused?

1. **Screenshot the Epic portal** - The interface might look different
2. **Check Epic's documentation** - They may have updated the UI
3. **Start with Patient API only** - Test, then add others one by one
4. **Contact Epic support** - They can guide you through their portal

