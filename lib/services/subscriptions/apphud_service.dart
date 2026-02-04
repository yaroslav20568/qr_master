import 'dart:async';
import 'dart:io';

import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_data.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';
import 'package:apphud/models/apphud_models/apphud_non_renewing_purchase.dart';
import 'package:apphud/models/apphud_models/apphud_paywall.dart';
import 'package:apphud/models/apphud_models/apphud_paywalls.dart';
import 'package:apphud/models/apphud_models/apphud_product.dart';
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
    final hasActive = subscriptions.any((sub) => sub.isActive);
    onSubscriptionStatusChanged(hasActive);
  }

  @override
  Future<void> placementsDidFullyLoad(List<dynamic> placements) async {}

  @override
  Future<void> paywallsDidFullyLoad(ApphudPaywalls paywalls) async {}

  @override
  Future<void> apphudDidReceivePurchase(dynamic purchase) async {}

  @override
  Future<void> apphudDidChangeUserID(String userId) async {}

  @override
  Future<void> apphudDidFecthProducts(
    List<ApphudProductComposite> products,
  ) async {}

  @override
  Future<void> apphudNonRenewingPurchasesUpdated(
    List<ApphudNonRenewingPurchase> purchases,
  ) async {}

  @override
  Future<void> userDidLoad(ApphudUser user) async {}
}

class AppHudService {
  static final AppHudService _instance = AppHudService._internal();
  factory AppHudService() => _instance;
  AppHudService._internal();

  bool _isInitialized = false;
  bool _hasActiveSubscription = false;
  _AppHudListenerImpl? _listener;

  String get apiKey => dotenv.env['APPHUD_API_KEY'] ?? '';
  String get placementId =>
      dotenv.env['APPHUD_PLACEMENT_ID'] ??
      dotenv.env['APPHUD_PAYWALL_ID'] ??
      '';

