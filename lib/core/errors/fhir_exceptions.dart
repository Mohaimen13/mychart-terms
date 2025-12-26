/// Custom exceptions for FHIR operations
class FhirException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  FhirException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'FhirException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Authentication-related exceptions
class AuthenticationException extends FhirException {
  AuthenticationException(super.message, {super.statusCode, super.originalError});
  
  @override
  String toString() => 'AuthenticationException: $message';
}

/// Token-related exceptions
class TokenException extends AuthenticationException {
  TokenException(super.message, {super.statusCode, super.originalError});
  
  @override
  String toString() => 'TokenException: $message';
}

/// Network-related exceptions
class NetworkException extends FhirException {
  NetworkException(super.message, {super.statusCode, super.originalError});
  
  @override
  String toString() => 'NetworkException: $message';
}

