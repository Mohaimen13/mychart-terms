# Epic Client IDs

## Your Client IDs

### Non-Production Client ID (Sandbox/Testing)
```
9c11bf83-22a3-4731-9c8a-bca4ed974c45
```
**Use this for:**
- Development and testing
- Epic Sandbox environment
- Initial app development

### Production Client ID
```
9cd6e810-5298-4403-a2fe-303ad3bdf596
```
**Use this for:**
- Production deployments
- Live patient-facing app
- After Epic approves your app for production

## Current Configuration

The app is currently configured with the **Non-Production Client ID** for development/testing.

**File:** `lib/core/config/epic_config.dart`
**Line 24:** `static const String clientId = '9c11bf83-22a3-4731-9c8a-bca4ed974c45';`

## Switching to Production

When you're ready to deploy to production:

1. Open `lib/core/config/epic_config.dart`
2. Change line 24 to:
   ```dart
   static const String clientId = '9cd6e810-5298-4403-a2fe-303ad3bdf596';
   ```
3. Update the base URL and endpoints if Epic provides different production URLs
4. Test thoroughly before going live

## Important Notes

⚠️ **Never commit production credentials to public repositories**  
⚠️ **Use environment variables or secure config for production**  
⚠️ **Each Client ID is tied to specific redirect URIs and scopes**  
✅ **Both Client IDs should use the same redirect URI:** `mychartfhir://oauth/callback`

## Verification

To verify your Client ID is working:
1. Run the app: `flutter run`
2. Try to log in
3. Check that authentication works
4. Verify data loads correctly

## Support

If you encounter issues:
- Verify the Client ID matches what's registered in Epic portal
- Check that redirect URI matches exactly
- Ensure scopes are properly configured
- Contact Epic support if authentication fails

