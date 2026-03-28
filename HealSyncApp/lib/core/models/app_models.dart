enum UserRole { patient, doctor }

extension UserRoleX on UserRole {
  String get label => this == UserRole.patient ? 'Patient' : 'Doctor';

  String get apiValue => name;

  static UserRole fromApiValue(String value) {
    return value.trim().toLowerCase() == 'doctor'
        ? UserRole.doctor
        : UserRole.patient;
  }
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.memberId,
    this.phone = '',
    this.age,
    this.gender = '',
    this.medicalHistory = '',
    this.specialization = '',
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String memberId;
  final String phone;
  final int? age;
  final String gender;
  final String medicalHistory;
  final String specialization;

  bool get isDoctor => role == UserRole.doctor;

  factory UserProfile.fromApi(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final role = UserRoleX.fromApiValue((json['role'] ?? 'patient').toString());
    final suffix = id.length >= 6
        ? id.substring(id.length - 6).toUpperCase()
        : id.toUpperCase();
    final prefix = role == UserRole.doctor ? 'DOC' : 'PAT';

    return UserProfile(
      id: id,
      name: (json['name'] ?? 'HealSync User').toString(),
      email: (json['email'] ?? '').toString(),
      role: role,
      memberId: '$prefix-$suffix',
      phone: (json['phone'] ?? '').toString(),
      age: json['age'] is num
          ? (json['age'] as num).toInt()
          : int.tryParse('${json['age'] ?? ''}'),
      gender: (json['gender'] ?? '').toString(),
      medicalHistory: (json['medicalHistory'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'HealSync User').toString(),
      email: (json['email'] ?? '').toString(),
      role: UserRoleX.fromApiValue((json['role'] ?? 'patient').toString()),
      memberId: (json['memberId'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      age: json['age'] is num
          ? (json['age'] as num).toInt()
          : int.tryParse('${json['age'] ?? ''}'),
      gender: (json['gender'] ?? '').toString(),
      medicalHistory: (json['medicalHistory'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.apiValue,
      'memberId': memberId,
      'phone': phone,
      'age': age,
      'gender': gender,
      'medicalHistory': medicalHistory,
      'specialization': specialization,
    };
  }
}

class Appointment {
  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    required this.dateTime,
    required this.status,
    this.consultantIds = const [],
    this.consultantNames = const [],
  });

  final String id;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String doctorName;
  final DateTime dateTime;
  final String status;
  final List<String> consultantIds;
  final List<String> consultantNames;

  factory Appointment.fromApi(Map<String, dynamic> json) {
    final patient = _readNestedMap(json['patientId']);
    final doctor = _readNestedMap(json['doctorId']);
    final consultants = (json['consultantIds'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return Appointment(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      patientId: _readNestedId(json['patientId']),
      doctorId: _readNestedId(json['doctorId']),
      patientName: (patient['name'] ?? 'Patient').toString(),
      doctorName: 'Dr. ${(doctor['name'] ?? 'Doctor').toString()}',
      dateTime: DateTime.parse(
        (json['date'] ?? json['dateTime']).toString(),
      ).toLocal(),
      status: (json['status'] ?? 'Scheduled').toString(),
      consultantIds: consultants
          .map((consultant) => _readNestedId(consultant))
          .where((id) => id.isNotEmpty)
          .toList(),
      consultantNames: consultants
          .map((consultant) => (consultant['name'] ?? '').toString())
          .where((name) => name.isNotEmpty)
          .map((name) => 'Dr. $name')
          .toList(),
    );
  }
}

class MedicalRecord {
  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.fileName,
    required this.referenceCode,
    required this.verified,
    required this.uploadedAt,
    required this.accessedBy,
    required this.patientName,
    required this.doctorName,
    required this.sourceLabel,
  });

  final String id;
  final String patientId;
  final String doctorId;
  final String fileName;
  final String referenceCode;
  final bool verified;
  final DateTime uploadedAt;
  final List<String> accessedBy;
  final String patientName;
  final String doctorName;
  final String sourceLabel;

  factory MedicalRecord.fromApi(Map<String, dynamic> json) {
    final patient = _readNestedMap(json['patientId']);
    final doctor = _readNestedMap(json['doctorId']);
    final id = (json['_id'] ?? json['id'] ?? '').toString();

    return MedicalRecord(
      id: id,
      patientId: _readNestedId(json['patientId']),
      doctorId: _readNestedId(json['doctorId']),
      fileName: (json['fileName'] ?? '').toString(),
      referenceCode:
          'REC-${id.length >= 6 ? id.substring(id.length - 6).toUpperCase() : id.toUpperCase()}',
      verified: json['verified'] == true,
      uploadedAt: DateTime.parse(
        (json['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
      ).toLocal(),
      accessedBy: [
        if ((doctor['name'] ?? '').toString().isNotEmpty)
          doctor['name'].toString(),
        if ((patient['name'] ?? '').toString().isNotEmpty)
          patient['name'].toString(),
      ],
      patientName: (patient['name'] ?? 'Patient').toString(),
      doctorName: (doctor['name'] ?? 'Doctor').toString(),
      sourceLabel: 'MongoDB + mock blockchain',
    );
  }
}

class Prescription {
  const Prescription({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.medication,
    required this.notes,
    required this.createdAt,
    this.patientName = 'Patient',
    this.condition = '',
  });

  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String medication;
  final String notes;
  final DateTime createdAt;
  final String patientName;
  final String condition;

  factory Prescription.fromApi(Map<String, dynamic> json) {
    final doctor = _readNestedMap(json['doctorId']);
    final patient = _readNestedMap(json['patientId']);

    return Prescription(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      patientId: _readNestedId(json['patientId']),
      doctorId: _readNestedId(json['doctorId']),
      doctorName: 'Dr. ${(doctor['name'] ?? 'Doctor').toString()}',
      medication: (json['medication'] ?? 'Prescription').toString(),
      notes: (json['notes'] ?? '').toString(),
      createdAt: DateTime.parse(
        (json['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
      ).toLocal(),
      patientName: (patient['name'] ?? 'Patient').toString(),
      condition: (json['condition'] ?? '').toString(),
    );
  }
}

class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.actorName,
    required this.action,
    required this.timestamp,
  });

  final String id;
  final String actorName;
  final String action;
  final DateTime timestamp;
}

class DoctorDirectoryItem {
  const DoctorDirectoryItem({
    required this.id,
    required this.name,
    required this.specialization,
    required this.category,
    required this.experience,
    required this.rating,
    required this.image,
  });

  final String id;
  final String name;
  final String specialization;
  final String category;
  final String experience;
  final double rating;
  final String image;

  factory DoctorDirectoryItem.fromJson(Map<String, dynamic> json) {
    return DoctorDirectoryItem(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Doctor').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      experience: (json['experience'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      image: (json['image'] ?? '').toString(),
    );
  }
}

Map<String, dynamic> _readNestedMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

String _readNestedId(dynamic value) {
  if (value is Map<String, dynamic>) {
    return (value['_id'] ?? value['id'] ?? '').toString();
  }
  return (value ?? '').toString();
}