  Future<void> initialize({String? appsFlyerId}) async {
    if (_isInitialized) {
      LoggerService.info('AppHud already initialized');
      return;
    }

    if (apiKey.isEmpty) {
      LoggerService.warning(
        'AppHud API key is empty, skipping initialization. Check APPHUD_API_KEY in .env file.',
      );
      return;
    }

    try {
      LoggerService.info('Initializing AppHud...');
      await Apphud.enableDebugLogs();
      await Apphud.start(
        apiKey: apiKey,
        userID: 'C14DBEF5-A275-43D1-9DA9-CDAD67A663E6', // TODO: WILL DELETE
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.warning('AppHud initialization timeout');
          throw TimeoutException('AppHud initialization timeout');
        },
      );
      _isInitialized = true;
      LoggerService.info('AppHud initialized successfully');

      if (appsFlyerId != null) {
        await updateAttribution({
          'media_source': 'apps_flyer',
          'appsFlyerId': appsFlyerId,
        });
      }

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
        'AppHud initialization timed out, continuing without Apphud',
      );
    } catch (e) {
      LoggerService.error('Error initializing AppHud: $e', error: e);
      LoggerService.warning('Continuing without AppHud functionality');
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    if (!_isInitialized) {
      LoggerService.warning(
        'AppHud not initialized, cannot check subscription',
      );
      return false;
    }

    try {
      final hasActive = await Apphud.hasActiveSubscription();
      _hasActiveSubscription = hasActive;
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

  Future<ApphudPaywall?> getMainPaywall() async {
    if (!_isInitialized) {
      LoggerService.warning('AppHud not initialized, cannot get paywall');
      return null;
    }

    if (placementId.isEmpty) {
      LoggerService.warning('Placement ID is empty, cannot get paywall');
      return null;
    }

    try {
      LoggerService.info('Fetching placements...');
      final placementsResult = await Apphud.fetchPlacements();
      final placements = (placementsResult as dynamic).placements ?? [];

      LoggerService.info('Fetched ${placements.length} placements');

      final placement = placements.firstWhere(
        (p) => (p as dynamic).identifier == placementId,
        orElse: () => null,
      );

      if (placement == null) {
        LoggerService.warning('No placement found for ID: $placementId');
        final availableIds = placements
            .map((p) => (p as dynamic).identifier ?? 'unknown')
            .toList();
        LoggerService.info('Available placement IDs: $availableIds');
        return null;
      }

      final paywall = (placement as dynamic).paywall;
      if (paywall == null) {
        LoggerService.warning('No paywall in placement: $placementId');
        return null;
      }

      final paywallId = (paywall as dynamic).identifier ?? 'unknown';
      final products = (paywall as dynamic).products ?? [];
      LoggerService.info(
        'Fetched paywall: identifier=$paywallId, productsCount=${products.length}',
      );

      LoggerService.info('Paywall loaded successfully');
      return paywall as ApphudPaywall?;
    } catch (e) {
      LoggerService.error('Error fetching placements: $e', error: e);
      return null;
    }
  }

  Future<List<dynamic>> getProducts() async {
    if (!_isInitialized) {
      LoggerService.warning('AppHud not initialized, cannot get products');
      return [];
    }

    try {
      final paywall = await getMainPaywall();
      if (paywall == null) {
        LoggerService.warning('No paywall available, cannot get products');
        return [];
      }

      final products = paywall.products ?? [];
      LoggerService.info('Products loaded: ${products.length}');

      for (var i = 0; i < products.length; i++) {
        final product = products[i];
        final productId = product.productId;
        final skProduct = product.skProduct;

        if (Platform.isIOS && skProduct != null) {
          final price = skProduct.price;
          final currencyCode = skProduct.priceLocale.currencyCode;
          LoggerService.info(
            'Product[$i]: id=$productId, price=$price, currency=$currencyCode',
          );
        } else {
          LoggerService.info(
            'Product[$i]: id=$productId, platform=${Platform.isIOS ? "iOS" : "Android"}',
          );
        }
      }

      return products;
    } catch (e) {
      LoggerService.error('Error getting products: $e', error: e);
      return [];
    }
  }

  Future<bool> purchaseProduct(dynamic product) async {
    if (!_isInitialized) {
      LoggerService.warning('AppHud not initialized, cannot purchase');
      return false;
    }

    try {
      final apphudProduct = product as ApphudProduct;
      final productId = apphudProduct.productId;
      LoggerService.info('Purchasing product: $productId');
      final result = await Apphud.purchase(product: apphudProduct);

      if (result.error != null) {
        LoggerService.error('Purchase failed: ${result.error}');
        return false;
      }

      final isActive =
          (result.subscription?.isActive ?? false) ||
          (result.nonRenewingPurchase?.isActive ?? false);

      if (isActive) {
        _hasActiveSubscription = true;
        LoggerService.info('Purchase successful');
      } else {
        LoggerService.warning(
          'Purchase completed but subscription is not active',
        );
      }

      await checkSubscriptionStatus();

      return isActive;
    } catch (e) {
      LoggerService.error('Error purchasing product', error: e);
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    if (!_isInitialized) {
      LoggerService.warning('AppHud not initialized, cannot restore');
      return false;
    }

    try {
      LoggerService.info('Restoring purchases...');
      final result = await Apphud.restorePurchases();

      bool isActive = false;
      isActive = result.subscriptions.any((s) => s.isActive);

      if (isActive) {
        _hasActiveSubscription = true;
        LoggerService.info('Purchases restored successfully');
      } else {
        LoggerService.warning('No active subscriptions found');
      }

      await checkSubscriptionStatus();

      return isActive;
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
      final appsFlyerId = attributionData['appsFlyerId'];

      if (mediaSource != null) {
        final rawData = <String, dynamic>{
          'media_source': mediaSource,
          if (campaign != null) 'campaign': campaign,
          if (afStatus != null) 'af_status': afStatus,
          if (appsFlyerId != null) 'appsFlyerId': appsFlyerId,
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
}
