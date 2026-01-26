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
    return (product as dynamic).skProduct?.priceString ?? '\$0.00';
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
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_products.isEmpty) ...[
                SubscriptionPlanCard(
                  title: 'Weekly Plan',
                  productId: _appHudService.productWeekly,
                  price: '\$3.99',
                  period: '/ week',
                  badge: 'MOST POPULAR',
                  badgeColor: AppColors.primary,
                  badgePosition: BadgePosition.topCenter,
                  subtitle: '3-day free trial',
                  isSelected:
                      _selectedProductId == _appHudService.productWeekly,
                  onTap: () {
                    setState(() {
                      _selectedProductId = _appHudService.productWeekly;
                    });
                  },
                ),
                const SizedBox(height: 12),
                SubscriptionPlanCard(
                  title: 'Monthly Plan',
                  productId: _appHudService.productMonthly,
                  price: '\$7.99',
                  period: '/ month',
                  subtitle: 'Cancel anytime',
                  isSelected:
                      _selectedProductId == _appHudService.productMonthly,
                  onTap: () {
                    setState(() {
                      _selectedProductId = _appHudService.productMonthly;
                    });
                  },
                ),
                const SizedBox(height: 12),
                SubscriptionPlanCard(
                  title: 'Yearly Plan',
                  productId: _appHudService.productYearly.isNotEmpty
                      ? _appHudService.productYearly
                      : 'yearly',
                  price: '\$29.99',
                  period: '/ year',
                  badge: 'SAVE 70%',
                  badgeColor: AppColors.success,
                  badgePosition: BadgePosition.topRight,
                  oldPrice: '\$99.99',
                  savings: 'Save \$70',
                  subtitle: 'Best value option',
                  isSelected: _appHudService.productYearly.isNotEmpty
                      ? _selectedProductId == _appHudService.productYearly
                      : _selectedProductId == 'yearly',
                  onTap: () {
                    setState(() {
                      _selectedProductId =
                          _appHudService.productYearly.isNotEmpty
                          ? _appHudService.productYearly
                          : 'yearly';
                    });
                  },
                ),
              ] else ...[
                ..._products.map((product) {
                  final productId = (product as dynamic).productId ?? '';
                  final price = _getProductPrice(product);
                  final period = _getProductPeriod(productId);
                  final isWeekly = productId.contains('weekly');
                  final isMonthly = productId.contains('monthly');
                  final isYearly = productId.contains('yearly');

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SubscriptionPlanCard(
                      title: isWeekly
                          ? 'Weekly Plan'
                          : isMonthly
                          ? 'Monthly Plan'
                          : 'Yearly Plan',
                      productId: productId,
                      price: price,
                      period: period,
                      badge: isWeekly
                          ? 'MOST POPULAR'
                          : isYearly
                          ? 'SAVE 70%'
                          : null,
                      badgeColor: isWeekly
                          ? AppColors.primary
                          : isYearly
                          ? AppColors.success
                          : null,
                      badgePosition: isWeekly
                          ? BadgePosition.topCenter
                          : isYearly
                          ? BadgePosition.topRight
                          : null,
                      oldPrice: isYearly ? '\$99.99' : null,
                      savings: isYearly ? 'Save \$70' : null,
                      subtitle: isWeekly
                          ? '3-day free trial'
                          : isMonthly
                          ? 'Cancel anytime'
                          : 'Best value option',
                      isSelected: _selectedProductId == productId,
                      onTap: () {
                        setState(() {
                          _selectedProductId = productId;
                        });
                      },
                    ),
                  );
                }),
              ],
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
