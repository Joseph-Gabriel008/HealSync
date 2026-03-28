import 'package:permission_handler/permission_handler.dart';

enum PermissionRequestResult { granted, denied, permanentlyDenied }

class PermissionService {
  Future<bool> checkCameraPermission() async {
    return (await Permission.camera.status).isGranted;
  }

  Future<bool> checkMicPermission() async {
    return (await Permission.microphone.status).isGranted;
  }

  Future<PermissionRequestResult> requestMicrophonePermission() async {
    if (await checkMicPermission()) {
      return PermissionRequestResult.granted;
    }

    final status = await Permission.microphone.request();
    if (status.isGranted) {
      return PermissionRequestResult.granted;
    }

    final permanentlyDenied = status.isPermanentlyDenied || status.isRestricted;
    return permanentlyDenied
        ? PermissionRequestResult.permanentlyDenied
        : PermissionRequestResult.denied;
  }

  Future<PermissionRequestResult> requestPermissions() async {
    final alreadyGranted =
        await checkCameraPermission() && await checkMicPermission();
    if (alreadyGranted) {
      return PermissionRequestResult.granted;
    }

    final statuses = await [Permission.camera, Permission.microphone].request();

    final cameraStatus = statuses[Permission.camera];
    final micStatus = statuses[Permission.microphone];

    if ((cameraStatus?.isGranted ?? false) && (micStatus?.isGranted ?? false)) {
      return PermissionRequestResult.granted;
    }

    final permanentlyDenied =
        (cameraStatus?.isPermanentlyDenied ?? false) ||
        (micStatus?.isPermanentlyDenied ?? false) ||
        (cameraStatus?.isRestricted ?? false) ||
        (micStatus?.isRestricted ?? false);

    return permanentlyDenied
        ? PermissionRequestResult.permanentlyDenied
        : PermissionRequestResult.denied;
  }

  Future<bool> openSettingsIfDenied() async {
    return openAppSettings();
  }
}
