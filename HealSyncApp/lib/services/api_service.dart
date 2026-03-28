import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/models/app_models.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _defaultBackendHost = '192.168.0.161:5000';

  static String get baseUrl => _buildCandidateBaseUrls().first;

  final http.Client _client;
  String? _activeBaseUrl;

  Future<UserProfile> signup({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final json = await _post(
      '/auth/signup',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role.apiValue,
      },
    );
    return UserProfile.fromApi(json['user'] as Map<String, dynamic>);
  }

  Future<UserProfile> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final json = await _post(
      '/auth/login',
      body: {'email': email, 'password': password, 'role': role.apiValue},
    );
    return UserProfile.fromApi(json['user'] as Map<String, dynamic>);
  }

  Future<List<UserProfile>> listUsers({UserRole? role}) async {
    final json = await _get(
      role == null ? '/auth/users' : '/auth/users?role=${role.apiValue}',
    );
    final items = (json['users'] as List<dynamic>? ?? const []);
    return items
        .whereType<Map<String, dynamic>>()
        .map(UserProfile.fromApi)
        .toList();
  }

  Future<UserProfile> getProfile({required String userId}) async {
    final json = await _get('/auth/profile', headers: {'x-user-id': userId});
    return UserProfile.fromApi(json['user'] as Map<String, dynamic>);
  }

  Future<UserProfile> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required int? age,
    required String gender,
    required String medicalHistory,
    required String specialization,
  }) async {
    final json = await _put(
      '/auth/profile',
      headers: {'x-user-id': userId},
      body: {
        'name': name,
        'phone': phone,
        'age': age,
        'gender': gender,
        'medicalHistory': medicalHistory,
        'specialization': specialization,
      },
    );
    return UserProfile.fromApi(json['user'] as Map<String, dynamic>);
  }

  Future<List<Appointment>> listAppointments({
    String? patientId,
    String? doctorId,
    String? clinicianId,
  }) async {
    final json = await _get(
      '/appointments${_queryString({'patientId': patientId, 'doctorId': doctorId, 'clinicianId': clinicianId})}',
    );
    final items = (json['appointments'] as List<dynamic>? ?? const []);
    return items
        .whereType<Map<String, dynamic>>()
        .map(Appointment.fromApi)
        .toList();
  }

  Future<Appointment> createAppointment({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    String status = 'Scheduled',
  }) async {
    final json = await _post(
      '/appointments',
      body: {
        'patientId': patientId,
        'doctorId': doctorId,
        'date': dateTime.toUtc().toIso8601String(),
        'status': status,
      },
    );
    return Appointment.fromApi(json['appointment'] as Map<String, dynamic>);
  }

  Future<Appointment> addAppointmentConsultant({
    required String appointmentId,
    required String consultantId,
  }) async {
    final json = await _post(
      '/appointments/$appointmentId/consultants',
      body: {'consultantId': consultantId},
    );
    return Appointment.fromApi(json['appointment'] as Map<String, dynamic>);
  }

  Future<List<MedicalRecord>> listRecords({
    String? patientId,
    String? doctorId,
  }) async {
    final json = await _get(
      '/records${_queryString({'patientId': patientId, 'doctorId': doctorId})}',
    );
    final items = (json['records'] as List<dynamic>? ?? const []);
    return items
        .whereType<Map<String, dynamic>>()
        .map(MedicalRecord.fromApi)
        .toList();
  }

  Future<MedicalRecord> createRecord({
    required String patientId,
    required String doctorId,
    required String fileName,
  }) async {
    final json = await _post(
      '/records',
      body: {
        'patientId': patientId,
        'doctorId': doctorId,
        'fileName': fileName,
      },
    );
    return MedicalRecord.fromApi(json['record'] as Map<String, dynamic>);
  }

  Future<List<Prescription>> listPrescriptions({
    required String patientId,
  }) async {
    final json = await _get('/prescriptions?patientId=$patientId');
    final items = (json['prescriptions'] as List<dynamic>? ?? const []);
    return items
        .whereType<Map<String, dynamic>>()
        .map(Prescription.fromApi)
        .toList();
  }

  Future<Prescription> createPrescription({
    required String patientId,
    required String doctorId,
    required String condition,
    required String medication,
    required String notes,
  }) async {
    final json = await _post(
      '/prescriptions',
      body: {
        'patientId': patientId,
        'doctorId': doctorId,
        'condition': condition,
        'medication': medication,
        'notes': notes,
      },
    );
    return Prescription.fromApi(json['prescription'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String> headers = const {},
  }) async {
    return _requestJson(
      path,
      send: (uri) => _client.get(uri, headers: headers),
    );
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const {},
  }) async {
    return _requestJson(
      path,
      send: (uri) => _client.post(
        uri,
        headers: {'Content-Type': 'application/json', ...headers},
        body: jsonEncode(body),
      ),
    );
  }

  Future<Map<String, dynamic>> _put(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String> headers = const {},
  }) async {
    return _requestJson(
      path,
      send: (uri) => _client.put(
        uri,
        headers: {'Content-Type': 'application/json', ...headers},
        body: jsonEncode(body),
      ),
    );
  }

  Future<Map<String, dynamic>> _requestJson(
    String path, {
    required Future<http.Response> Function(Uri uri) send,
  }) async {
    Exception? lastNetworkError;
    for (final baseUrl in _candidateBaseUrls) {
      final uri = Uri.parse('$baseUrl$path');
      try {
        final response = await send(uri);
        _activeBaseUrl = baseUrl;
        return _decode(response);
      } on Exception catch (error) {
        lastNetworkError = error;
      }
    }

    final attemptedUrls = _candidateBaseUrls.join(', ');
    throw Exception(
      'We could not reach the HealSync backend. Tried: $attemptedUrls. '
      'Start the backend and make sure the app can access port 5000.'
      '${lastNetworkError == null ? '' : ' Last error: $lastNetworkError'}',
    );
  }

  List<String> get _candidateBaseUrls =>
      _buildCandidateBaseUrls(activeBaseUrl: _activeBaseUrl);

  static List<String> _buildCandidateBaseUrls({String? activeBaseUrl}) {
    const override = String.fromEnvironment(
      'HEALSYNC_API_URL',
      defaultValue: '',
    );
    final urls = <String>[
      // ignore: use_null_aware_elements
      if (activeBaseUrl != null) activeBaseUrl,
      if (override.isNotEmpty) override,
      if (defaultTargetPlatform == TargetPlatform.android) ...[
        'http://127.0.0.1:5000/api',
        'http://10.0.2.2:5000/api',
      ],
      'http://$_defaultBackendHost/api',
    ];
    return urls.toSet().toList();
  }

  Map<String, dynamic> _decode(http.Response response) {
    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body['message']?.toString();
    throw Exception(
      message ??
          'The backend request failed with status ${response.statusCode}.',
    );
  }

  String _queryString(Map<String, String?> params) {
    final entries = params.entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .toList();
    if (entries.isEmpty) {
      return '';
    }

    final query = entries
        .map(
          (entry) =>
              '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value!)}',
        )
        .join('&');
    return '?$query';
  }

  void dispose() {
    _client.close();
  }
}
