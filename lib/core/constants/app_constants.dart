/// Application-wide constants
class AppConstants {
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tokenExpiryKey = 'token_expiry';
  static const String patientIdKey = 'patient_id';
  static const String localeKey = 'app_locale';
  
  // Supported Locales
  static const String englishLocale = 'en';
  static const String arabicLocale = 'ar';
  
  // Default Locale
  static const String defaultLocale = englishLocale;
  
  // Token Refresh Buffer (refresh 5 minutes before expiry)
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);
  
  // API Timeout
  static const Duration apiTimeout = Duration(seconds: 30);
}

