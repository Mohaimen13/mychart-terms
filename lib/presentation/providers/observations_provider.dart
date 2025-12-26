import 'package:flutter/foundation.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/models/observation_model.dart';
import 'package:mychart_fhir_app/data/services/fhir/fhir_service.dart';

/// Observations Provider
/// 
/// Manages labs and vitals data
class ObservationsProvider extends ChangeNotifier {
  final FhirService _fhirService = FhirService();

  List<ObservationModel> _observations = [];
  List<ObservationModel> _labs = [];
  List<ObservationModel> _vitals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ObservationModel> get observations => _observations;
  List<ObservationModel> get labs => _labs;
  List<ObservationModel> get vitals => _vitals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all observations
  Future<void> loadObservations() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final observationsJson = await _fhirService.getObservations();
      final entries = observationsJson['entry'] as List<dynamic>? ?? [];

      _observations = entries
          .map((entry) => ObservationModel.fromFhirJson(entry as Map<String, dynamic>))
          .toList();

      // Separate labs and vitals
      _labs = _observations
          .where((obs) => obs.category == 'laboratory')
          .toList()
        ..sort((a, b) {
          final aDate = a.effectiveDateTime ?? DateTime(1970);
          final bDate = b.effectiveDateTime ?? DateTime(1970);
          return bDate.compareTo(aDate); // Most recent first
        });

      _vitals = _observations
          .where((obs) => obs.category == 'vital-signs')
          .toList()
        ..sort((a, b) {
          final aDate = a.effectiveDateTime ?? DateTime(1970);
          final bDate = b.effectiveDateTime ?? DateTime(1970);
          return bDate.compareTo(aDate); // Most recent first
        });

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is FhirException
          ? e.message
          : 'Failed to load observations: ${e.toString()}';
      _observations = [];
      _labs = [];
      _vitals = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load only labs
  Future<void> loadLabs() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final observationsJson = await _fhirService.getObservations(category: 'laboratory');
      final entries = observationsJson['entry'] as List<dynamic>? ?? [];

      _labs = entries
          .map((entry) => ObservationModel.fromFhirJson(entry as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.effectiveDateTime ?? DateTime(1970);
          final bDate = b.effectiveDateTime ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is FhirException
          ? e.message
          : 'Failed to load labs: ${e.toString()}';
      _labs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load only vitals
  Future<void> loadVitals() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final observationsJson = await _fhirService.getObservations(category: 'vital-signs');
      final entries = observationsJson['entry'] as List<dynamic>? ?? [];

      _vitals = entries
          .map((entry) => ObservationModel.fromFhirJson(entry as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.effectiveDateTime ?? DateTime(1970);
          final bDate = b.effectiveDateTime ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is FhirException
          ? e.message
          : 'Failed to load vitals: ${e.toString()}';
      _vitals = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear observations data
  void clearObservations() {
    _observations = [];
    _labs = [];
    _vitals = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

