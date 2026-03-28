import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class RecordingStopResult {
  const RecordingStopResult({
    required this.filePath,
    required this.fileName,
    required this.duration,
  });

  final String filePath;
  final String fileName;
  final Duration duration;
}

class RecordingMetadata {
  const RecordingMetadata({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.filePath,
    required this.fileName,
    required this.date,
    required this.durationSeconds,
  });

  final String id;
  final String patientId;
  final String doctorId;
  final String filePath;
  final String fileName;
  final String date;
  final int durationSeconds;

  factory RecordingMetadata.fromJson(Map<String, dynamic> json) {
    final patient = json['patientId'];
    final doctor = json['doctorId'];
    return RecordingMetadata(
      id: (json['_id'] ?? '').toString(),
      patientId: patient is Map
          ? (patient['_id'] ?? '').toString()
          : (patient ?? '').toString(),
      doctorId: doctor is Map
          ? (doctor['_id'] ?? '').toString()
          : (doctor ?? '').toString(),
      filePath: (json['filePath'] ?? '').toString(),
      fileName: (json['fileName'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      durationSeconds: (json['duration'] ?? 0) as int,
    );
  }
}

class RecordingService {
  RecordingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<void> startRecording({required String channelId}) async {
    _isRecording = false;
    throw Exception(
      'Automatic consultation recording is not available in the current ZEGOCLOUD build.',
    );
  }

  Future<RecordingStopResult?> stopRecording() async {
    _isRecording = false;
    return null;
  }

  Future<RecordingMetadata> uploadRecording({
    required String patientId,
    required String doctorId,
    required RecordingStopResult result,
  }) async {
    final bytes = await File(result.filePath).readAsBytes();
    final response = await _client.post(
      Uri.parse('${ApiService.baseUrl}/uploadRecording'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patientId': patientId,
        'doctorId': doctorId,
        'fileName': result.fileName,
        'fileContent': base64Encode(bytes),
        'duration': result.duration.inSeconds,
        'date': DateTime.now().toIso8601String(),
      }),
    );

    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(body['message']?.toString() ?? 'Recording upload failed');
    }

    return RecordingMetadata.fromJson(
      Map<String, dynamic>.from(body['recording'] as Map),
    );
  }

  Future<List<RecordingMetadata>> getRecordings(String patientId) async {
    final response = await _client.get(
      Uri.parse('${ApiService.baseUrl}/recordings/$patientId'),
    );
    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        body['message']?.toString() ?? 'Unable to load recordings',
      );
    }

    final items = (body['recordings'] as List<dynamic>? ?? const []);
    return items
        .whereType<Map>()
        .map(
          (item) => RecordingMetadata.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
