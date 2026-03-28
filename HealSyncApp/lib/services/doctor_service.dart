import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/models/app_models.dart';
import 'api_service.dart';

class DoctorService {
  DoctorService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<DoctorDirectoryItem>> getDoctors({
    String? category,
    String? search,
  }) async {
    final query = <String, String>{};
    if (category != null && category.isNotEmpty && category != 'All') {
      query['category'] = category;
    }
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    final uri = Uri.parse('${ApiService.baseUrl}/doctors').replace(
      queryParameters: query.isEmpty ? null : query,
    );
    final response = await _client.get(uri);
    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(body['message']?.toString() ?? 'Unable to load doctors.');
    }

    final items = (body['doctors'] as List<dynamic>? ?? const []);
    return items
        .whereType<Map>()
        .map((item) => DoctorDirectoryItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
