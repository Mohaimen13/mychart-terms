import 'package:dio/dio.dart';
import 'package:mychart_fhir_app/core/config/epic_config.dart';
import 'package:mychart_fhir_app/core/constants/app_constants.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/services/auth/epic_auth_service.dart';
import 'package:mychart_fhir_app/data/services/storage/secure_storage_service.dart';

/// FHIR Service Layer
/// 
/// Isolated service for all FHIR API calls.
/// Handles authentication, error handling, and data transformation.
class FhirService {
  final EpicAuthService _authService = EpicAuthService();
  final SecureStorageService _storageService = SecureStorageService();
  late final Dio _dio;

  FhirService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EpicConfig.baseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {
          'Accept': 'application/fhir+json',
          'Content-Type': 'application/fhir+json',
        },
      ),
    );

    // Add interceptor for automatic token injection
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getValidAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token expired or invalid
            throw AuthenticationException(
              'Authentication required',
              statusCode: 401,
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Generic method to fetch FHIR resources
  Future<Map<String, dynamic>> _fetchResource(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw FhirException(
          'Failed to fetch resource: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(
          'Request timeout',
          statusCode: e.response?.statusCode,
          originalError: e,
        );
      }
      throw FhirException(
        'Network error: ${e.message}',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    } catch (e) {
      if (e is FhirException) rethrow;
      throw FhirException(
        'Unexpected error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Fetch Patient resource
  /// 
  /// [patientId]: The patient ID (optional, defaults to authenticated patient)
  Future<Map<String, dynamic>> getPatient({String? patientId}) async {
    final id = patientId ?? await _storageService.getPatientId();
    if (id == null) {
      throw FhirException('Patient ID not available');
    }
    return await _fetchResource('${EpicConfig.patientEndpoint}/$id');
  }

  /// Fetch Observation resources (Labs & Vitals)
  /// 
  /// [patientId]: The patient ID (optional)
  /// [category]: Filter by category (e.g., 'laboratory', 'vital-signs')
  Future<Map<String, dynamic>> getObservations({
    String? patientId,
    String? category,
  }) async {
    final id = patientId ?? await _storageService.getPatientId();
    if (id == null) {
      throw FhirException('Patient ID not available');
    }

    final queryParams = <String, dynamic>{
      'patient': id,
    };
    
    if (category != null) {
      queryParams['category'] = category;
    }

    return await _fetchResource(EpicConfig.observationEndpoint, queryParams: queryParams);
  }

  /// Fetch MedicationRequest resources
  /// 
  /// [patientId]: The patient ID (optional)
  Future<Map<String, dynamic>> getMedicationRequests({String? patientId}) async {
    final id = patientId ?? await _storageService.getPatientId();
    if (id == null) {
      throw FhirException('Patient ID not available');
    }

    return await _fetchResource(
      EpicConfig.medicationRequestEndpoint,
      queryParams: {'patient': id},
    );
  }

  /// Fetch Appointment resources
  /// 
  /// [patientId]: The patient ID (optional)
  Future<Map<String, dynamic>> getAppointments({String? patientId}) async {
    final id = patientId ?? await _storageService.getPatientId();
    if (id == null) {
      throw FhirException('Patient ID not available');
    }

    return await _fetchResource(
      EpicConfig.appointmentEndpoint,
      queryParams: {'patient': id},
    );
  }
}

