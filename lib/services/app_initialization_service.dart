import 'package:qr_master/services/firebase_service.dart';
import 'package:qr_master/services/logger_service.dart';

class AppInitializationService {
  static Future<void> initialize() async {
    try {
      LoggerService.info('Starting app initialization');

      await FirebaseService.initialize();

      LoggerService.info('App initialization completed');
    } catch (e) {
      LoggerService.error('Error during app initialization', error: e);
      rethrow;
    }
  }
}
