import 'dart:io' show Platform;

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_master/services/app/logger_service.dart';
import 'package:qr_master/services/subscriptions/apphud_service.dart';

class AppsFlyerService {
  static final AppsFlyerService _instance = AppsFlyerService._internal();
  factory AppsFlyerService() => _instance;
  AppsFlyerService._internal();

  bool _isInitialized = false;
  AppsflyerSdk? _appsflyerSdk;

  String get devKey => dotenv.env['APPSFLYER_DEV_KEY'] ?? '';
  String get appId => dotenv.env['APPSFLYER_APP_ID'] ?? '';

  Future<void> initialize() async {
    if (_isInitialized) {
      LoggerService.info('AppsFlyer already initialized');
      return;
    }

    if (devKey.isEmpty) {
      LoggerService.warning(
        'AppsFlyer dev key is empty, skipping initialization',
      );
      return;
    }

    try {
      LoggerService.info('Initializing AppsFlyer...');

      final appsflyerOptions = AppsFlyerOptions(
        afDevKey: devKey,
        appId: Platform.isIOS && appId.isNotEmpty ? appId : '',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 60,
      );

      _appsflyerSdk = AppsflyerSdk(appsflyerOptions);

      _appsflyerSdk?.onInstallConversionData((data) {
        LoggerService.info('AppsFlyer conversion data: $data');
        _sendAttributionToAppHud(data);
      });

      _appsflyerSdk?.onDeepLinking((data) {
        LoggerService.info('AppsFlyer deep link: $data');
      });

      await _appsflyerSdk?.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      _isInitialized = true;
      LoggerService.info('AppsFlyer initialized successfully');
    } catch (e) {
      LoggerService.error('Error initializing AppsFlyer', error: e);
      LoggerService.warning('Continuing without AppsFlyer functionality');
    }
  }

  void _sendAttributionToAppHud(Map<dynamic, dynamic>? data) {
    if (data == null) return;

    try {
      final mediaSource = data['media_source']?.toString();
      final campaign = data['campaign']?.toString();
      final afStatus = data['af_status']?.toString();

      if (mediaSource != null || campaign != null) {
        final attributionData = <String, String>{
          if (mediaSource != null) 'media_source': mediaSource,
          if (campaign != null) 'campaign': campaign,
          if (afStatus != null) 'af_status': afStatus,
        };

        LoggerService.info('Sending attribution to AppHud: $attributionData');
        AppHudService().updateAttribution(attributionData);
      }
    } catch (e) {
      LoggerService.error('Error sending attribution to AppHud', error: e);
    }
  }

  Future<void> setATTStatus(int status) async {
    if (!_isInitialized || _appsflyerSdk == null) return;

    try {
      if (Platform.isIOS) {
        LoggerService.info('AppsFlyer ATT status: $status');
      }
    } catch (e) {
      LoggerService.error('Error setting ATT status', error: e);
    }
  }

  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized || _appsflyerSdk == null) return;

    try {
      await _appsflyerSdk?.logEvent(eventName, parameters ?? {});
      LoggerService.info('AppsFlyer event logged: $eventName');
    } catch (e) {
      LoggerService.error('Error logging AppsFlyer event', error: e);
    }
  }

  bool get isInitialized => _isInitialized;
}
