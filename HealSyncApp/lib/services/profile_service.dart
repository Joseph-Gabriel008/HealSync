import 'package:http/http.dart' as http;

import '../core/models/app_models.dart';
import 'api_service.dart';

class ProfileService {
  ProfileService({http.Client? client}) : _api = ApiService(client: client);

  final ApiService _api;

  Future<UserProfile> getProfile(String userId) {
    return _api.getProfile(userId: userId);
  }

  Future<UserProfile> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required int? age,
    required String gender,
    required String medicalHistory,
    required String specialization,
  }) {
    return _api.updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      age: age,
      gender: gender,
      medicalHistory: medicalHistory,
      specialization: specialization,
    );
  }

  void dispose() {
    _api.dispose();
  }
}
