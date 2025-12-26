import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychart_fhir_app/core/services/deep_link_service.dart';
import 'package:mychart_fhir_app/presentation/providers/auth_provider.dart';

/// Widget that handles deep link callbacks for authentication
/// 
/// This should be placed high in the widget tree to catch OAuth callbacks
class AuthDeepLinkHandler extends StatefulWidget {
  final Widget child;

  const AuthDeepLinkHandler({
    super.key,
    required this.child,
  });

  @override
  State<AuthDeepLinkHandler> createState() => _AuthDeepLinkHandlerState();
}

class _AuthDeepLinkHandlerState extends State<AuthDeepLinkHandler> {
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    _setupDeepLinkCallback();
  }

  void _setupDeepLinkCallback() {
    // Set callback for OAuth completion
    _deepLinkService.setAuthCallback(({
      required String authorizationCode,
      required String state,
      required String codeVerifier,
    }) async {
      // Access AuthProvider from context
      final authProvider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );
      
      await authProvider.handleAuthCallback(
        authorizationCode: authorizationCode,
        state: state,
        codeVerifier: codeVerifier,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

