import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_master/services/app/logger_service.dart';

class AppMetricaService {
  static final AppMetricaService _instance = AppMetricaService._internal();
  factory AppMetricaService() => _instance;
  AppMetricaService._internal();

  bool _isInitialized = false;

  String get apiKey => dotenv.env['APPMETRICA_API_KEY'] ?? '';

  Future<void> initialize() async {
    if (_isInitialized) {
      LoggerService.info('AppMetrica already initialized');
      return;
    }

    if (apiKey.isEmpty) {
      LoggerService.warning(
        'AppMetrica API key is empty, skipping initialization',
      );
      return;
    }

    try {
      LoggerService.info('Initializing AppMetrica...');

      final config = AppMetricaConfig(apiKey);

      await AppMetrica.activate(config);
      _isInitialized = true;
      LoggerService.info('AppMetrica initialized successfully');
    } catch (e) {
      LoggerService.error('Error initializing AppMetrica', error: e);
      LoggerService.warning('Continuing without AppMetrica functionality');
    }
  }

  Future<void> reportEvent(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await AppMetrica.reportEventWithMap(eventName, parameters ?? {});
      LoggerService.info('AppMetrica event reported: $eventName');
    } catch (e) {
      LoggerService.error('Error reporting AppMetrica event', error: e);
    }
  }

  Future<void> reportError(String error) async {
    if (!_isInitialized) {
      return;
    }

    try {
      LoggerService.info('AppMetrica error reported: $error');
    } catch (e) {
      LoggerService.error('Error reporting AppMetrica error', error: e);
    }
  }

  Future<void> setUserProfileId(String userId) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await AppMetrica.setUserProfileID(userId);
      LoggerService.info('AppMetrica user profile ID set: $userId');
    } catch (e) {
      LoggerService.error('Error setting AppMetrica user profile ID', error: e);
    }
  }

  bool get isInitialized => _isInitialized;
}
