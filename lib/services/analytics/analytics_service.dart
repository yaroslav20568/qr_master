import 'package:qr_master/services/analytics/appmetrica_service.dart';
import 'package:qr_master/services/analytics/appsflyer_service.dart';
import 'package:qr_master/services/app/logger_service.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await Future.wait([
        FirebaseService.logEvent(name: name, parameters: parameters),
        AppMetricaService().reportEvent(name, parameters: parameters),
        AppsFlyerService().logEvent(name, parameters: parameters),
      ], eagerError: false);
      LoggerService.info('Analytics event logged: $name');
    } catch (e) {
      LoggerService.error('Error logging analytics event', error: e);
    }
  }

  Future<void> setUserId(String? userId) async {
    try {
      await Future.wait([
        FirebaseService.setUserId(userId),
        if (userId != null) AppMetricaService().setUserProfileId(userId),
      ], eagerError: false);
      LoggerService.info('Analytics user ID set: $userId');
    } catch (e) {
      LoggerService.error('Error setting analytics user ID', error: e);
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await FirebaseService.setUserProperty(name: name, value: value);
      LoggerService.info('Analytics user property set: $name = $value');
    } catch (e) {
      LoggerService.error('Error setting analytics user property', error: e);
    }
  }

  Future<void> logAppOpen() async {
    try {
      await FirebaseService.logAppOpen();
      await AppMetricaService().reportEvent('app_open');
      await AppsFlyerService().logEvent('app_open');
      LoggerService.info('Analytics app open logged');
    } catch (e) {
      LoggerService.error('Error logging app open', error: e);
    }
  }
}
