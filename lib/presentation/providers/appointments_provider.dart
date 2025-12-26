import 'package:flutter/foundation.dart';
import 'package:mychart_fhir_app/core/errors/fhir_exceptions.dart';
import 'package:mychart_fhir_app/data/models/appointment_model.dart';
import 'package:mychart_fhir_app/data/services/fhir/fhir_service.dart';

/// Appointments Provider
/// 
/// Manages appointment data
class AppointmentsProvider extends ChangeNotifier {
  final FhirService _fhirService = FhirService();

  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get upcoming appointments
  List<AppointmentModel> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments
        .where((apt) => apt.start != null && apt.start!.isAfter(now))
        .toList()
      ..sort((a, b) {
        final aDate = a.start ?? DateTime(1970);
        final bDate = b.start ?? DateTime(1970);
        return aDate.compareTo(bDate); // Earliest first
      });
  }

  /// Get past appointments
  List<AppointmentModel> get pastAppointments {
    final now = DateTime.now();
    return _appointments
        .where((apt) => apt.start != null && apt.start!.isBefore(now))
        .toList()
      ..sort((a, b) {
        final aDate = a.start ?? DateTime(1970);
        final bDate = b.start ?? DateTime(1970);
        return bDate.compareTo(aDate); // Most recent first
      });
  }

  /// Load appointments
  Future<void> loadAppointments() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final appointmentsJson = await _fhirService.getAppointments();
      final entries = appointmentsJson['entry'] as List<dynamic>? ?? [];

      _appointments = entries
          .map((entry) => AppointmentModel.fromFhirJson(entry as Map<String, dynamic>))
          .toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is FhirException
          ? e.message
          : 'Failed to load appointments: ${e.toString()}';
      _appointments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear appointments data
  void clearAppointments() {
    _appointments = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

