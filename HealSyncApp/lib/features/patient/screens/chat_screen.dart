import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../services/chat_service.dart';
import '../../../services/permission_service.dart';
import '../../doctor/screens/doctor_list_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final PermissionService _permissionService = PermissionService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  final List<_ChatMessage> _messages = <_ChatMessage>[
    _ChatMessage.bot(
      text:
          'Share your symptoms by text, voice, or image. I will return structured guidance with possible condition, immediate care, after care, recovery time, and warning signs.\n\n${ChatService.safetyMessage}',
      showConsultDoctorAction: true,
    ),
  ];

  bool _speechReady = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _speechInitializing = false;
  bool _voiceAutoSending = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeSpeech());
    unawaited(_configureTts());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    unawaited(_speech.stop());
    unawaited(_tts.stop());
    _chatService.dispose();
    super.dispose();
  }

  Future<void> _configureTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.46);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      _tts.setStartHandler(() {
        if (!mounted) {
          return;
        }
        setState(() {
          _isSpeaking = true;
        });
      });
      _tts.setCompletionHandler(() {
        if (!mounted) {
          return;
        }
        setState(() {
          _isSpeaking = false;
        });
      });
      _tts.setErrorHandler((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isSpeaking = false;
        });
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _initializeSpeech() async {
    if (_speechInitializing) {
      return;
    }

    _speechInitializing = true;
    try {
      final available = await _speech.initialize(
        onStatus: _handleSpeechStatus,
        onError: _handleSpeechError,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _speechReady = available;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _speechReady = false;
        _isListening = false;
      });
    } finally {
      _speechInitializing = false;
    }
  }

  void _handleSpeechStatus(String status) {
    if (!mounted) {
      return;
    }

    if (status == 'done' || status == 'notListening') {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _handleSpeechError(SpeechRecognitionError error) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isListening = false;
    });
    _showMessage('Voice input failed. Please retry.');
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (!mounted) {
        return;
      }
      setState(() {
        _isListening = false;
      });
      return;
    }

    await _tts.stop();
    if (!mounted) {
      return;
    }
    setState(() {
      _isSpeaking = false;
    });

    final permissionResult = await _permissionService
        .requestMicrophonePermission();
    if (!mounted) {
      return;
    }

    switch (permissionResult) {
      case PermissionRequestResult.granted:
        break;
      case PermissionRequestResult.denied:
        _showMessage(
          'Microphone permission is needed for voice input. Please retry.',
        );
        return;
      case PermissionRequestResult.permanentlyDenied:
        _showOpenSettingsMessage();
        return;
    }

    if (!_speechReady) {
      await _initializeSpeech();
    }

    if (!_speechReady) {
      _showMessage(
        'Voice input is not available right now. Please type your symptoms instead.',
      );
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (!mounted) {
            return;
          }

          final spokenText = result.recognizedWords.trim();
          if (spokenText.isEmpty) {
            return;
          }

          _messageController.value = TextEditingValue(
            text: spokenText,
            selection: TextSelection.collapsed(offset: spokenText.length),
          );

          if (result.finalResult && !_voiceAutoSending) {
            _voiceAutoSending = true;
            setState(() {
              _isListening = false;
            });
            unawaited(_submitRecognizedInput(spokenText));
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        listenOptions: stt.SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
          listenMode: stt.ListenMode.dictation,
        ),
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _isListening = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isListening = false;
      });
      _showMessage('Voice input failed. Please retry.');
    }
  }

  Future<void> _submitRecognizedInput(String input) async {
    try {
      await _speech.stop();
      if (!mounted) {
        return;
      }
      _messageController.clear();
      await _submitInput(input);
    } finally {
      _voiceAutoSending = false;
    }
  }

  Future<void> _sendMessage() async {
    final input = _messageController.text.trim();
    _messageController.clear();
    await _submitInput(input);
  }

  Future<void> _submitInput(String input) async {
    final trimmedInput = input.trim();
    if (trimmedInput.isEmpty) {
      _showMessage('Enter your symptoms before sending.');
      return;
    }

    await _tts.stop();
    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
    }

    _appendMessage(_ChatMessage.user(text: trimmedInput));
    final loadingId = _appendMessage(
      _ChatMessage.loading(text: 'Reviewing your symptoms...'),
    );

    try {
      final response = await _chatService.sendMessage(trimmedInput);
      if (!mounted) {
        return;
      }

      _replaceMessage(
        loadingId,
        _ChatMessage.bot(
          text: response.toDisplayMessage(),
          showConsultDoctorAction: response.shouldConsultDoctor,
        ),
      );
      unawaited(
        speakResponse(
          response.toSpeakText(),
          languageCode: response.languageCode,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = error.toString().replaceFirst('Exception: ', '').trim();
      _replaceMessage(
        loadingId,
        _ChatMessage.bot(text: message.isEmpty ? 'Try again' : message),
      );
      _showMessage(message.isEmpty ? 'Try again' : message);
    }
  }

  Future<void> _pickImage() async {
    try {
      await _tts.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }

      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      if (!mounted) {
        return;
      }

      _appendMessage(
        _ChatMessage.user(
          text: 'Uploaded an image for review.',
          imageBytes: bytes,
          imageName: image.name,
        ),
      );
      final loadingId = _appendMessage(
        _ChatMessage.loading(text: 'Analyzing image...'),
      );

      final response = await _chatService.analyzeImage(fileName: image.name);
      if (!mounted) {
        return;
      }

      _replaceMessage(
        loadingId,
        _ChatMessage.bot(
          text: response.toDisplayMessage(),
          showConsultDoctorAction: true,
        ),
      );
      unawaited(
        speakResponse(
          response.toSpeakText(),
          languageCode: response.languageCode,
        ),
      );
    } catch (_) {
      _showMessage('Image selection failed. Please try again.');
    }
  }

  Future<void> speakResponse(String text, {String languageCode = 'en'}) async {
    if (text.trim().isEmpty) {
      return;
    }

    try {
      await _tts.stop();
      await _tts.setLanguage(languageCode == 'ta' ? 'ta-IN' : 'en-US');
      if (!mounted) {
        return;
      }
      setState(() {
        _isSpeaking = true;
      });
      await _tts.speak(text);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  String _appendMessage(_ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
    return message.id;
  }

  void _replaceMessage(String id, _ChatMessage message) {
    setState(() {
      final index = _messages.indexWhere((entry) => entry.id == id);
      if (index == -1) {
        _messages.add(message);
      } else {
        _messages[index] = message;
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showOpenSettingsMessage() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Microphone access is disabled. Enable it in settings to use voice input.',
        ),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {
            unawaited(_permissionService.openSettingsIfDenied());
          },
        ),
      ),
    );
  }

  void _openDoctorList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DoctorListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AppShell(
      title: 'AI Health Assistant',
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              itemCount: _messages.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(
                  message: message,
                  onConsultDoctor: _openDoctorList,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              border: Border(
                top: BorderSide(color: AppTheme.blue.withValues(alpha: 0.08)),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.blue.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isListening
                        ? 'Listening... final speech will be sent automatically.'
                        : _isSpeaking
                        ? 'Speaking the bot reply aloud...'
                        : 'Structured health guidance only. Severe symptoms should be reviewed by a doctor.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _isListening || _isSpeaking
                          ? AppTheme.deepBlue
                          : AppTheme.mutedInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ComposerButton(
                        icon: Icons.photo_library_outlined,
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 8),
                      _ComposerButton(
                        icon: _isListening
                            ? Icons.mic_off_outlined
                            : Icons.mic_none,
                        active: _isListening,
                        onPressed: _toggleListening,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          textInputAction: TextInputAction.send,
                          minLines: 1,
                          maxLines: 5,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            hintText: 'Describe symptoms here...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _ComposerButton(
                        icon: Icons.send_rounded,
                        filled: true,
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.onConsultDoctor});

  final _ChatMessage message;
  final VoidCallback onConsultDoctor;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final textColor = isUser ? Colors.white : AppTheme.ink;
    final bubbleBorderRadius = BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: Radius.circular(isUser ? 24 : 8),
      bottomRight: Radius.circular(isUser ? 8 : 24),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isUser ? AppTheme.heroGradient : null,
            color: isUser ? null : Colors.white.withValues(alpha: 0.96),
            borderRadius: bubbleBorderRadius,
            border: isUser
                ? null
                : Border.all(color: AppTheme.blue.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.blue.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.imageBytes != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.memory(
                      message.imageBytes!,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (message.imageName != null)
                    Text(
                      message.imageName!,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (message.text.isNotEmpty) const SizedBox(height: 8),
                ],
                if (message.isLoading)
                  Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isUser ? Colors.white : AppTheme.deepBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  )
                else if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      height: 1.45,
                      fontWeight: isUser ? FontWeight.w600 : FontWeight.w700,
                    ),
                  ),
                if (message.showConsultDoctorAction &&
                    !message.isUser &&
                    !message.isLoading) ...[
                  const SizedBox(height: 14),
                  TextButton.icon(
                    onPressed: onConsultDoctor,
                    icon: const Icon(Icons.medical_services_outlined),
                    label: const Text('Consult Doctor'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposerButton extends StatelessWidget {
  const _ComposerButton({
    required this.icon,
    required this.onPressed,
    this.active = false,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool active;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = filled || active
        ? AppTheme.deepBlue
        : AppTheme.softBlue;
    final iconColor = filled || active ? Colors.white : AppTheme.deepBlue;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.showConsultDoctorAction = false,
    this.imageBytes,
    this.imageName,
  });

  factory _ChatMessage.user({
    required String text,
    Uint8List? imageBytes,
    String? imageName,
  }) {
    return _ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      imageBytes: imageBytes,
      imageName: imageName,
    );
  }

  factory _ChatMessage.bot({
    required String text,
    bool showConsultDoctorAction = false,
  }) {
    return _ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      showConsultDoctorAction: showConsultDoctorAction,
    );
  }

  factory _ChatMessage.loading({required String text}) {
    return _ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      isLoading: true,
    );
  }

  final String id;
  final String text;
  final bool isUser;
  final bool isLoading;
  final bool showConsultDoctorAction;
  final Uint8List? imageBytes;
  final String? imageName;
}
