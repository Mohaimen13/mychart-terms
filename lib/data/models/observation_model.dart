import 'package:equatable/equatable.dart';

/// Observation Model
/// 
/// Represents FHIR Observation resource (Labs & Vitals)
class ObservationModel extends Equatable {
  final String id;
  final String? code;
  final String? displayName; // LOINC name in English
  final String? category; // e.g., 'laboratory', 'vital-signs'
  final DateTime? effectiveDateTime;
  final String? value;
  final String? unit;
  final String? status;

  const ObservationModel({
    required this.id,
    this.code,
    this.displayName,
    this.category,
    this.effectiveDateTime,
    this.value,
    this.unit,
    this.status,
  });

  /// Create ObservationModel from FHIR Observation resource JSON
  factory ObservationModel.fromFhirJson(Map<String, dynamic> json) {
    final resource = json['resource'] ?? json;
    final id = resource['id'] as String? ?? '';
    
    // Extract code and display name
    final codeObj = resource['code'] as Map<String, dynamic>?;
    String? code;
    String? displayName;
    
    if (codeObj != null) {
      final coding = codeObj['coding'] as List<dynamic>?;
      if (coding != null && coding.isNotEmpty) {
        final firstCoding = coding.first as Map<String, dynamic>;
        code = firstCoding['code'] as String?;
        displayName = firstCoding['display'] as String?;
      }
    }
    
    // Extract category
    final categories = resource['category'] as List<dynamic>?;
    String? category;
    if (categories != null && categories.isNotEmpty) {
      final cat = categories.first as Map<String, dynamic>;
      final catCoding = cat['coding'] as List<dynamic>?;
      if (catCoding != null && catCoding.isNotEmpty) {
        category = (catCoding.first as Map<String, dynamic>)['code'] as String?;
      }
    }
    
    // Extract effective date
    DateTime? effectiveDateTime;
    final effectiveDateString = resource['effectiveDateTime'] as String?;
    if (effectiveDateString != null) {
      effectiveDateTime = DateTime.tryParse(effectiveDateString);
    }
    
    // Extract value
    final valueQuantity = resource['valueQuantity'] as Map<String, dynamic>?;
    String? value;
    String? unit;
    
    if (valueQuantity != null) {
      value = valueQuantity['value']?.toString();
      unit = valueQuantity['unit'] as String?;
    } else {
      // Try valueString as fallback
      value = resource['valueString'] as String?;
    }
    
    // Extract status
    final status = resource['status'] as String?;
    
    return ObservationModel(
      id: id,
      code: code,
      displayName: displayName,
      category: category,
      effectiveDateTime: effectiveDateTime,
      value: value,
      unit: unit,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        code,
        displayName,
        category,
        effectiveDateTime,
        value,
        unit,
        status,
      ];
}

