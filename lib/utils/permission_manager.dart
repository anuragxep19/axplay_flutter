import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionManager {
  // Track permission statuses
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  int _sdkVersion = 30;

  PermissionStatus get storagePermissionStatus => _storagePermissionStatus;
  PermissionStatus get cameraPermissionStatus => _cameraPermissionStatus;

  /// Requests the camera permission.
  Future<void> requestCameraPermission() async {
    try {
      _cameraPermissionStatus = await Permission.camera.request();
    } catch (e) {
      debugPrint("Error requesting camera permission: $e");
    }
  }

  /// Requests storage permission, with Android version check.
  Future<void> requestStoragePermission(BuildContext context) async {
    try {
      // Fetch Android info to check SDK version
      final androidInfo = await _deviceInfo.androidInfo;
      _sdkVersion = androidInfo.version.sdkInt;
      final isPermissionNotEnabled =
          _sdkVersion >= 29
              ? !await Permission.manageExternalStorage.isGranted
              : !await Permission.storage.isGranted;
      if (!isPermissionNotEnabled) {
        _storagePermissionStatus = PermissionStatus.granted;
        return;
      }
      bool proceed =
          context.mounted
              ? await _showDialog(
                context,
                title: "Storage Permission Needed",
                content:
                    "This app needs access to your storage to function correctly. Please enable this permission.",
                positiveAction: "Enable",
                negativeAction: "Cancel",
              )
              : false;

      // If user cancels the initial dialog, prompt them with settings
      if (!proceed) {
        if (context.mounted) {
          bool gotoSettings = await _showDialog(
            context,
            title: "Permission Required",
            content:
                "Storage access is required for the app to function properly. Please enable it in the app settings.",
            positiveAction: "Go to Settings",
            negativeAction: "Cancel",
          );

          if (gotoSettings) {
            openAppSettings();
          }
        }
        return;
      }

      // Request the appropriate storage permission based on SDK version
      if (_sdkVersion >= 29) {
        _storagePermissionStatus =
            await Permission.manageExternalStorage.request();
      } else {
        _storagePermissionStatus = await Permission.storage.request();
      }

      // If still not granted, prompt the user to check settings.
      if (!_storagePermissionStatus.isGranted) {
        if (context.mounted) {
          bool gotoSettings = await _showDialog(
            context,
            title: "Permission Required",
            content:
                "Storage access is mandatory. Please enable it in the app settings.",
            positiveAction: "Go to Settings",
            negativeAction: "Cancel",
          );
          if (gotoSettings) {
            openAppSettings();
          }
        }
      }
    } catch (e) {
      debugPrint("Error requesting storage permission: $e");
    }
  }

  /// Request both camera and storage permissions.
  Future<void> getAllPermissions(BuildContext context) async {
    await requestCameraPermission();
    if (context.mounted) await requestStoragePermission(context);
  }

  /// Continuously checks that both permissions are granted.
  /// If either is missing, it prompts the user to head to settings,
  /// and re-checks on return. If the user cancels, the app exits.
  Future<bool> ensureAllPermissionsGranted(BuildContext context) async {
    // Request the initial set of permissions.
    if (!storagePermissionStatus.isGranted ||
        !cameraPermissionStatus.isGranted) {
      await getAllPermissions(context);
    }
    while (!(_cameraPermissionStatus.isGranted &&
        _storagePermissionStatus.isGranted)) {
      bool gotoSettings =
          context.mounted
              ? await _showDialog(
                context,
                title: "All Permissions Needed",
                content:
                    "The app requires both camera and storage permissions to run properly. Please enable them in the app settings.",
                positiveAction: "Go to Settings",
                negativeAction: "Exit",
              )
              : false;
      if (!gotoSettings) {
        // User chose to exit
        SystemNavigator.pop();
        return false;
      }
      // Open settings and allow the user time to modify permissions.
      await openAppSettings();
      // Recheck permissions after coming back.
      _cameraPermissionStatus = await Permission.camera.status;
      if (_sdkVersion >= 29) {
        _storagePermissionStatus =
            await Permission.manageExternalStorage.status;
      } else {
        _storagePermissionStatus = await Permission.storage.status;
      }
    }
    return true;
  }

  /// Helper method to show a dialog and return the user's choice.
  Future<bool> _showDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String positiveAction,
    required String negativeAction,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  child: Text(negativeAction),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                TextButton(
                  child: Text(positiveAction),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
