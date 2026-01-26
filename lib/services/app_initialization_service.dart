import 'package:qr_master/services/ads_service.dart';
import 'package:qr_master/services/apphud_service.dart';
import 'package:qr_master/services/appsflyer_service.dart';
import 'package:qr_master/services/att_service.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';
import 'package:qr_master/services/logger_service.dart';

class AppInitializationService {
  static Future<void> initialize() async {
    try {
      LoggerService.info('Starting app initialization');

      await FirebaseService.initialize();

      await AdsService().initialize().catchError((error) {
        LoggerService.warning(
          'AdsService initialization failed, continuing: $error',
        );
      });

      AppsFlyerService().initialize().catchError((error) {
        LoggerService.warning(
          'AppsFlyer initialization failed, continuing: $error',
        );
      });

      AppHudService().initialize().catchError((error) {
        LoggerService.warning(
          'AppHud initialization failed, continuing: $error',
        );
      });

      ATTService().requestTrackingPermission().catchError((error) {
        LoggerService.warning(
          'ATT permission request failed, continuing: $error',
        );
      });

      LoggerService.info('App initialization completed');
    } catch (e) {
      LoggerService.error('Error during app initialization', error: e);
      rethrow;
    }
  }
}
