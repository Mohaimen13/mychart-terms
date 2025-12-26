# Epic Portal Registration Settings

Quick reference for the settings you'll encounter when registering your app in Epic's developer portal.

## Client Type Settings

### ❌ Can Register Dynamic Clients
**Answer: NO (unchecked)**

**What it means:**
- Dynamic client registration allows apps to register new clients on-the-fly
- This is typically used for server-to-server integrations or apps that need to create multiple client instances

**Why NO for this app:**
- This app uses a **pre-registered client ID** that you configure once
- You manually register the app in Epic's portal and use that single Client ID
- No need for dynamic registration

### ❌ Is Confidential Client
**Answer: NO (unchecked)**

**What it means:**
- **Confidential clients** can securely store a client secret (like server-side apps)
- **Public clients** cannot securely store secrets (like mobile apps)

**Why NO for this app:**
- This is a **mobile Flutter app** (public client)
- Mobile apps cannot securely store client secrets (they can be extracted from the app)
- The app uses **PKCE (Proof Key for Code Exchange)** instead for security
- PKCE is the recommended security method for public clients

## How to Verify Your App is Public

Check your code in `lib/data/services/auth/epic_auth_service.dart`:

✅ **Uses PKCE**: Lines 26-45 show PKCE code generation
✅ **No Client Secret**: Lines 167-175 show token exchange - notice there's NO `client_secret` parameter
✅ **Mobile App**: Flutter app running on user devices

## Summary

| Setting | Value | Reason |
|---------|-------|--------|
| **Can Register Dynamic Clients** | ❌ NO | Uses pre-registered client ID |
| **Is Confidential Client** | ❌ NO | Public mobile app using PKCE |

## Related Documentation

- **OAuth Flow**: See `lib/data/services/auth/epic_auth_service.dart`
- **PKCE Details**: RFC 7636 (Proof Key for Code Exchange)
- **Epic Setup**: See `EPIC_SETUP_GUIDE.md`

