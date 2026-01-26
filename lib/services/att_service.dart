import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:qr_master/services/appsflyer_service.dart';
import 'package:qr_master/services/logger_service.dart';

class ATTService {
  static final ATTService _instance = ATTService._internal();
  factory ATTService() => _instance;
  ATTService._internal();

  bool _isInitialized = false;
  int? _attStatus;

  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) {
      LoggerService.info('ATT is iOS only, skipping');
      return;
    }

    if (_isInitialized) {
      LoggerService.info('ATT already initialized');
      return;
    }

    try {
      LoggerService.info('Requesting ATT permission...');

      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      _attStatus = _statusToInt(status);
      _isInitialized = true;

      LoggerService.info('ATT status: $status (int: $_attStatus)');

      await AppsFlyerService().setATTStatus(_attStatus!);
    } catch (e) {
      LoggerService.error('Error requesting ATT permission', error: e);
    }
  }

  Future<int?> getTrackingStatus() async {
    if (!Platform.isIOS) {
      return null;
    }

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      _attStatus = _statusToInt(status);
      return _attStatus;
    } catch (e) {
      LoggerService.error('Error getting ATT status', error: e);
      return null;
    }
  }

  int _statusToInt(dynamic status) {
    final statusString = status.toString();
    if (statusString.contains('authorized')) {
      return 3;
    } else if (statusString.contains('denied')) {
      return 2;
    } else if (statusString.contains('restricted')) {
      return 1;
    } else {
      return 0;
    }
  }

  bool get isInitialized => _isInitialized;
  int? get attStatus => _attStatus;
}
