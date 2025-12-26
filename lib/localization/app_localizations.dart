import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

/// Application localization delegate
/// 
/// Supports English (LTR) and Arabic (RTL) with dynamic switching
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
  ];

  // Translation maps
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'MyChart',
      'login': 'Login',
      'logout': 'Logout',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'patient': 'Patient',
      'labs': 'Labs',
      'vitals': 'Vitals',
      'medications': 'Medications',
      'appointments': 'Appointments',
      'auth_failed': 'Authentication failed',
      'network_error': 'Network error',
      'session_expired': 'Session expired. Please login again.',
    },
    'ar': {
      'app_title': 'مخططي',
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'patient': 'المريض',
      'labs': 'المختبرات',
      'vitals': 'العلامات الحيوية',
      'medications': 'الأدوية',
      'appointments': 'المواعيد',
      'auth_failed': 'فشل المصادقة',
      'network_error': 'خطأ في الشبكة',
      'session_expired': 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Convenience getters
  String get appTitle => translate('app_title');
  String get login => translate('login');
  String get logout => translate('logout');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get patient => translate('patient');
  String get labs => translate('labs');
  String get vitals => translate('vitals');
  String get medications => translate('medications');
  String get appointments => translate('appointments');
  String get authFailed => translate('auth_failed');
  String get networkError => translate('network_error');
  String get sessionExpired => translate('session_expired');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

