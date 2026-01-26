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
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handlePurchase(String productId) async {
    final product = _products.firstWhere(
      (p) => (p as dynamic).productId == productId,
      orElse: () => _products.isNotEmpty ? _products.first : null,
    );

    if (product == null) return;

    final success = await _appHudService.purchaseProduct(product);
    if (success && mounted) {
      Navigator.of(context).pop();
      SnackbarService.showSuccess(
        context,
        message: 'Subscription activated successfully',
      );
    } else if (mounted) {
      SnackbarService.showError(context, message: 'Purchase failed');
    }
  }

  Future<void> _handleRestore() async {
    final success = await _appHudService.restorePurchases();
    if (success && mounted) {
      Navigator.of(context).pop();
      SnackbarService.showSuccess(
        context,
        message: 'Purchases restored successfully',
      );
    } else if (mounted) {
      SnackbarService.showWarning(context, message: 'No purchases to restore');
    }
  }

  String _getProductPrice(dynamic product) {
    if (product == null) return '\$0.00';
    final skProduct = (product as dynamic).skProduct;
    if (skProduct == null) return '\$0.00';

    final price = skProduct.price;
    final priceLocale = skProduct.priceLocale;
    // final currencyCode = priceLocale?.currencyCode ?? 'USD';
    final priceString = priceLocale?.currencySymbol ?? '\$';

    if (price != null) {
      return '$priceString${price.toStringAsFixed(2)}';
    }

    return skProduct.priceString ?? '\$0.00';
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
                appHudService: _appHudService,
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
