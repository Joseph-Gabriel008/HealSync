import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class ChatService {
  ChatService({http.Client? client}) : _client = client ?? http.Client();

  static const String safetyMessage =
      'This is general guidance. Consult a doctor.';
  static const String severeWarning = '';

  static Uri get _chatUri {
    const override = String.fromEnvironment(
      'HEALSYNC_CHAT_URL',
      defaultValue: '',
    );
    if (override.isNotEmpty) {
      return Uri.parse(override);
    }

    return Uri.parse('${ApiService.baseUrl}/chat');
  }

  static const List<String> _severityKeywords = <String>[
    'chest pain',
    'breathing issue',
    'breathing problem',
    'difficulty breathing',
    'shortness of breath',
    'unconscious',
    'severe pain',
  ];

  final http.Client _client;

  Future<ChatbotResponse> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      throw Exception('Message is required.');
    }

    http.Response response;
    try {
      response = await _client
          .post(
            _chatUri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(<String, String>{'message': trimmedMessage}),
          )
          .timeout(const Duration(seconds: 30));
    } on Exception {
      throw Exception('Try again. Unable to reach ${_chatUri.toString()}');
    }

    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(body['message']?.toString() ?? 'Try again');
    }

    var reply = body['reply']?.toString().trim() ?? '';
    final replyLanguage = _normalizeLanguageCode(
      body['replyLanguage']?.toString(),
    );
    final isSevere =
        body['isSevere'] == true || _containsSevereTerms(trimmedMessage);
    final shouldConsultDoctor = body['shouldConsultDoctor'] == true || isSevere;

    if (reply.isEmpty) {
      throw Exception('Try again');
    }

    final localizedSafetyMessage = _safetyMessageFor(replyLanguage);
    final localizedSevereWarning = _severeWarningFor(replyLanguage);

    if (!reply.contains(localizedSafetyMessage)) {
      reply = '$reply\n\n$localizedSafetyMessage';
    }

    if (isSevere && !reply.contains(localizedSevereWarning)) {
      reply = '$localizedSevereWarning\n\n$reply';
    }

    return ChatbotResponse(
      text: reply,
      shouldConsultDoctor: shouldConsultDoctor,
      isSevere: isSevere,
      languageCode: replyLanguage,
    );
  }

  Future<ChatbotResponse> analyzeImage({String? fileName}) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    final imageLabel = fileName == null || fileName.trim().isEmpty
        ? 'the uploaded image'
        : fileName.trim();

    return ChatbotResponse(
      text:
          'Possible condition:\nMild skin irritation or rash\n\nImmediate care:\n- Keep the area clean and dry.\n- Avoid scratching or applying harsh products.\n- Observe for redness, swelling, or spreading.\n\nAfter care:\n- Monitor the area over the next 24 to 48 hours.\n- Seek a doctor review if the skin changes worsen.\n\nRecovery time:\n- Minor irritation may settle in a few days, but worsening symptoms should be checked sooner.\n\nWarning signs:\n- Spreading redness\n- Fever\n- Painful swelling\n\nImage placeholder note:\nThis is a basic placeholder review for $imageLabel and not a diagnosis.\n\n$safetyMessage',
      shouldConsultDoctor: true,
    );
  }

  static bool _containsSevereTerms(String message) {
    final normalized = message.toLowerCase();
    return _severityKeywords.any(normalized.contains);
  }

  static String _normalizeLanguageCode(String? value) {
    final normalized = (value ?? '').trim().toLowerCase();
    if (normalized == 'ta') {
      return 'ta';
    }
    return 'en';
  }

  static String _safetyMessageFor(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return '??? ??????? ???????????? ???????. ?????????? ????????.';
      default:
        return safetyMessage;
    }
  }

  static String _severeWarningFor(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return '?? ???? ?????????? ????????';
      default:
        return '?? Consult doctor immediately';
    }
  }

  void dispose() {
    _client.close();
  }
}

class ChatbotResponse {
  const ChatbotResponse({
    required this.text,
    this.shouldConsultDoctor = false,
    this.isSevere = false,
    this.languageCode = 'en',
  });

  final String text;
  final bool shouldConsultDoctor;
  final bool isSevere;
  final String languageCode;

  String toDisplayMessage() => text;

  String toSpeakText() => text.replaceAll('\n', '. ');
}
