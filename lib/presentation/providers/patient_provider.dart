import 'package:flutter/foundation.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/models/patient_model.dart';
import 'package:mychart_fhir_app/data/services/fhir/fhir_service.dart';

/// Patient Data Provider
/// 
/// Manages patient information and related FHIR resources
class PatientProvider extends ChangeNotifier {
  final FhirService _fhirService = FhirService();

  PatientModel? _patient;
  bool _isLoading = false;
  String? _errorMessage;

  PatientModel? get patient => _patient;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPatient => _patient != null;

  /// Load patient information
  Future<void> loadPatient() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final patientJson = await _fhirService.getPatient();
      _patient = PatientModel.fromFhirJson(patientJson);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is FhirException
          ? e.message
          : 'Failed to load patient: ${e.toString()}';
      _patient = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear patient data
  void clearPatient() {
    _patient = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

