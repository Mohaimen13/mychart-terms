import 'package:flutter/material.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';

/// Utility functions for RTL/LTR handling
class RtlUtils {
  /// Get text direction based on locale
  static TextDirection getTextDirection(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Check if current locale is RTL
  static bool isRtl(BuildContext context) {
    return getTextDirection(context) == TextDirection.rtl;
  }

  /// Get font family based on locale
  /// 
  /// Returns appropriate font that supports both scripts
  static String getFontFamily(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ar') {
      return 'Cairo'; // Or 'NotoSansArabic'
    }
    return 'Cairo'; // Cairo supports both Latin and Arabic
  }
}

