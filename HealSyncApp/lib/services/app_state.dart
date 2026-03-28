import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/app_models.dart';
import 'api_service.dart';

class AppState extends ChangeNotifier {
  AppState() : _apiService = ApiService();

  static const _storedCurrentUserKey = 'healsync.current_user';

  final ApiService _apiService;

  bool isBootstrapping = true;
  bool isBusy = false;
  String? fatalError;
  String? authError;
  String? authSuccess;
  UserProfile? currentUser;
  List<UserProfile> doctors = const [];
  List<UserProfile> patients = const [];
  List<Appointment> patientAppointments = const [];
  List<Appointment> doctorAppointments = const [];
  List<MedicalRecord> patientRecords = const [];
  List<MedicalRecord> doctorRecords = const [];
  List<Prescription> patientPrescriptions = const [];
  List<AuditEvent> auditTrail = const [];
  Set<String> doctorAccess = const {};

  final Set<String> _allDoctorAccess = {};

  List<MedicalRecord> get visibleRecords =>
      currentUser?.isDoctor ?? false ? doctorRecords : patientRecords;

  Future<void> bootstrap() async {
    try {
      await _restoreLocalSession();
      await _loadUsers();
      if (currentUser != null) {
        await _refreshAppData();
      }
      fatalError = null;
    } catch (error) {
      fatalError = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isBootstrapping = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required bool isSignup,
  }) async {
    isBusy = true;
    authError = null;
    authSuccess = null;
    notifyListeners();

    try {
      final user = isSignup
          ? await _apiService.signup(
              name: name.trim().isEmpty ? 'HealSync User' : name.trim(),
              email: email.trim().toLowerCase(),
              password: password,
              role: role,
            )
          : await _apiService.login(
              email: email.trim().toLowerCase(),
              password: password,
              role: role,
            );

      currentUser = user;
      await _persistCurrentUser();
      await _refreshAppData();
      authSuccess = isSignup
          ? 'Profile created successfully.'
          : 'Signed in successfully.';
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    isBusy = false;
    currentUser = null;
    authError = null;
    authSuccess = null;
    fatalError = null;
    patientAppointments = const [];
    doctorAppointments = const [];
    patientRecords = const [];
    doctorRecords = const [];
    patientPrescriptions = const [];
    auditTrail = const [];
    doctorAccess = const {};
    _allDoctorAccess.clear();
    await _clearCurrentUser();
    notifyListeners();

    try {
      await _loadUsers();
    } catch (_) {
      doctors = const [];
      patients = const [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshCurrentUserFromProfile(UserProfile profile) async {
    currentUser = profile;
    await _persistCurrentUser();
    await _refreshAppData();
    notifyListeners();
  }

  Future<void> refreshAppData() async {
    if (currentUser == null) {
      return;
    }

    isBusy = true;
    authError = null;
    notifyListeners();

    try {
      await _refreshAppData();
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> bookAppointment(String doctorId, DateTime dateTime) async {
    final patient = currentUser!;

    isBusy = true;
    authError = null;
    notifyListeners();

    try {
      await _apiService.createAppointment(
        patientId: patient.id,
        doctorId: doctorId,
        dateTime: dateTime,
      );
      await _refreshAppData();
      authSuccess = 'Appointment booked successfully.';
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<Appointment> requestEmergencyConsultant() async {
    final patient = currentUser;
    if (patient == null || patient.isDoctor) {
      throw Exception('Only patients can request an emergency consultant.');
    }
    if (doctors.isEmpty) {
      throw Exception('No consultant is available right now.');
    }

    isBusy = true;
    authError = null;
    authSuccess = null;
    notifyListeners();

    try {
      final consultant = _findEmergencyConsultant();
      final appointment = await _apiService.createAppointment(
        patientId: patient.id,
        doctorId: consultant.id,
        dateTime: DateTime.now(),
        status: 'Emergency consultant requested',
      );
      await _refreshAppData();
      authSuccess =
          'Emergency request sent to ${appointment.doctorName}. They can now accept the consultation.';
      return appointment;
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> uploadRecord({
    required String patientName,
    required String selectedFileName,
    required Uint8List bytes,
  }) async {
    final trimmedPatientName = patientName.trim();
    if (trimmedPatientName.isEmpty) {
      throw Exception('Enter the patient name before uploading the record.');
    }

    final user = currentUser!;
    final patient = user.isDoctor
        ? _findPatientByName(trimmedPatientName)
        : user;
    final doctor = user.isDoctor ? user : _defaultDoctor();

    if (patient == null) {
      throw Exception(
        'We could not find that patient in the backend yet. Ask the patient to sign up first, then try the upload again.',
      );
    }

    isBusy = true;
    authError = null;
    authSuccess = null;
    notifyListeners();

    try {
      await _apiService.createRecord(
        patientId: patient.id,
        doctorId: doctor.id,
        fileName: selectedFileName,
      );
      await _refreshAppData();
      authSuccess = 'Medical record saved successfully.';
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> toggleDoctorAccess(String patientId) async {
    final key = '${currentUser!.id}:$patientId';
    final granted = !_allDoctorAccess.contains(key);
    if (granted) {
      _allDoctorAccess.add(key);
    } else {
      _allDoctorAccess.remove(key);
    }
    doctorAccess = _allDoctorAccess
        .where((entry) => entry.startsWith('${currentUser!.id}:'))
        .map((entry) => entry.split(':').last)
        .toSet();
    notifyListeners();
  }

  bool hasDoctorAccess(String patientId) =>
      _allDoctorAccess.contains('${currentUser!.id}:$patientId');

  void clearAuthError() {
    if (authError == null) return;
    authError = null;
    notifyListeners();
  }

  void clearAuthSuccess() {
    if (authSuccess == null) return;
    authSuccess = null;
    notifyListeners();
  }

  Future<void> inviteConsultantToAppointment({
    required String appointmentId,
    required String consultantId,
  }) async {
    isBusy = true;
    authError = null;
    authSuccess = null;
    notifyListeners();

    try {
      await _apiService.addAppointmentConsultant(
        appointmentId: appointmentId,
        consultantId: consultantId,
      );
      await _refreshAppData();
      authSuccess = 'Consultant added successfully.';
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> updateMedicalHistory({required String medicalHistory}) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    isBusy = true;
    authError = null;
    authSuccess = null;
    notifyListeners();

    try {
      final updatedUser = await _apiService.updateProfile(
        userId: user.id,
        name: user.name,
        phone: user.phone,
        age: user.age,
        gender: user.gender,
        medicalHistory: medicalHistory,
        specialization: user.specialization,
      );
      currentUser = updatedUser;
      await _persistCurrentUser();
      await _refreshAppData();
      authSuccess = 'Medical history updated successfully.';
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> addQuickPrescription({
    required String patientId,
    required String condition,
    required String notes,
  }) async {
    final medication = notes
        .split('\n')
        .first
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
    final normalizedMedication = medication.isEmpty
        ? 'Consultation prescription'
        : medication;

    isBusy = true;
    authError = null;
    authSuccess = null;
    notifyListeners();

    try {
      await _apiService.createPrescription(
        patientId: patientId,
        doctorId: currentUser!.id,
        condition: condition.trim(),
        medication: normalizedMedication,
        notes: notes.trim(),
      );
      await _refreshAppData();
      authSuccess = 'Consultation notes saved successfully.';
    } catch (error) {
      authError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> _loadUsers() async {
    doctors = await _apiService.listUsers(role: UserRole.doctor);
    patients = await _apiService.listUsers(role: UserRole.patient);
  }

  Future<void> _refreshAppData() async {
    await _loadUsers();

    final user = currentUser;
    if (user == null) {
      return;
    }

    if (user.isDoctor) {
      doctorAppointments = await _apiService.listAppointments(
        clinicianId: user.id,
      );
      doctorRecords = await _apiService.listRecords(doctorId: user.id);
      patientAppointments = const [];
      patientRecords = const [];
      patientPrescriptions = const [];
      doctorAccess = _allDoctorAccess
          .where((entry) => entry.startsWith('${user.id}:'))
          .map((entry) => entry.split(':').last)
          .toSet();
      auditTrail = _buildAuditTrail(
        appointments: doctorAppointments,
        records: doctorRecords,
        prescriptions: const [],
      );
    } else {
      patientAppointments = await _apiService.listAppointments(
        patientId: user.id,
      );
      patientRecords = await _apiService.listRecords(patientId: user.id);
      patientPrescriptions = await _apiService.listPrescriptions(
        patientId: user.id,
      );
      doctorAppointments = const [];
      doctorRecords = const [];
      doctorAccess = const {};
      auditTrail = _buildAuditTrail(
        appointments: patientAppointments,
        records: patientRecords,
        prescriptions: patientPrescriptions,
      );
    }
  }

  Future<void> _restoreLocalSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(_storedCurrentUserKey);
    if (rawUser == null || rawUser.isEmpty) {
      return;
    }

    final decoded = jsonDecode(rawUser);
    if (decoded is! Map<String, dynamic>) {
      return;
    }
    currentUser = UserProfile.fromJson(decoded);
  }

  Future<void> _persistCurrentUser() async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storedCurrentUserKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storedCurrentUserKey);
  }

  List<AuditEvent> _buildAuditTrail({
    required List<Appointment> appointments,
    required List<MedicalRecord> records,
    required List<Prescription> prescriptions,
  }) {
    final events = <AuditEvent>[
      for (final appointment in appointments)
        AuditEvent(
          id: 'appointment-${appointment.id}',
          actorName: appointment.doctorName,
          action:
              'Appointment scheduled for ${appointment.patientName} with ${appointment.doctorName}',
          timestamp: appointment.dateTime,
        ),
      for (final record in records)
        AuditEvent(
          id: 'record-${record.id}',
          actorName: record.doctorName,
          action: 'Medical record ${record.fileName} saved to the backend',
          timestamp: record.uploadedAt,
        ),
      for (final prescription in prescriptions)
        AuditEvent(
          id: 'prescription-${prescription.id}',
          actorName: prescription.doctorName,
          action: 'Prescription ${prescription.medication} added',
          timestamp: prescription.createdAt,
        ),
    ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return events;
  }

  UserProfile? _findPatientByName(String name) {
    final normalized = name.trim().toLowerCase();
    for (final patient in patients) {
      if (patient.name.trim().toLowerCase() == normalized) {
        return patient;
      }
    }
    return null;
  }

  UserProfile _findEmergencyConsultant() {
    final now = DateTime.now();
    final appointmentCountByDoctor = <String, int>{
      for (final doctor in doctors) doctor.id: 0,
    };
    final busyDoctorIds = <String>{};

    for (final appointment in doctorAppointments) {
      appointmentCountByDoctor.update(
        appointment.doctorId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      final difference = appointment.dateTime.difference(now).inMinutes.abs();
      if (difference <= 45) {
        busyDoctorIds.add(appointment.doctorId);
      }
    }

    final availableDoctors =
        doctors.where((doctor) => !busyDoctorIds.contains(doctor.id)).toList()
          ..sort(
            (a, b) => (appointmentCountByDoctor[a.id] ?? 0).compareTo(
              appointmentCountByDoctor[b.id] ?? 0,
            ),
          );

    if (availableDoctors.isNotEmpty) {
      return availableDoctors.first;
    }

    final fallbackDoctors = [...doctors]
      ..sort(
        (a, b) => (appointmentCountByDoctor[a.id] ?? 0).compareTo(
          appointmentCountByDoctor[b.id] ?? 0,
        ),
      );
    return fallbackDoctors.first;
  }

  UserProfile _defaultDoctor() {
    if (doctors.isEmpty) {
      throw Exception(
        'No doctor account exists in the backend yet. Create a doctor account first, then upload the record again.',
      );
    }
    return doctors.first;
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
