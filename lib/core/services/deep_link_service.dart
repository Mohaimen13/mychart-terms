import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';
import 'package:mychart_fhir_app/core/config/epic_config.dart';
import 'package:mychart_fhir_app/data/services/auth/auth_state_manager.dart';

/// Deep Link Service
/// 
/// Handles OAuth callback URLs and deep linking
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AuthStateManager _authStateManager = AuthStateManager();
  StreamSubscription<String>? _linkSubscription;

  /// Initialize deep link listening
  Future<void> initialize() async {
    try {
      // Handle initial link if app was opened via deep link
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }

      // Listen for incoming links
      _linkSubscription = linkStream.listen(
        _handleDeepLink,
        onError: (err) {
          if (kDebugMode) {
            debugPrint('Deep link error: $err');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize deep links: $e');
      }
    }
  }

  /// Handle deep link URL
  void _handleDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      
      // Check if it's our OAuth callback
      if (uri.scheme == 'mychartfhir' && uri.host == 'oauth') {
        final path = uri.path;
        
        if (path == '/callback') {
          _handleOAuthCallback(uri);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error handling deep link: $e');
      }
    }
  }

  /// Handle OAuth callback
  Future<void> _handleOAuthCallback(Uri uri) async {
    try {
      final queryParams = uri.queryParameters;
      
      // Extract authorization code
      final authorizationCode = queryParams['code'];
      final state = queryParams['state'];
      final error = queryParams['error'];
      final errorDescription = queryParams['error_description'];

      if (error != null) {
        if (kDebugMode) {
          debugPrint('OAuth error: $error - $errorDescription');
        }
        // Notify error via callback or event
        return;
      }

      if (authorizationCode == null || state == null) {
        if (kDebugMode) {
          debugPrint('Missing authorization code or state');
        }
        return;
      }

      // Verify state
      final storedState = await _authStateManager.getPkceState();
      if (storedState != state) {
        if (kDebugMode) {
          debugPrint('State mismatch: expected $storedState, got $state');
        }
        return;
      }

      // Get stored code verifier
      final codeVerifier = await _authStateManager.getPkceVerifier();
      if (codeVerifier == null) {
        if (kDebugMode) {
          debugPrint('No code verifier found');
        }
        return;
      }

      // Return callback data for AuthProvider to handle
      _onAuthCallback?.call(
        authorizationCode: authorizationCode,
        state: state,
        codeVerifier: codeVerifier,
      );

      // Clear PKCE data after use
      await _authStateManager.clearPkceData();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error handling OAuth callback: $e');
      }
    }
  }

  /// Callback function for OAuth completion
  /// Set this from AuthProvider or main app
  Function({
    required String authorizationCode,
    required String state,
    required String codeVerifier,
  })? _onAuthCallback;

  /// Set callback for OAuth completion
  void setAuthCallback(Function({
    required String authorizationCode,
    required String state,
    required String codeVerifier,
  }) callback) {
    _onAuthCallback = callback;
  }

  /// Get the callback function (for external access)
  Function({
    required String authorizationCode,
    required String state,
    required String codeVerifier,
  })? get authCallback => _onAuthCallback;

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}

