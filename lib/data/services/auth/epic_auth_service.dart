import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mychart_fhir_app/core/config/epic_config.dart';
import 'package:mychart_fhir_app/core/constants/app_constants.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/services/auth/auth_state_manager.dart';
import 'package:mychart_fhir_app/data/services/storage/secure_storage_service.dart';

/// Authentication Service for Epic Systems via SMART on FHIR
/// 
/// Implements OAuth 2.0 Standalone Launch Flow:
/// 1. Generate authorization URL with PKCE parameters
/// 2. Launch browser for user authentication
/// 3. Handle redirect callback with authorization code
/// 4. Exchange authorization code for access/refresh tokens
/// 5. Store tokens securely
class EpicAuthService {
  final SecureStorageService _storageService = SecureStorageService();
  final AuthStateManager _authStateManager = AuthStateManager();
  final Dio _dio = Dio();

  /// Generate PKCE code verifier and challenge
  /// 
  /// PKCE (Proof Key for Code Exchange) enhances security for public clients
  Map<String, String> _generatePkcePair() {
    // Generate a random code verifier (43-128 characters, recommended: 128)
    final codeVerifier = _generateRandomString(128);
    
    // Generate code challenge (SHA256 hash of verifier, base64url encoded)
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    final codeChallenge = base64Url.encode(digest.bytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
    
    return {
      'code_verifier': codeVerifier,
      'code_challenge': codeChallenge,
    };
  }

  /// Generate cryptographically secure random string for PKCE
  /// 
  /// Uses characters allowed in PKCE code verifier (RFC 7636)
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Generate state parameter for CSRF protection
  String _generateState() {
    return _generateRandomString(32);
  }

  /// Build authorization URL for SMART App Launch
  /// 
  /// Returns: Authorization URL and state (for verification)
  Map<String, String> buildAuthorizationUrl() async {
    final pkce = _generatePkcePair();
    final state = _generateState();
    
    // Store PKCE verifier and state for callback handling
    await _authStateManager.storePkceData(
      codeVerifier: pkce['code_verifier']!,
      state: state,
    );
    
    final params = {
      'response_type': 'code',
      'client_id': EpicConfig.clientId,
      'redirect_uri': EpicConfig.redirectUri,
      'scope': EpicConfig.scopes.join(' '),
      'state': state,
      'code_challenge': pkce['code_challenge']!,
      'code_challenge_method': 'S256',
      'aud': EpicConfig.baseUrl,
    };

    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final authUrl = '${EpicConfig.smartLaunchEndpoint}?$queryString';

    return {
      'url': authUrl,
      'state': state,
      'code_verifier': pkce['code_verifier']!,
    };
  }

  /// Launch authorization URL in browser
  Future<void> launchAuthorization() async {
    final authData = await buildAuthorizationUrl();
    final url = Uri.parse(authData['url']!);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw AuthenticationException('Unable to launch authorization URL');
    }
  }

  /// Handle OAuth callback with authorization code
  /// 
  /// This method should be called when the app receives the redirect callback
  /// with the authorization code.
  /// 
  /// Parameters:
  /// - [authorizationCode]: The code received from the OAuth callback
  /// - [state]: The state parameter (must match the one sent)
  /// - [codeVerifier]: The PKCE code verifier (must match the challenge sent)
  Future<void> handleAuthorizationCallback({
    required String authorizationCode,
    required String state,
    required String codeVerifier,
  }) async {
    try {
      // Exchange authorization code for tokens
      final tokenResponse = await _exchangeCodeForTokens(
        authorizationCode: authorizationCode,
        codeVerifier: codeVerifier,
      );

      // Store tokens securely
      await _storageService.storeAccessToken(tokenResponse['access_token']);
      
      if (tokenResponse['refresh_token'] != null) {
        await _storageService.storeRefreshToken(tokenResponse['refresh_token']);
      }

      // Calculate and store token expiry
      final expiresIn = tokenResponse['expires_in'] as int? ?? 3600;
      final expiry = DateTime.now().add(Duration(seconds: expiresIn));
      await _storageService.storeTokenExpiry(expiry);

      // Extract patient ID from token response if available
      if (tokenResponse['patient'] != null) {
        await _storageService.storePatientId(tokenResponse['patient']);
      }

      // Clear PKCE data after successful authentication
      await _authStateManager.clearPkceData();
    } catch (e) {
      throw AuthenticationException(
        'Failed to complete authentication: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Exchange authorization code for access and refresh tokens
  Future<Map<String, dynamic>> _exchangeCodeForTokens({
    required String authorizationCode,
    required String codeVerifier,
  }) async {
    try {
      final response = await _dio.post(
        EpicConfig.tokenEndpoint,
        data: {
          'grant_type': 'authorization_code',
          'code': authorizationCode,
          'redirect_uri': EpicConfig.redirectUri,
          'client_id': EpicConfig.clientId,
          'code_verifier': codeVerifier,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw AuthenticationException(
          'Token exchange failed: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw AuthenticationException(
        'Network error during token exchange: ${e.message}',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    } catch (e) {
      throw AuthenticationException(
        'Unexpected error during token exchange: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Refresh access token using refresh token
  Future<void> refreshAccessToken() async {
    final refreshToken = await _storageService.getRefreshToken();
    
    if (refreshToken == null) {
      throw TokenException('No refresh token available');
    }

    try {
      final response = await _dio.post(
        EpicConfig.tokenEndpoint,
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': EpicConfig.clientId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final tokenData = response.data as Map<String, dynamic>;
        
        await _storageService.storeAccessToken(tokenData['access_token']);
        
        if (tokenData['refresh_token'] != null) {
          await _storageService.storeRefreshToken(tokenData['refresh_token']);
        }

        final expiresIn = tokenData['expires_in'] as int? ?? 3600;
        final expiry = DateTime.now().add(Duration(seconds: expiresIn));
        await _storageService.storeTokenExpiry(expiry);
      } else {
        throw TokenException(
          'Token refresh failed: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw TokenException(
        'Network error during token refresh: ${e.message}',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    } catch (e) {
      throw TokenException(
        'Unexpected error during token refresh: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get current access token, refreshing if necessary
  Future<String?> getValidAccessToken() async {
    final accessToken = await _storageService.getAccessToken();
    final expiry = await _storageService.getTokenExpiry();

    if (accessToken == null) {
      return null;
    }

    // Check if token is expired or about to expire
    if (expiry != null) {
      final now = DateTime.now();
      final bufferTime = expiry.subtract(AppConstants.tokenRefreshBuffer);
      
      if (now.isAfter(bufferTime)) {
        // Token is expired or about to expire, try to refresh
        try {
          await refreshAccessToken();
          return await _storageService.getAccessToken();
        } catch (e) {
          // Refresh failed, return null to force re-authentication
          if (kDebugMode) {
            // Never log PHI/PII - only log error type
            debugPrint('Token refresh failed: ${e.runtimeType}');
          }
          return null;
        }
      }
    }

    return accessToken;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getValidAccessToken();
    return token != null;
  }

  /// Logout and clear all stored tokens
  Future<void> logout() async {
    await _storageService.clearAuthTokens();
  }
}

