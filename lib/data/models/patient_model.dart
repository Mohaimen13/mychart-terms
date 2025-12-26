import 'package:equatable/equatable.dart';

/// Patient Model
/// 
/// Represents FHIR Patient resource
class PatientModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final DateTime? birthDate;
  final String? gender;
  final String? phoneNumber;
  final String? email;
  final String? address;

  const PatientModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    this.email,
    this.address,
  });

  /// Create PatientModel from FHIR Patient resource JSON
  factory PatientModel.fromFhirJson(Map<String, dynamic> json) {
    final resource = json['resource'] ?? json;
    final id = resource['id'] as String? ?? '';
    
    // Extract name
    final names = resource['name'] as List<dynamic>?;
    String? firstName;
    String? lastName;
    String? fullName;
    
    if (names != null && names.isNotEmpty) {
      final name = names.first as Map<String, dynamic>;
      final given = name['given'] as List<dynamic>?;
      final family = name['family'] as String?;
      
      firstName = given?.isNotEmpty == true ? given.first as String : null;
      lastName = family;
      
      // Build full name
      final nameParts = <String>[];
      if (given != null) {
        nameParts.addAll(given.map((e) => e.toString()));
      }
      if (family != null) {
        nameParts.add(family);
      }
      fullName = nameParts.isNotEmpty ? nameParts.join(' ') : null;
    }
    
    // Extract birth date
    DateTime? birthDate;
    final birthDateString = resource['birthDate'] as String?;
    if (birthDateString != null) {
      birthDate = DateTime.tryParse(birthDateString);
    }
    
    // Extract gender
    final gender = resource['gender'] as String?;
    
    // Extract contact information
    final telecom = resource['telecom'] as List<dynamic>?;
    String? phoneNumber;
    String? email;
    
    if (telecom != null) {
      for (final contact in telecom) {
        final system = (contact as Map<String, dynamic>)['system'] as String?;
        final value = contact['value'] as String?;
        
        if (system == 'phone' && value != null) {
          phoneNumber = value;
        } else if (system == 'email' && value != null) {
          email = value;
        }
      }
    }
    
    // Extract address
    final addresses = resource['address'] as List<dynamic>?;
    String? address;
    
    if (addresses != null && addresses.isNotEmpty) {
      final addr = addresses.first as Map<String, dynamic>;
      final lines = addr['line'] as List<dynamic>?;
      final city = addr['city'] as String?;
      final state = addr['state'] as String?;
      final postalCode = addr['postalCode'] as String?;
      
      final addressParts = <String>[];
      if (lines != null) {
        addressParts.addAll(lines.map((e) => e.toString()));
      }
      if (city != null) addressParts.add(city);
      if (state != null) addressParts.add(state);
      if (postalCode != null) addressParts.add(postalCode);
      
      address = addressParts.isNotEmpty ? addressParts.join(', ') : null;
    }
    
    return PatientModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      birthDate: birthDate,
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        fullName,
        birthDate,
        gender,
        phoneNumber,
        email,
        address,
      ];
}

