import 'package:equatable/equatable.dart';

/// MedicationRequest Model
/// 
/// Represents FHIR MedicationRequest resource
class MedicationRequestModel extends Equatable {
  final String id;
  final String? medicationName; // Display name in English
  final String? status;
  final DateTime? authoredOn;
  final String? dosageInstruction;
  final String? prescriber;

  const MedicationRequestModel({
    required this.id,
    this.medicationName,
    this.status,
    this.authoredOn,
    this.dosageInstruction,
    this.prescriber,
  });

  /// Create MedicationRequestModel from FHIR MedicationRequest resource JSON
  factory MedicationRequestModel.fromFhirJson(Map<String, dynamic> json) {
    final resource = json['resource'] ?? json;
    final id = resource['id'] as String? ?? '';
    
    // Extract medication name
    final medicationCodeableConcept = resource['medicationCodeableConcept'] as Map<String, dynamic>?;
    String? medicationName;
    
    if (medicationCodeableConcept != null) {
      final coding = medicationCodeableConcept['coding'] as List<dynamic>?;
      if (coding != null && coding.isNotEmpty) {
        medicationName = (coding.first as Map<String, dynamic>)['display'] as String?;
      }
      // Fallback to text
      if (medicationName == null) {
        medicationName = medicationCodeableConcept['text'] as String?;
      }
    }
    
    // Extract status
    final status = resource['status'] as String?;
    
    // Extract authored date
    DateTime? authoredOn;
    final authoredOnString = resource['authoredOn'] as String?;
    if (authoredOnString != null) {
      authoredOn = DateTime.tryParse(authoredOnString);
    }
    
    // Extract dosage instruction
    final dosage = resource['dosageInstruction'] as List<dynamic>?;
    String? dosageInstruction;
    
    if (dosage != null && dosage.isNotEmpty) {
      final dosageObj = dosage.first as Map<String, dynamic>;
      final text = dosageObj['text'] as String?;
      dosageInstruction = text;
    }
    
    // Extract prescriber
    final requester = resource['requester'] as Map<String, dynamic>?;
    String? prescriber;
    
    if (requester != null) {
      prescriber = requester['display'] as String?;
    }
    
    return MedicationRequestModel(
      id: id,
      medicationName: medicationName,
      status: status,
      authoredOn: authoredOn,
      dosageInstruction: dosageInstruction,
      prescriber: prescriber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        medicationName,
        status,
        authoredOn,
        dosageInstruction,
        prescriber,
      ];
}

