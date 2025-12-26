import 'package:flutter/foundation.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/models/medication_request_model.dart';
import 'package:mychart_fhir_app/data/services/fhir/fhir_service.dart';

/// Medications Provider
/// 
/// Manages medication requests data
class MedicationsProvider extends ChangeNotifier {
  final FhirService _fhirService = FhirService();

  List<MedicationRequestModel> _medications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MedicationRequestModel> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load medications
  Future<void> loadMedications() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final medicationsJson = await _fhirService.getMedicationRequests();
      final entries = medicationsJson['entry'] as List<dynamic>? ?? [];

      _medications = entries
          .map((entry) => MedicationRequestModel.fromFhirJson(entry as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.authoredOn ?? DateTime(1970);
          final bDate = b.authoredOn ?? DateTime(1970);
          return bDate.compareTo(aDate); // Most recent first
        });

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is FhirException
          ? e.message
          : 'Failed to load medications: ${e.toString()}';
      _medications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear medications data
  void clearMedications() {
    _medications = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

