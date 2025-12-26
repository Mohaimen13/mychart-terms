import 'package:flutter/foundation.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/services/auth/epic_auth_service.dart';

/// Authentication State Provider
/// 
/// Manages authentication state and OAuth flow
class AuthProvider extends ChangeNotifier {
  final EpicAuthService _authService = EpicAuthService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  /// Check current authentication status
  Future<void> _checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      _isAuthenticated = await _authService.isAuthenticated();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initiate OAuth login flow
  Future<void> login() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.launchAuthorization();
      // Note: Actual authentication completion happens in deep link handler
    } catch (e) {
      _errorMessage = e is AuthenticationException
          ? e.message
          : 'Failed to initiate login: ${e.toString()}';
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handle OAuth callback with authorization code
  Future<void> handleAuthCallback({
    required String authorizationCode,
    required String state,
    required String codeVerifier,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.handleAuthorizationCallback(
        authorizationCode: authorizationCode,
        state: state,
        codeVerifier: codeVerifier,
      );

      _isAuthenticated = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is AuthenticationException
          ? e.message
          : 'Authentication failed: ${e.toString()}';
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.logout();
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh authentication status
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}

