import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class RecordHistoryItem {
  const RecordHistoryItem({
    required this.id,
    required this.patientName,
    required this.file,
    required this.fileName,
    required this.condition,
    required this.prescription,
    required this.date,
  });

  final String id;
  final String patientName;
  final String file;
  final String fileName;
  final String condition;
  final String prescription;
  final String date;

  bool get hasFile => file.isNotEmpty;

  bool get isImage {
    final source = fileName.isNotEmpty ? fileName : file;
    final lower = source.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg');
  }

  bool get isPdf {
    final source = fileName.isNotEmpty ? fileName : file;
    return source.toLowerCase().endsWith('.pdf');
  }

  String get fileUrl {
    if (file.startsWith('http://') || file.startsWith('https://')) {
      return file;
    }

    final root = ApiService.baseUrl.endsWith('/api')
        ? ApiService.baseUrl.substring(0, ApiService.baseUrl.length - 4)
        : ApiService.baseUrl;
    return '$root$file';
  }

  factory RecordHistoryItem.fromJson(Map<String, dynamic> json) {
    return RecordHistoryItem(
      id: (json['id'] ?? '').toString(),
      patientName: (json['patientName'] ?? 'Patient').toString(),
      file: (json['file'] ?? '').toString(),
      fileName: (json['fileName'] ?? '').toString(),
      condition: (json['condition'] ?? '').toString(),
      prescription: (json['prescription'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
    );
  }
}

class RecordService {
  RecordService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<RecordHistoryItem>> getRecords(String patientId) async {
    final response = await _client.get(
      Uri.parse('${ApiService.baseUrl}/records/$patientId'),
    );
    final body = _decode(response);
    if (body is! List) {
      return const [];
    }

    return body
        .whereType<Map>()
        .map((item) => RecordHistoryItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<RecordHistoryItem> addRecord({
    required String patientId,
    required String doctorId,
    required String patientName,
    required String condition,
    required String prescription,
    String? fileName,
    Uint8List? fileBytes,
  }) async {
    final response = await _client.post(
      Uri.parse('${ApiService.baseUrl}/records/addMedicalRecord'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patientId': patientId,
        'doctorId': doctorId,
        'patientName': patientName,
        'condition': condition,
        'prescription': prescription,
        'file': fileName,
        'fileContent': fileBytes == null ? null : base64Encode(fileBytes),
      }),
    );

    final body = _decode(response);
    return RecordHistoryItem.fromJson(
      Map<String, dynamic>.from(body['record'] as Map),
    );
  }

  dynamic _decode(http.Response response) {
    final body = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    if (body is Map<String, dynamic>) {
      throw Exception(body['message']?.toString() ?? 'Record request failed.');
    }
    throw Exception('Record request failed.');
  }

  void dispose() {
    _client.close();
  }
}
