import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';
import 'package:mychart_fhir_app/core/utils/rtl_utils.dart';
import 'package:mychart_fhir_app/core/services/deep_link_service.dart';
import 'package:mychart_fhir_app/presentation/providers/auth_provider.dart';
import 'package:mychart_fhir_app/presentation/providers/patient_provider.dart';
import 'package:mychart_fhir_app/presentation/providers/observations_provider.dart';
import 'package:mychart_fhir_app/presentation/providers/medications_provider.dart';
import 'package:mychart_fhir_app/presentation/providers/appointments_provider.dart';
import 'package:mychart_fhir_app/presentation/screens/login_screen.dart';
import 'package:mychart_fhir_app/presentation/screens/dashboard_screen.dart';
import 'package:mychart_fhir_app/presentation/widgets/auth_deep_link_handler.dart';

void main() {
  runApp(const MyChartApp());
}

class MyChartApp extends StatefulWidget {
  const MyChartApp({super.key});

  @override
  State<MyChartApp> createState() => _MyChartAppState();
}

class _MyChartAppState extends State<MyChartApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Locale _currentLocale = const Locale('en', '');

  @override
  void initState() {
    super.initState();
    _initializeDeepLinking();
  }

  Future<void> _initializeDeepLinking() async {
    await _deepLinkService.initialize();
  }

  void _switchLocale() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en'
          ? const Locale('ar', '')
          : const Locale('en', '');
    });
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => ObservationsProvider()),
        ChangeNotifierProvider(create: (_) => MedicationsProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
      ],
      child: MaterialApp(
        title: 'MyChart FHIR',
        debugShowCheckedModeBanner: false,
        
        // Localization
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _currentLocale,
        
        // Theme
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Cairo', // Supports both Latin and Arabic
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        
        // RTL Support
        builder: (context, child) {
          return Directionality(
            textDirection: RtlUtils.getTextDirection(context),
            child: AuthDeepLinkHandler(
              child: child!,
            ),
          );
        },
        
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Show login screen if not authenticated
            if (!authProvider.isAuthenticated) {
              return const LoginScreen();
            }
            
            // Show dashboard if authenticated
            return const DashboardScreen();
          },
        ),
      ),
    );
  }
}

