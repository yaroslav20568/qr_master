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
      return Column(
        children: [
          SubscriptionPlanCard(
            title: 'Weekly Plan',
            productId: appHudService.productWeekly,
            price: '\$3.99',
            period: '/ week',
            badge: 'MOST POPULAR',
            badgeColor: AppColors.primary,
            badgePosition: BadgePosition.topCenter,
            subtitle: '3-day free trial',
            isSelected: selectedProductId == appHudService.productWeekly,
            onTap: () => onProductSelected(appHudService.productWeekly),
          ),
          const SizedBox(height: 16),
          SubscriptionPlanCard(
            title: 'Monthly Plan',
            productId: appHudService.productMonthly,
            price: '\$7.99',
            period: '/ month',
            subtitle: 'Cancel anytime',
            isSelected: selectedProductId == appHudService.productMonthly,
            onTap: () => onProductSelected(appHudService.productMonthly),
          ),
          const SizedBox(height: 16),
          SubscriptionPlanCard(
            title: 'Yearly Plan',
            productId: appHudService.productYearly.isNotEmpty
                ? appHudService.productYearly
                : 'yearly',
            price: '\$29.99',
            period: '/ year',
            badge: 'SAVE 70%',
            badgeColor: AppColors.success,
            badgePosition: BadgePosition.topRight,
            oldPrice: '\$99.99',
            savings: 'Save \$70',
            subtitle: 'Best value option',
            isSelected: appHudService.productYearly.isNotEmpty
                ? selectedProductId == appHudService.productYearly
                : selectedProductId == 'yearly',
            onTap: () => onProductSelected(
              appHudService.productYearly.isNotEmpty
                  ? appHudService.productYearly
                  : 'yearly',
            ),
          ),
        ],
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
