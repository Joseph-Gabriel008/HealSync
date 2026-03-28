import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/app_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/app_state.dart';
import '../../../services/permission_service.dart';
import '../../../services/record_service.dart';
import '../../../services/recording_service.dart';
import '../../records/screens/add_record_screen.dart';
import '../widgets/privacy_confirmation_dialog.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({
    super.key,
    required this.title,
    required this.channelId,
    this.patientId,
    this.appointmentId,
    this.allowDiagnosisActions = false,
  });

  final String title;
  final String channelId;
  final String? patientId;
  final String? appointmentId;
  final bool allowDiagnosisActions;

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _diagnosisController = TextEditingController(
    text: 'Mild viral fever. Hydration and rest advised.',
  );
  final _prescriptionController = TextEditingController(
    text: 'Paracetamol 500mg twice daily for 3 days.',
  );
  final _permissionService = PermissionService();
  final _recordService = RecordService();
  final _recordingService = RecordingService();

  Widget? _localView;
  Widget? _remoteView;
  int? _localViewId;
  int? _remoteViewId;
  String? _publishedStreamId;
  String? _remoteStreamId;
  bool _engineCreated = false;
  bool _joined = false;
  bool _initializing = false;
  bool _muted = false;
  bool _cameraOff = false;
  bool _usingFrontCamera = true;
  bool _isRecording = false;
  String? _recordingWarning;
  String? _callError;
  String _callStatus = '';
  Timer? _callTimer;
  Duration _callDuration = Duration.zero;

  bool get _zegoConfigured =>
      AppConstants.zegoAppId > 0 &&
      (AppConstants.zegoAppSign.isNotEmpty ||
          AppConstants.zegoToken.isNotEmpty);

  String get _zegoConfigurationMessage =>
      'ZEGOCLOUD is not configured yet. Add ZEGO_APP_ID and either ZEGO_APP_SIGN or ZEGO_TOKEN before joining a live consultation.';

  String get _zegoSetupBody =>
      'This build now uses ZEGOCLOUD instead of Agora. Run the app with --dart-define=ZEGO_APP_ID=your_app_id and either --dart-define=ZEGO_APP_SIGN=your_app_sign or --dart-define=ZEGO_TOKEN=your_token.';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_callStatus.isEmpty) {
      _callStatus = AppLocalizations.of(context)!.readyToJoinConsultationRoom;
    }
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    _recordService.dispose();
    _recordingService.dispose();
    unawaited(_leaveCall(releaseEngine: true));
    super.dispose();
  }

  Future<void> _handleJoinCall() async {
    final l10n = AppLocalizations.of(context)!;
    final consent = await showDialog<bool>(
      context: context,
      builder: (_) => const PrivacyConfirmationDialog(),
    );
    if (consent != true || !mounted) {
      return;
    }

    final permissionResult = await _permissionService.requestPermissions();
    if (!mounted) {
      return;
    }

    switch (permissionResult) {
      case PermissionRequestResult.granted:
        await _prepareCall();
        return;
      case PermissionRequestResult.denied:
        setState(() {
          _callError = l10n.cameraMicPermissionsRequired;
          _callStatus = l10n.joinCancelledUntilPermissions;
        });
        _showPermissionDeniedSnackbar();
        return;
      case PermissionRequestResult.permanentlyDenied:
        setState(() {
          _callError = l10n.cameraMicPermanentlyDenied;
          _callStatus = l10n.joinCancelledUntilEnabled;
        });
        _showOpenSettingsSnackbar();
        return;
    }
  }

  Future<void> _prepareCall() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_zegoConfigured) {
      setState(() {
        _callError = _zegoConfigurationMessage;
        _callStatus = l10n.liveVideoSetupWaiting;
      });
      return;
    }

    setState(() {
      _initializing = true;
      _callError = null;
      _callStatus = l10n.preparingSecureVideoConsultation;
    });

    try {
      if (!_engineCreated) {
        await ZegoExpressEngine.createEngineWithProfile(
          ZegoEngineProfile(
            AppConstants.zegoAppId,
            ZegoScenario.StandardVideoCall,
            appSign: AppConstants.zegoAppSign.isEmpty
                ? null
                : AppConstants.zegoAppSign,
            enablePlatformView: false,
          ),
        );
        _engineCreated = true;
        _registerCallbacks();
      }
      await _joinCall();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _callError = _friendlyCallError(error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _initializing = false;
        });
      }
    }
  }

  void _registerCallbacks() {
    ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, _) {
      if (!mounted || roomID != widget.channelId) {
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        if (state == ZegoRoomState.Connecting) {
          _callStatus = l10n.connectingSecureConsultation;
        } else if (state == ZegoRoomState.Connected) {
          _callStatus = _remoteStreamId == null
              ? l10n.youAreLiveInRoom
              : l10n.doctorPatientConnected;
        } else if (state == ZegoRoomState.Disconnected) {
          _callStatus = l10n.consultationEnded;
          if (errorCode != 0) {
            _callError = _friendlyCallError('room error: $errorCode');
          }
        }
      });
    };

    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, _) {
      if (!mounted || roomID != widget.channelId) {
        return;
      }
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          if (stream.streamID != _publishedStreamId) {
            unawaited(_playRemoteStream(stream.streamID));
            break;
          }
        }
      } else {
        for (final stream in streamList) {
          if (stream.streamID == _remoteStreamId) {
            unawaited(_clearRemoteStream());
            break;
          }
        }
      }
    };

    ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, _) {
      if (!mounted || streamID != _publishedStreamId) {
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        if (state == ZegoPublisherState.Publishing) {
          _callStatus = _remoteStreamId == null
              ? l10n.youAreLiveInRoom
              : l10n.doctorPatientConnected;
        } else if (errorCode != 0) {
          _callError = _friendlyCallError('publish error: $errorCode');
        }
      });
    };

    ZegoExpressEngine.onPlayerStateUpdate = (streamID, state, errorCode, _) {
      if (!mounted || streamID != _remoteStreamId) {
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        if (state == ZegoPlayerState.Playing) {
          _callStatus = l10n.doctorPatientConnected;
        } else if (state == ZegoPlayerState.PlayRequesting) {
          _callStatus = l10n.connectingSecureConsultation;
        } else if (errorCode != 0) {
          _callError = _friendlyCallError('play error: $errorCode');
        }
      });
    };
  }

  Future<void> _joinCall() async {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<AppState>();
    final user = state.currentUser;
    if (user == null) {
      throw Exception('Missing current user session.');
    }

    final config = ZegoRoomConfig.defaultConfig();
    config.isUserStatusNotify = true;
    if (AppConstants.zegoToken.isNotEmpty) {
      config.token = AppConstants.zegoToken;
    }

    setState(() {
      _callStatus = l10n.joiningConsultationRoom;
      _callError = null;
    });

    await ZegoExpressEngine.instance.loginRoom(
      widget.channelId,
      ZegoUser(user.id, user.name),
      config: config,
    );

    await _ensureLocalPreview();
    _publishedStreamId = '${widget.channelId}-${user.id}';
    await ZegoExpressEngine.instance.startPublishingStream(_publishedStreamId!);

    final streams = await ZegoExpressEngine.instance.getRoomStreamList(
      widget.channelId,
      ZegoRoomStreamListType.Play,
    );
    for (final stream in streams.playStreamList) {
      if (stream.streamID != _publishedStreamId) {
        await _playRemoteStream(stream.streamID);
        break;
      }
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _joined = true;
      _callStatus = _remoteStreamId == null
          ? l10n.youAreLiveInRoom
          : l10n.doctorPatientConnected;
    });
    unawaited(_startAutomaticRecording());
    _startCallTimer();
  }

  Future<void> _ensureLocalPreview() async {
    if (_localViewId != null) {
      await ZegoExpressEngine.instance.startPreview(
        canvas: ZegoCanvas.view(_localViewId!),
      );
      return;
    }

    final view = await ZegoExpressEngine.instance.createCanvasView((
      viewID,
    ) async {
      _localViewId = viewID;
      await ZegoExpressEngine.instance.startPreview(
        canvas: ZegoCanvas.view(viewID),
      );
    });

    if (!mounted) {
      return;
    }
    setState(() {
      _localView = view;
    });
  }

  Future<void> _playRemoteStream(String streamId) async {
    if (_remoteStreamId == streamId && _remoteView != null) {
      return;
    }

    await _clearRemoteStream();
    final view = await ZegoExpressEngine.instance.createCanvasView((
      viewID,
    ) async {
      _remoteViewId = viewID;
      await ZegoExpressEngine.instance.startPlayingStream(
        streamId,
        canvas: ZegoCanvas.view(viewID),
      );
    });

    if (!mounted) {
      return;
    }
    setState(() {
      _remoteStreamId = streamId;
      _remoteView = view;
    });
  }

  Future<void> _clearRemoteStream() async {
    if (_remoteStreamId != null) {
      try {
        await ZegoExpressEngine.instance.stopPlayingStream(_remoteStreamId!);
      } catch (_) {}
    }
    if (_remoteViewId != null) {
      try {
        await ZegoExpressEngine.instance.destroyCanvasView(_remoteViewId!);
      } catch (_) {}
    }
    _remoteStreamId = null;
    _remoteViewId = null;
    if (!mounted) {
      _remoteView = null;
      return;
    }
    setState(() {
      _remoteView = null;
      if (_joined) {
        _callStatus = AppLocalizations.of(context)!.otherParticipantLeft;
      }
    });
  }

  Future<void> _leaveCall({bool releaseEngine = false}) async {
    try {
      await _stopAutomaticRecording();
      await _clearRemoteStream();
      if (_publishedStreamId != null) {
        await ZegoExpressEngine.instance.stopPublishingStream();
      }
      if (_localViewId != null) {
        await ZegoExpressEngine.instance.stopPreview();
        await ZegoExpressEngine.instance.destroyCanvasView(_localViewId!);
      }
      if (_joined) {
        await ZegoExpressEngine.instance.logoutRoom(widget.channelId);
      }
      if (releaseEngine && _engineCreated) {
        await ZegoExpressEngine.destroyEngine();
        _clearCallbacks();
      }
    } catch (_) {}

    _stopCallTimer();
    _publishedStreamId = null;
    _localViewId = null;
    _remoteViewId = null;
    _localView = null;
    _remoteView = null;
    if (releaseEngine) {
      _engineCreated = false;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _joined = false;
      _isRecording = false;
      _callStatus = AppLocalizations.of(context)!.consultationEnded;
    });
  }

  void _clearCallbacks() {
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onPlayerStateUpdate = null;
  }

  Future<void> _toggleMute() async {
    final nextMuted = !_muted;
    await ZegoExpressEngine.instance.muteMicrophone(nextMuted);
    if (!mounted) {
      return;
    }
    setState(() {
      _muted = nextMuted;
    });
  }

  Future<void> _toggleCamera() async {
    final nextCameraOff = !_cameraOff;
    await ZegoExpressEngine.instance.enableCamera(!nextCameraOff);
    if (!mounted) {
      return;
    }
    setState(() {
      _cameraOff = nextCameraOff;
    });
  }

  Future<void> _switchCamera() async {
    final nextUsingFrontCamera = !_usingFrontCamera;
    await ZegoExpressEngine.instance.useFrontCamera(nextUsingFrontCamera);
    if (!mounted) {
      return;
    }
    setState(() {
      _usingFrontCamera = nextUsingFrontCamera;
    });
  }

  String _friendlyCallError(String raw) {
    final l10n = AppLocalizations.of(context)!;
    final message = raw.toLowerCase();
    if (message.contains('permission')) {
      return l10n.healsyncNeedsPermissions;
    }
    if (message.contains('token') ||
        message.contains('sign') ||
        message.contains('auth')) {
      return _zegoConfigurationMessage;
    }
    if (message.contains('network')) {
      return l10n.networkUnstable;
    }
    return l10n.unableStartLiveConsultation;
  }

  void _showPermissionDeniedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.cameraMicAccessRequired),
      ),
    );
  }

  void _showOpenSettingsSnackbar() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.cameraMicAccessRequired),
        action: SnackBarAction(
          label: l10n.openSettings,
          onPressed: () {
            unawaited(_permissionService.openSettingsIfDenied());
          },
        ),
      ),
    );
  }

  String? _resolvedDoctorId(AppState state) {
    final user = state.currentUser;
    if (user == null) {
      return null;
    }
    if (user.isDoctor) {
      return user.id;
    }
    final title = widget.title.toLowerCase();
    for (final doctor in state.doctors) {
      if (title.contains(doctor.name.toLowerCase())) {
        return doctor.id;
      }
    }
    return null;
  }

  String? _resolvedPatientId(AppState state) {
    if (widget.patientId != null && widget.patientId!.isNotEmpty) {
      return widget.patientId;
    }
    final user = state.currentUser;
    if (user != null && !user.isDoctor) {
      return user.id;
    }
    return null;
  }

  Future<void> _startAutomaticRecording() async {
    try {
      await _recordingService.startRecording(channelId: widget.channelId);
      if (!mounted) {
        return;
      }
      setState(() {
        _isRecording = true;
        _recordingWarning = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _recordingWarning = error.toString().replaceFirst('Exception: ', '');
        _isRecording = false;
      });
    }
  }

  Future<void> _stopAutomaticRecording() async {
    try {
      final state = context.read<AppState>();
      final result = await _recordingService.stopRecording();
      if (result == null) {
        return;
      }
      final patientId = _resolvedPatientId(state);
      final doctorId = _resolvedDoctorId(state);
      if (patientId != null && doctorId != null) {
        await _recordingService.uploadRecording(
          patientId: patientId,
          doctorId: doctorId,
          result: result,
        );
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _isRecording = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _recordingWarning = error.toString().replaceFirst('Exception: ', '');
        _isRecording = false;
      });
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _callDuration += const Duration(seconds: 1);
      });
    });
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
    _callDuration = Duration.zero;
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = value.inHours;
    return hours > 0
        ? '${hours.toString().padLeft(2, '0')}:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  Future<void> _showHistorySheet(AppState state) async {
    final l10n = AppLocalizations.of(context)!;
    final patientId = _resolvedPatientId(state);
    if (patientId == null || patientId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.patientHistoryUnavailable)));
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.82,
          child: FutureBuilder<List<RecordHistoryItem>>(
            future: _recordService.getRecords(patientId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              final records = snapshot.data ?? const [];
              if (records.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.noMedicalHistoryFound),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: records.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    title: Text(record.condition),
                    subtitle: Text(
                      '${l10n.prescriptionLabel(record.prescription)}\n${l10n.dateLabel(record.date)}',
                    ),
                    isThreeLine: true,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openAddRecord(AppState state) async {
    final currentUser = state.currentUser;
    final patientId = _resolvedPatientId(state);
    if (currentUser == null || !currentUser.isDoctor || patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.onlyDoctorsCanAddRecords),
        ),
      );
      return;
    }

    UserProfile? patient;
    for (final candidate in state.patients) {
      if (candidate.id == patientId) {
        patient = candidate;
        break;
      }
    }
    if (patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.patientDetailsUnavailable,
          ),
        ),
      );
      return;
    }

    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddRecordScreen(doctor: currentUser, patient: patient!),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.medicalRecordSaved),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<AppState>();
    final isCompact = MediaQuery.sizeOf(context).width < 430;

    return AppShell(
      title: widget.title,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CallStatusHeader(
                    channelId: widget.channelId,
                    callStatus: _callStatus,
                    callError: _callError,
                    joined: _joined,
                    callDuration: _formatDuration(_callDuration),
                    recording: _isRecording,
                  ),
                  if (_recordingWarning != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _recordingWarning!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (!_zegoConfigured) ...[
                    const SizedBox(height: 16),
                    _SetupHelpCard(
                      title: 'ZEGOCLOUD setup required',
                      body: _zegoSetupBody,
                    ),
                  ],
                  const SizedBox(height: 20),
                  _VideoCanvas(
                    title: l10n.you,
                    subtitle: _cameraOff ? l10n.cameraOff : l10n.localCamera,
                    child: _cameraOff
                        ? _VideoPlaceholder(
                            icon: Icons.videocam_off_outlined,
                            label: l10n.cameraIsOff,
                          )
                        : (_localView ??
                              _VideoPlaceholder(
                                icon: Icons.videocam,
                                label: l10n.readyForPreview,
                              )),
                  ),
                  const SizedBox(height: 16),
                  _VideoCanvas(
                    title: l10n.remoteParticipant,
                    subtitle: _remoteStreamId == null
                        ? l10n.waitingSecondPerson
                        : l10n.connectedLive,
                    child:
                        _remoteView ??
                        _VideoPlaceholder(
                          icon: Icons.person_search_outlined,
                          label: l10n.waitingForOtherParticipant,
                        ),
                  ),
                  if (widget.patientId != null) ...[
                    const SizedBox(height: 20),
                    _PatientMedicalHistoryCard(patientId: widget.patientId!),
                  ],
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      GradientButton(
                        label: _joined
                            ? l10n.connectedLive
                            : _initializing
                            ? l10n.processing
                            : !_zegoConfigured
                            ? 'ZEGOCLOUD setup required'
                            : l10n.join,
                        icon: Icons.videocam_rounded,
                        expanded: isCompact,
                        onPressed:
                            (!_zegoConfigured || _initializing || _joined)
                            ? null
                            : _handleJoinCall,
                      ),
                      SizedBox(
                        width: isCompact ? double.infinity : null,
                        child: FilledButton.tonalIcon(
                          onPressed: () => _showHistorySheet(state),
                          icon: const Icon(Icons.history_edu_outlined),
                          label: Text(l10n.viewHistory),
                        ),
                      ),
                      SizedBox(
                        width: isCompact ? double.infinity : null,
                        child: FilledButton.tonalIcon(
                          onPressed: widget.allowDiagnosisActions
                              ? () => _openAddRecord(state)
                              : null,
                          icon: const Icon(Icons.note_add_outlined),
                          label: Text(l10n.addRecord),
                        ),
                      ),
                      if (widget.allowDiagnosisActions &&
                          widget.appointmentId != null)
                        SizedBox(
                          width: isCompact ? double.infinity : null,
                          child: FilledButton.tonalIcon(
                            onPressed: _showAddConsultantSheet,
                            icon: const Icon(Icons.group_add_outlined),
                            label: const Text('Add Consultant'),
                          ),
                        ),
                      SizedBox(
                        width: isCompact ? double.infinity : null,
                        child: FilledButton.tonalIcon(
                          onPressed: _joined ? _toggleMute : null,
                          icon: Icon(
                            _muted ? Icons.mic_off_outlined : Icons.mic_none,
                          ),
                          label: Text(_muted ? l10n.unmute : l10n.mute),
                        ),
                      ),
                      SizedBox(
                        width: isCompact ? double.infinity : null,
                        child: FilledButton.tonalIcon(
                          onPressed: _joined ? _toggleCamera : null,
                          icon: Icon(
                            _cameraOff
                                ? Icons.videocam_off_outlined
                                : Icons.flip_camera_android_outlined,
                          ),
                          label: Text(
                            _cameraOff ? l10n.turnCameraOn : l10n.camera,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isCompact ? double.infinity : null,
                        child: FilledButton.tonalIcon(
                          onPressed: _joined && !_cameraOff
                              ? _switchCamera
                              : null,
                          icon: const Icon(Icons.cameraswitch_outlined),
                          label: Text(
                            _usingFrontCamera
                                ? l10n.rearCamera
                                : l10n.frontCamera,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isCompact ? double.infinity : null,
                        child: FilledButton.tonalIcon(
                          style: FilledButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                          ),
                          onPressed: () async {
                            await _leaveCall();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.call_end),
                          label: Text(l10n.end),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (widget.allowDiagnosisActions) ...[
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _diagnosisController,
                      maxLines: 4,
                      decoration: InputDecoration(labelText: l10n.diagnosis),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _prescriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(labelText: l10n.prescription),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: l10n.saveNotes,
                      icon: Icons.save_outlined,
                      onPressed: () async {
                        try {
                          final patientId = widget.patientId;
                          if (patientId == null || patientId.isEmpty) {
                            throw Exception(
                              'Missing patient id for this consultation.',
                            );
                          }
                          await state.addQuickPrescription(
                            patientId: patientId,
                            condition: _diagnosisController.text,
                            notes: _prescriptionController.text,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.consultationNotesSaved),
                            ),
                          );
                        } catch (_) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.saveNotesError)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showAddConsultantSheet() async {
    final appointmentId = widget.appointmentId;
    final currentUser = context.read<AppState>().currentUser;
    if (appointmentId == null || currentUser == null) {
      return;
    }

    final state = context.read<AppState>();
    Appointment? appointment;
    for (final item in state.doctorAppointments) {
      if (item.id == appointmentId) {
        appointment = item;
        break;
      }
    }

    final excludedIds = <String>{
      currentUser.id,
      if (appointment != null) appointment.doctorId,
      ...?appointment?.consultantIds,
    };
    final availableDoctors = state.doctors
        .where((doctor) => !excludedIds.contains(doctor.id))
        .toList();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        if (availableDoctors.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No additional consultant or assistant is available to add right now.',
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: availableDoctors.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final doctor = availableDoctors[index];
            return ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(doctor.name),
              subtitle: Text(doctor.email),
              trailing: const Icon(Icons.add_circle_outline),
              onTap: () async {
                Navigator.pop(context);
                await state.inviteConsultantToAppointment(
                  appointmentId: appointmentId,
                  consultantId: doctor.id,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CallStatusHeader extends StatelessWidget {
  const _CallStatusHeader({
    required this.channelId,
    required this.callStatus,
    required this.callError,
    required this.joined,
    required this.callDuration,
    required this.recording,
  });
  final String channelId;
  final String callStatus;
  final String? callError;
  final bool joined;
  final String callDuration;
  final bool recording;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.liveConsultationRoom,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.channelLabel(channelId),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.ink.withValues(alpha: 0.72),
          ),
        ),
        if (recording) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                l10n.recording,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
        if (joined) ...[
          const SizedBox(height: 6),
          Text(
            l10n.liveDuration(callDuration),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.deepBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 10),
        Text(callStatus),
        if (callError != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEEB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              callError!,
              style: const TextStyle(
                color: AppTheme.ink,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _VideoCanvas extends StatelessWidget {
  const _VideoCanvas({
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FD),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(subtitle),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ColoredBox(color: Colors.black, child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFBFE7FF), Color(0xFF91D6B8), Color(0xFF0D7FD3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupHelpCard extends StatelessWidget {
  const _SetupHelpCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.ink,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppTheme.ink,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientMedicalHistoryCard extends StatelessWidget {
  const _PatientMedicalHistoryCard({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    UserProfile? patient;
    for (final item in state.patients) {
      if (item.id == patientId) {
        patient = item;
        break;
      }
    }
    patient ??= state.currentUser?.id == patientId ? state.currentUser : null;

    final history = patient?.medicalHistory.trim() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient medical history',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            history.isEmpty
                ? 'No previous health conditions have been added by the patient yet.'
                : history,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
