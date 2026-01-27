import 'dart:async';

import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_data.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';
import 'package:apphud/models/apphud_models/apphud_non_renewing_purchase.dart';
import 'package:apphud/models/apphud_models/apphud_paywalls.dart';
import 'package:apphud/models/apphud_models/apphud_subscription.dart';
import 'package:apphud/models/apphud_models/apphud_user.dart';
import 'package:apphud/models/apphud_models/composite/apphud_product_composite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_master/services/app/logger_service.dart';

class _AppHudListenerImpl extends ApphudListener {
  final Function(bool) onSubscriptionStatusChanged;

  _AppHudListenerImpl(this.onSubscriptionStatusChanged);

  @override
  Future<void> apphudSubscriptionsUpdated(
    List<ApphudSubscriptionWrapper> subscriptions,
  ) async {
    LoggerService.info(
      'Subscriptions updated: ${subscriptions.length} subscriptions',
    );
    final hasActive = subscriptions.any((sub) => sub.isActive);
    onSubscriptionStatusChanged(hasActive);
  }

  @override
  Future<void> paywallsDidFullyLoad(ApphudPaywalls paywalls) async {
    LoggerService.info(
      'Paywalls fully loaded: ${paywalls.paywalls.length} paywalls',
    );
  }

  @override
  Future<void> apphudNonRenewingPurchasesUpdated(
    List<ApphudNonRenewingPurchase> purchases,
  ) async {
    LoggerService.info(
      'Non-renewing purchases updated: ${purchases.length} purchases',
    );
  }

  @override
  Future<void> apphudDidChangeUserID(String userId) async {
    LoggerService.info('AppHud user ID changed: $userId');
  }

  @override
  Future<void> apphudDidFecthProducts(
    List<ApphudProductComposite> products,
  ) async {
    LoggerService.info('AppHud products fetched: ${products.length} products');
  }

  @override
  Future<void> userDidLoad(ApphudUser user) async {
    LoggerService.info('AppHud user loaded');
  }

  @override
  Future<void> placementsDidFullyLoad(List<dynamic> placements) async {
    LoggerService.info(
      'Placements fully loaded: ${placements.length} placements',
    );
  }

  @override
  Future<void> apphudDidReceivePurchase(dynamic purchase) async {
    LoggerService.info('AppHud received purchase');
  }
}

class AppHudService {
  static final AppHudService _instance = AppHudService._internal();
  factory AppHudService() => _instance;
  AppHudService._internal();

  bool _isInitialized = false;
  bool _hasActiveSubscription = false;
  _AppHudListenerImpl? _listener;

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
      await Apphud.enableDebugLogs();
      await Apphud.start(apiKey: apiKey).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.warning('AppHud initialization timeout');
          throw TimeoutException('AppHud initialization timeout');
        },
      );
      _isInitialized = true;
      LoggerService.info('AppHud initialized successfully');

      _setupListener();

      try {
        await checkSubscriptionStatus().timeout(const Duration(seconds: 5));
      } on TimeoutException {
        LoggerService.warning('AppHud subscription check timeout');
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

  void _setupListener() {
    _listener = _AppHudListenerImpl((hasActive) {
      if (hasActive != _hasActiveSubscription) {
        _hasActiveSubscription = hasActive;
        LoggerService.info(
          'Subscription status changed: ${_hasActiveSubscription ? "Active" : "Inactive"}',
        );
      }
    });
    Apphud.setListener(listener: _listener);
    LoggerService.info('AppHud listener set up successfully');
  }

  Future<void> updateAttribution(Map<String, String> attributionData) async {
    if (!_isInitialized) {
      LoggerService.warning(
        'AppHud not initialized, cannot update attribution',
      );
      return;
    }

    try {
      final mediaSource = attributionData['media_source'];
      final campaign = attributionData['campaign'];
      final afStatus = attributionData['af_status'];

      if (mediaSource != null) {
        final rawData = <String, dynamic>{
          'media_source': mediaSource,
          if (campaign != null) 'campaign': campaign,
          if (afStatus != null) 'af_status': afStatus,
        };

        final apphudAttributionData = ApphudAttributionData(
          rawData: rawData,
          channel: mediaSource,
          campaign: campaign,
        );

        final success = await Apphud.setAttribution(
          provider: ApphudAttributionProvider.appsFlyer,
          data: apphudAttributionData,
        );

        if (success) {
          LoggerService.info('AppHud attribution updated: $attributionData');
        } else {
          LoggerService.warning('Failed to update AppHud attribution');
        }
      }
    } catch (e) {
      LoggerService.error('Error updating AppHud attribution', error: e);
    }
  }

  void dispose() {
    Apphud.setListener(listener: null);
    _listener = null;
  }
}
