# Complete Epic Portal Registration Guide

## ✅ What You've Already Set Up

- ✅ **Application Name:** MyChart FHIR App
- ✅ **Client ID:** 9cd6e810-5298-4403-a2fe-303ad3bdf596 (Production)
- ✅ **Non-Production Client ID:** 9c11bf83-22a3-4731-9c8a-bca4ed974c45
- ✅ **Redirect URI:** http://127.0.0.1:3000/oauth/callback
- ✅ **Terms and Conditions URL:** https://mohaimen13.github.io/mychart-terms/
- ✅ **Summary:** Already filled in

## 📝 Fields to Complete

### 1. Application Audience
**Select:** ✅ **Patients** (already selected - correct!)

### 2. Public Documentation URL
**Enter:**
```
https://mohaimen13.github.io/mychart-terms/
```
(Or your app's documentation URL if you have one)

### 3. Incoming APIs
**Select these APIs:**
- ✅ **Patient**
- ✅ **Observation**
- ✅ **MedicationRequest**
- ✅ **Appointment**

(These should already be selected based on your app features)

### 4. Will this app register dynamic clients?
**Answer:** ❌ **NO** (unchecked)
- Your app uses a pre-registered client ID

### 5. Is this app a confidential client?
**Answer:** ❌ **NO** (unchecked)
- This is a public client (web app using PKCE)

### 6. SMART on FHIR Version
**Select:** ✅ **R4**
- Your app uses FHIR R4

### 7. SMART Scope Version
**Select:** ✅ **SMART v1**
- Standard for patient-facing apps

### 8. FHIR ID Generation Scheme
**Select:** ✅ **Use Unconstrained FHIR IDs**
- Standard option

### 9. Description
**Enter:**
```
MyChart FHIR App is a patient-facing web application that enables patients to securely access and view their health information from Epic Systems. The app provides patients with convenient access to their medical records, including patient demographics, laboratory results, vital signs, current medications, and appointment history. The application uses SMART on FHIR protocols with OAuth 2.0 authentication and PKCE for secure access, ensuring patient data privacy and security. The app supports both English and Arabic languages to serve diverse patient populations.
```

### 10. Intended Purposes
**Select:**
- ✅ **Individuals' Access to their EHI** (Electronic Health Information)
- This is the main purpose of your app

### 11. Intended Users
**Select:**
- ✅ **Individual/Caregiver**
- This matches your patient-facing app

### 12. Additional Disclosure Information URL
**Optional - Leave empty or use:**
```
https://mohaimen13.github.io/mychart-terms/
```

## ⚠️ Important Notes

### Redirect URI Warning
Epic says: "Only secured redirect URIs can be used in production. Please provide at least one https redirect URI"

**For Production:**
- You'll need: `https://yourdomain.com/oauth/callback`
- For now, `http://127.0.0.1:3000/oauth/callback` is fine for development

**When deploying to production:**
1. Deploy your app to a domain with HTTPS
2. Add the HTTPS redirect URI in Epic portal
3. Update your app's config to use the production URL

### Recommended Questionnaires
Epic mentions "2 recommended questionnaires with unanswered questions"

**These are likely:**
1. **Security questionnaire** - About how you handle data
2. **Privacy questionnaire** - About patient privacy

**Answer based on your app:**
- ✅ Uses PKCE for security
- ✅ Tokens stored securely (localStorage for web, can be improved)
- ✅ Read-only access (no write operations)
- ✅ No third-party sharing
- ✅ Patient data only displayed to the patient

## ✅ Final Checklist

Before marking app as "Ready for Production":

- [ ] All required fields filled
- [ ] Redirect URI set (http://127.0.0.1:3000/oauth/callback for dev)
- [ ] Terms and Conditions URL provided
- [ ] Incoming APIs selected (Patient, Observation, MedicationRequest, Appointment)
- [ ] Summary and Description filled
- [ ] Intended Purposes selected
- [ ] Intended Users selected
- [ ] Questionnaires completed (if required)
- [ ] HTTPS redirect URI added (for production)

## 🚀 Next Steps

1. **Complete all fields above**
2. **Save your changes**
3. **Wait 2-5 minutes for changes to take effect**
4. **Test your app** - Try logging in again
5. **For production:** Add HTTPS redirect URI when you deploy

## Testing

After completing the form:

1. **Save all changes**
2. **Wait 2-5 minutes**
3. **Try logging in from your app:** http://127.0.0.1:3000
4. **Click "Login with Epic"**
5. **You should be redirected to Epic's login page** (not 404!)

If you still get 404, double-check:
- Redirect URI matches exactly: `http://127.0.0.1:3000/oauth/callback`
- You clicked Save
- You waited a few minutes

