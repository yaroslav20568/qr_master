import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qr_master/services/app/logger_service.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static FirebaseAnalytics? _analytics;

  static bool get isInitialized => _isInitialized;

  static FirebaseAnalytics? get analytics => _isInitialized ? _analytics : null;

  static Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    try {
      await Firebase.initializeApp();
      _analytics = FirebaseAnalytics.instance;
      _isInitialized = true;
      LoggerService.info('Firebase initialized successfully');
      return true;
    } catch (e) {
      LoggerService.warning(
        'Firebase initialization failed. App will continue without Firebase.',
      );
      LoggerService.error('Firebase error details', error: e);
      _isInitialized = false;
      return false;
    }
  }

  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } catch (e) {
      LoggerService.error('Error logging analytics event', error: e);
    }
  }

  static Future<void> setUserId(String? userId) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.setUserId(id: userId);
    } catch (e) {
      LoggerService.error('Error setting user ID', error: e);
    }
  }

  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
      LoggerService.error('Error setting user property', error: e);
    }
  }

  static Future<void> logAppOpen() async {
    if (!_isInitialized || _analytics == null) {
      return;
    }

    try {
      await _analytics!.logAppOpen();
    } catch (e) {
      LoggerService.error('Error logging app open', error: e);
    }
  }
}
