import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final AppHudService _appHudService = AppHudService();
  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _appHudService.getProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      LoggerService.error('Error loading products: $e', error: e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        SnackbarService.showError(
          context,
          message: 'Failed to load subscription plans',
        );
      }
    }
  }

  Future<void> _handlePurchase(String productId) async {
    if (_products.isEmpty) {
      SnackbarService.showWarning(context, message: 'No products available');
      return;
    }

    final product = _products.firstWhere(
      (p) => (p as dynamic).productId == productId,
      orElse: () => _products.isNotEmpty ? _products.first : null,
    );

    if (product == null) {
      SnackbarService.showError(context, message: 'Product not found');
      return;
    }

    try {
      final success = await _appHudService.purchaseProduct(product);
      if (!mounted) return;

      if (success) {
        await _appHudService.checkSubscriptionStatus();
        if (!mounted) return;
        Navigator.of(context).pop(true);
        SnackbarService.showSuccess(
          context,
          message: 'Subscription activated successfully',
        );
      } else {
        SnackbarService.showError(
          context,
          message: 'Purchase failed. Please try again.',
        );
      }
    } catch (e) {
      LoggerService.error('Error during purchase: $e', error: e);
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'Purchase error. Please try again.',
        );
      }
    }
  }

  Future<void> _handleRestore() async {
    try {
      final success = await _appHudService.restorePurchases();
      if (!mounted) return;

      if (success) {
        await _appHudService.checkSubscriptionStatus();
        if (!mounted) return;
        Navigator.of(context).pop(true);
        SnackbarService.showSuccess(
          context,
          message: 'Purchases restored successfully',
        );
      } else {
        SnackbarService.showWarning(
          context,
          message: 'No purchases to restore',
        );
      }
    } catch (e) {
      LoggerService.error('Error restoring purchases: $e', error: e);
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to restore purchases',
        );
      }
    }
  }

  String _getProductPrice(dynamic product) {
    if (product == null) {
      LoggerService.warning('Product is null in _getProductPrice');
      return '\$0.00';
    }

    final skProduct = (product as dynamic).skProduct;
    if (skProduct == null) {
      LoggerService.warning('skProduct is null in _getProductPrice');
      return '\$0.00';
    }

    final price = skProduct.price;
    final priceLocale = skProduct.priceLocale;
    final currencyCode = priceLocale?.currencyCode ?? 'USD';
    final currencySymbol = priceLocale?.currencySymbol ?? '\$';
    final priceString = skProduct.priceString;

    LoggerService.info(
      'Getting product price: price=$price, currencyCode=$currencyCode, currencySymbol=$currencySymbol, priceString=$priceString',
    );

    if (priceString != null && priceString.isNotEmpty) {
      return priceString;
    }

    if (price != null) {
      return '$currencySymbol${price.toStringAsFixed(2)}';
    }

    LoggerService.warning('No price available for product');
    return '\$0.00';
  }

  String _getProductPeriod(String productId) {
    if (productId.contains('weekly')) return '/ week';
    if (productId.contains('monthly')) return '/ month';
    if (productId.contains('yearly')) return '/ year';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      gradient: AppGradients.screenGradient,
      child: SingleChildScrollView(
        child: PaddingLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionNavigation(onRestore: _handleRestore),
              const SizedBox(height: 24),
              const SubscriptionHeader(),
              const SizedBox(height: 32),
              const SubscriptionFeatureList(),
              const SizedBox(height: 32),
              SubscriptionPlanList(
                isLoading: _isLoading,
                products: _products,
                selectedProductId: _selectedProductId,
                onProductSelected: (productId) {
                  setState(() {
                    _selectedProductId = productId;
                  });
                },
                getProductPrice: _getProductPrice,
                getProductPeriod: _getProductPeriod,
              ),
              const SizedBox(height: 32),
              Button(
                text: 'Continue',
                onPressed: _selectedProductId != null
                    ? () => _handlePurchase(_selectedProductId!)
                    : () {
                        if (_products.isNotEmpty) {
                          final firstProduct = _products.first;
                          final productId =
                              (firstProduct as dynamic).productId ?? '';
                          _handlePurchase(productId);
                        } else {
                          SnackbarService.showWarning(
                            context,
                            message: 'Please select a plan',
                          );
                        }
                      },
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              const SubscriptionFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
