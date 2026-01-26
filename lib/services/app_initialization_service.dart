import 'package:qr_master/services/apphud_service.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';
import 'package:qr_master/services/logger_service.dart';

class AppInitializationService {
  static Future<void> initialize() async {
    try {
      LoggerService.info('Starting app initialization');

      await FirebaseService.initialize();

      AppHudService().initialize().catchError((error) {
        LoggerService.warning(
          'AppHud initialization failed, continuing: $error',
        );
      });

      LoggerService.info('App initialization completed');
    } catch (e) {
      LoggerService.error('Error during app initialization', error: e);
      rethrow;
    }
  }
}
