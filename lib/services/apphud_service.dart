import 'dart:async';
import 'package:apphud/apphud.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_master/services/logger_service.dart';

class AppHudService {
  static final AppHudService _instance = AppHudService._internal();
  factory AppHudService() => _instance;
  AppHudService._internal();

  bool _isInitialized = false;
  bool _hasActiveSubscription = false;

  String get apiKey => dotenv.env['APPHUD_API_KEY'] ?? '';
  String get bundleId => dotenv.env['APPHUD_BUNDLE_ID'] ?? '';
  String get paywallId => dotenv.env['APPHUD_PAYWALL_ID'] ?? 'main_paywall';
  String get productWeekly => dotenv.env['APPHUD_PRODUCT_WEEKLY'] ?? '';
  String get productMonthly => dotenv.env['APPHUD_PRODUCT_MONTHLY'] ?? '';
  String get productYearly => dotenv.env['APPHUD_PRODUCT_YEARLY'] ?? '';

  Future<void> initialize() async {
    if (_isInitialized) {
      LoggerService.info('AppHud already initialized');
      return;
    }

    if (apiKey.isEmpty) {
      LoggerService.warning('AppHud API key is empty, skipping initialization');
      return;
    }

    try {
      LoggerService.info('Initializing AppHud...');
      await Apphud.start(apiKey: apiKey).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.warning('AppHud initialization timeout');
          throw TimeoutException('AppHud initialization timeout');
        },
      );
      _isInitialized = true;
      LoggerService.info('AppHud initialized successfully');

      try {
        await checkSubscriptionStatus().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            LoggerService.warning('AppHud subscription check timeout');
            return false;
          },
        );
      } catch (e) {
        LoggerService.warning('Error checking subscription status: $e');
      }
    } on TimeoutException {
      LoggerService.warning(
        'AppHud initialization timed out, continuing without AppHud',
      );
    } catch (e) {
      LoggerService.error('Error initializing AppHud: $e', error: e);
      LoggerService.warning('Continuing without AppHud functionality');
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    try {
      final hasActiveSubscription = await Apphud.hasActiveSubscription();
      _hasActiveSubscription = hasActiveSubscription;
      LoggerService.info(
        'Subscription status: ${_hasActiveSubscription ? "Active" : "Inactive"}',
      );
      return _hasActiveSubscription;
    } catch (e) {
      LoggerService.error('Error checking subscription status', error: e);
      return false;
    }
  }

  bool get hasActiveSubscription => _hasActiveSubscription;

  Future<List<dynamic>> getProducts() async {
    try {
      LoggerService.info('Getting products from placement: $paywallId');
      final placement = await Apphud.placement(paywallId);
      if (placement == null) {
        LoggerService.warning('No placement found: $paywallId');
        return [];
      }
      final paywall = (placement as dynamic).paywall;
      if (paywall == null) {
        LoggerService.warning('No paywall in placement: $paywallId');
        return [];
      }
      final products = (paywall as dynamic).products ?? [];
      LoggerService.info('Products loaded: ${products.length}');
      return products;
    } catch (e) {
      LoggerService.error('Error getting products: $e', error: e);
      LoggerService.warning('Using fallback: returning empty products list');
      return [];
    }
  }

  Future<bool> purchaseProduct(dynamic product) async {
    try {
      final productId = (product as dynamic).productId ?? '';
      LoggerService.info('Purchasing product: $productId');
      final result = await Apphud.purchase(product: product);
      if (result.error == null) {
        await checkSubscriptionStatus();
        LoggerService.info('Purchase successful');
        return true;
      } else {
        LoggerService.error('Purchase failed: ${result.error}');
        return false;
      }
    } catch (e) {
      LoggerService.error('Error purchasing product', error: e);
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      LoggerService.info('Restoring purchases...');
      final result = await Apphud.restorePurchases();
      await checkSubscriptionStatus();
      LoggerService.info('Restore completed: ${result.error == null}');
      return result.error == null;
    } catch (e) {
      LoggerService.error('Error restoring purchases', error: e);
      return false;
    }
  }
}
