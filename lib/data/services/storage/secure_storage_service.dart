import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mychart_fhir_app/core/constants/app_constants.dart';

/// Service for securely storing sensitive data (OAuth tokens, PHI)
/// 
/// Uses Flutter Secure Storage which leverages:
/// - iOS: Keychain
/// - Android: Keystore
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Store OAuth access token
  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: token);
  }

  /// Retrieve OAuth access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.accessTokenKey);
  }

  /// Store OAuth refresh token
  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  /// Retrieve OAuth refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.refreshTokenKey);
  }

  /// Store token expiry timestamp
  Future<void> storeTokenExpiry(DateTime expiry) async {
    await _storage.write(
      key: AppConstants.tokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  /// Retrieve token expiry timestamp
  Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: AppConstants.tokenExpiryKey);
    if (expiryString == null) return null;
    return DateTime.tryParse(expiryString);
  }

  /// Store patient ID (for context)
  Future<void> storePatientId(String patientId) async {
    await _storage.write(key: AppConstants.patientIdKey, value: patientId);
  }

  /// Retrieve patient ID
  Future<String?> getPatientId() async {
    return await _storage.read(key: AppConstants.patientIdKey);
  }

  /// Clear all stored tokens and session data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Clear only authentication tokens (keep patient ID if needed)
  Future<void> clearAuthTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.tokenExpiryKey);
  }
}

