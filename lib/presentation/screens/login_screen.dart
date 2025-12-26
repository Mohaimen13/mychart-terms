import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychart_fhir_app/localization/app_localizations.dart';
import 'package:mychart_fhir_app/presentation/providers/auth_provider.dart';
import 'package:mychart_fhir_app/core/utils/rtl_utils.dart';

/// Login Screen
/// 
/// Handles OAuth authentication flow
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRtl = RtlUtils.isRtl(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo/Title
              Icon(
                Icons.medical_services,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                localizations.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: RtlUtils.getFontFamily(context),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'SMART on FHIR Patient Portal',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      fontFamily: RtlUtils.getFontFamily(context),
                    ),
              ),
              const SizedBox(height: 48),
              
              // Login Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (authProvider.errorMessage != null) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontFamily: RtlUtils.getFontFamily(context),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => authProvider.clearError(),
                                color: Colors.red[700],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }

                  return ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await authProvider.login();
                      } catch (e) {
                        // Error is handled by provider
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: Text(
                      localizations.login,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: RtlUtils.getFontFamily(context),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Info Text
              Text(
                'Connect to your Epic MyChart account to view your health information.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontFamily: RtlUtils.getFontFamily(context),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

