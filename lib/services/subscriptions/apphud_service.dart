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
  final String? expectedPlacementId;

  _AppHudListenerImpl(
    this.onSubscriptionStatusChanged, [
    this.expectedPlacementId,
  ]);

  @override
  Future<void> apphudSubscriptionsUpdated(
    List<ApphudSubscriptionWrapper> subscriptions,
  ) async {
    LoggerService.info(
      'Subscriptions updated: ${subscriptions.length} subscriptions',
    );
    for (var i = 0; i < subscriptions.length; i++) {
      final sub = subscriptions[i];
      final productId = (sub as dynamic).productId ?? 'unknown';
      final isActive = sub.isActive;
      final status = (sub as dynamic).status?.toString() ?? 'unknown';
      LoggerService.info(
        'Subscription[$i]: productId=$productId, isActive=$isActive, status=$status',
      );
    }
    final hasActive = subscriptions.any((sub) => sub.isActive);
    onSubscriptionStatusChanged(hasActive);
  }

  @override
  Future<void> paywallsDidFullyLoad(ApphudPaywalls paywalls) async {
    LoggerService.info(
      'Paywalls fully loaded: ${paywalls.paywalls.length} paywalls',
    );
    for (var i = 0; i < paywalls.paywalls.length; i++) {
      final paywall = paywalls.paywalls[i];
      final identifier = paywall.identifier;
      final productsCount = paywall.products?.length ?? 0;
      LoggerService.info(
        'Paywall[$i]: identifier=$identifier, productsCount=$productsCount',
      );
    }
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
    for (var i = 0; i < products.length; i++) {
      final product = products[i];
      final productId = (product as dynamic).productId ?? 'unknown';
      final skProduct = (product as dynamic).skProduct;
      if (skProduct != null) {
        final price = skProduct.price;
        final currencyCode = skProduct.priceLocale?.currencyCode ?? 'unknown';
        LoggerService.info(
          'Fetched Product[$i]: id=$productId, price=$price, currency=$currencyCode',
        );
      } else {
        LoggerService.warning(
          'Fetched Product[$i]: id=$productId, skProduct is null',
        );
      }
    }
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
    if (placements.isEmpty) {
      LoggerService.warning(
        'No placements loaded. Check Apphud dashboard: ensure placements are created and configured.',
      );
    } else {
      final placementIds = <String>[];
      for (var i = 0; i < placements.length; i++) {
        final placement = placements[i];
        final identifier = (placement as dynamic).identifier ?? 'unknown';
        final paywall = (placement as dynamic).paywall;
        final paywallId = paywall != null
            ? (paywall as dynamic).identifier ?? 'unknown'
            : 'null';
        final productsCount = paywall != null
            ? ((paywall as dynamic).products ?? []).length
            : 0;
        placementIds.add(identifier);
        LoggerService.info(
          'Placement[$i]: identifier=$identifier, paywallId=$paywallId, productsCount=$productsCount',
        );
      }
      LoggerService.info('All loaded placement IDs: $placementIds');
      if (expectedPlacementId != null &&
          !placementIds.contains(expectedPlacementId)) {
        LoggerService.warning(
          'Requested placement "$expectedPlacementId" not found in loaded placements. Available: $placementIds',
        );
      }
    }
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
  String get placementId => dotenv.env['APPHUD_PAYWALL_ID'] ?? '';
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
    if (!_isInitialized) {
      LoggerService.warning('AppHud not initialized, cannot get products');
      return [];
    }

    if (placementId.isEmpty) {
      LoggerService.warning('Placement ID is empty, cannot get products');
      return [];
    }

    try {
      LoggerService.info('Getting products from placement: $placementId');

      dynamic placement;
      try {
        placement = await Apphud.placement(placementId);
      } catch (e) {
        LoggerService.warning('Error getting placement via API: $e');
      }

      if (placement == null) {
        LoggerService.warning('No placement found: $placementId');
        final availablePlacements = await _getAvailablePlacements();
        LoggerService.info('Available placements: $availablePlacements');
        LoggerService.warning(
          'Troubleshooting: 1) Check Apphud dashboard - placement "$placementId" must exist. '
          '2) Verify APPHUD_PAYWALL_ID in .env matches placement identifier (not paywall identifier). '
          '3) Ensure placement has paywall assigned with products configured.',
        );
        return [];
      }
      final paywall = (placement as dynamic).paywall;
      if (paywall == null) {
        LoggerService.warning('No paywall in placement: $placementId');
        return [];
      }
      final products = (paywall as dynamic).products ?? [];
      LoggerService.info('Products loaded: ${products.length}');

      for (var i = 0; i < products.length; i++) {
        final product = products[i];
        final productId = (product as dynamic).productId ?? 'unknown';
        final skProduct = (product as dynamic).skProduct;

        if (skProduct != null) {
          final price = skProduct.price;
          final priceLocale = skProduct.priceLocale;
          final currencyCode = priceLocale?.currencyCode ?? 'unknown';
          final currencySymbol = priceLocale?.currencySymbol ?? '\$';
          final priceString = skProduct.priceString ?? 'unknown';

          LoggerService.info(
            'Product[$i]: id=$productId, price=$price, currency=$currencyCode, symbol=$currencySymbol, priceString=$priceString',
          );
        } else {
          LoggerService.warning(
            'Product[$i]: id=$productId, skProduct is null',
          );
        }
      }

      return products;
    } catch (e) {
      LoggerService.error('Error getting products: $e', error: e);
      LoggerService.warning('Using fallback: returning empty products list');
      return [];
    }
  }

  Future<String> _getAvailablePlacements() async {
    try {
      final placements = await Apphud.placements();
      if (placements.isEmpty) {
        return 'No placements available. Check Apphud dashboard: ensure placements are created and products are configured.';
      }
      final placementIds = placements
          .map((p) => (p as dynamic).identifier ?? 'unknown')
          .toList();
      return 'Available placements: $placementIds';
    } catch (e) {
      LoggerService.warning('Error getting placements: $e');
      return 'Error getting placements. Check Apphud dashboard configuration.';
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
    }, placementId.isNotEmpty ? placementId : null);
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
