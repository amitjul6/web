import 'package:permission_handler/permission_handler.dart';

/// Wraps the ACTIVITY_RECOGNITION runtime permission needed by the step sensor.
class PermissionService {
  Future<bool> hasActivityPermission() async =>
      Permission.activityRecognition.isGranted;

  /// Requests the permission; returns true if granted. Safe to call repeatedly.
  Future<bool> requestActivityPermission() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<bool> isPermanentlyDenied() =>
      Permission.activityRecognition.isPermanentlyDenied;
}
