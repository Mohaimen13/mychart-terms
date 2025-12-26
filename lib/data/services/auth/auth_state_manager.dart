import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mychart_fhir_app/data/services/storage/secure_storage_service.dart';

/// Manages PKCE state during authentication flow
/// 
/// Stores temporary PKCE verifier and state for OAuth callback handling
class AuthStateManager {
  static final AuthStateManager _instance = AuthStateManager._internal();
  factory AuthStateManager() => _instance;
  AuthStateManager._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Temporary storage keys for PKCE flow
  static const String _pkceVerifierKey = 'pkce_code_verifier';
  static const String _pkceStateKey = 'pkce_state';

  /// Store PKCE verifier and state for later use in callback
  Future<void> storePkceData({
    required String codeVerifier,
    required String state,
  }) async {
    await _storage.write(key: _pkceVerifierKey, value: codeVerifier);
    await _storage.write(key: _pkceStateKey, value: state);
  }

  /// Retrieve stored PKCE verifier
  Future<String?> getPkceVerifier() async {
    return await _storage.read(key: _pkceVerifierKey);
  }

  /// Retrieve stored PKCE state
  Future<String?> getPkceState() async {
    return await _storage.read(key: _pkceStateKey);
  }

  /// Clear PKCE data after successful authentication
  Future<void> clearPkceData() async {
    await _storage.delete(key: _pkceVerifierKey);
    await _storage.delete(key: _pkceStateKey);
  }
}

