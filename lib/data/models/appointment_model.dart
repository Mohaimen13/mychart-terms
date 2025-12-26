import 'package:equatable/equatable.dart';

/// Appointment Model
/// 
/// Represents FHIR Appointment resource
class AppointmentModel extends Equatable {
  final String id;
  final String? status;
  final DateTime? start;
  final DateTime? end;
  final String? description;
  final String? location;
  final String? practitioner;

  const AppointmentModel({
    required this.id,
    this.status,
    this.start,
    this.end,
    this.description,
    this.location,
    this.practitioner,
  });

  /// Create AppointmentModel from FHIR Appointment resource JSON
  factory AppointmentModel.fromFhirJson(Map<String, dynamic> json) {
    final resource = json['resource'] ?? json;
    final id = resource['id'] as String? ?? '';
    
    // Extract status
    final status = resource['status'] as String?;
    
    // Extract start and end times
    DateTime? start;
    DateTime? end;
    
    final startString = resource['start'] as String?;
    if (startString != null) {
      start = DateTime.tryParse(startString);
    }
    
    final endString = resource['end'] as String?;
    if (endString != null) {
      end = DateTime.tryParse(endString);
    }
    
    // Extract description
    final description = resource['description'] as String?;
    
    // Extract location
    final locations = resource['serviceType'] as List<dynamic>?;
    String? location;
    
    if (locations != null && locations.isNotEmpty) {
      final locationObj = locations.first as Map<String, dynamic>;
      location = locationObj['text'] as String?;
    }
    
    // Extract practitioner
    final participants = resource['participant'] as List<dynamic>?;
    String? practitioner;
    
    if (participants != null) {
      for (final participant in participants) {
        final actor = (participant as Map<String, dynamic>)['actor'] as Map<String, dynamic>?;
        if (actor != null) {
          final display = actor['display'] as String?;
          if (display != null) {
            practitioner = display;
            break;
          }
        }
      }
    }
    
    return AppointmentModel(
      id: id,
      status: status,
      start: start,
      end: end,
      description: description,
      location: location,
      practitioner: practitioner,
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        start,
        end,
        description,
        location,
        practitioner,
      ];
}

