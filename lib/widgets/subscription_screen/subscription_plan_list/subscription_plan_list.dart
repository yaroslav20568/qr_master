import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/subscription_screen/subscription_plan_list/subscription_plan_card/subscription_plan_card.dart';

class SubscriptionPlanList extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> products;
  final String? selectedProductId;
  final AppHudService appHudService;
  final Function(String) onProductSelected;
  final String Function(dynamic) getProductPrice;
  final String Function(String) getProductPeriod;

  const SubscriptionPlanList({
    super.key,
    required this.isLoading,
    required this.products,
    required this.selectedProductId,
    required this.appHudService,
    required this.onProductSelected,
    required this.getProductPrice,
    required this.getProductPeriod,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      LoggerService.warning('No products available, showing empty state');
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No subscription plans available.\nPlease check your Apphud configuration.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...products.map((product) {
          final productId = (product as dynamic).productId ?? '';
          final price = getProductPrice(product);
          final period = getProductPeriod(productId);
          final isWeekly = productId.contains('weekly');
          final isMonthly = productId.contains('monthly');
          final isYearly = productId.contains('yearly');

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
              isSelected: selectedProductId == productId,
              onTap: () => onProductSelected(productId),
            ),
          );
        }),
      ],
    );
  }
}
