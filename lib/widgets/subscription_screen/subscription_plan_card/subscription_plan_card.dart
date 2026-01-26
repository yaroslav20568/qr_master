import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/subscription_screen/subscription_plan_card/subscription_card_badge.dart';

enum BadgePosition { topCenter, topRight }

class SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String productId;
  final String price;
  final String period;
  final String? badge;
  final Color? badgeColor;
  final BadgePosition? badgePosition;
  final String? subtitle;
  final String? oldPrice;
  final String? savings;
  final bool isSelected;
  final VoidCallback onTap;

  const SubscriptionPlanCard({
    super.key,
    required this.title,
    required this.productId,
    required this.price,
    required this.period,
    this.badge,
    this.badgeColor,
    this.badgePosition,
    this.subtitle,
    this.oldPrice,
    this.savings,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTopCenterBadge = badgePosition == BadgePosition.topCenter;
    final isTopRightBadge = badgePosition == BadgePosition.topRight;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  offset: Offset(0, 4),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppFonts.interSemiBold.copyWith(
                      fontSize: 22,
                      height: 1.5,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: AppFonts.interBold.copyWith(
                              fontSize: 28,
                              height: 1.5,
                              letterSpacing: -0.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              period,
                              style: AppFonts.interRegular.copyWith(
                                fontSize: 17,
                                height: 1.53,
                                letterSpacing: -0.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (oldPrice != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              oldPrice!,
                              style: AppFonts.interRegular.copyWith(
                                fontSize: 15,
                                height: 1.53,
                                color: AppColors.grayMiddle,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColors.grayMiddle,
                              ),
                            ),
                            if (savings != null) ...[
                              const SizedBox(width: 10),
                              Text(
                                savings!,
                                style: AppFonts.interSemiBold.copyWith(
                                  fontSize: 15,
                                  height: 1.53,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: AppFonts.interRegular.copyWith(
                        fontSize: 15,
                        height: 1.53,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (isTopCenterBadge && badge != null) ...[
          Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: Center(
              child: SubscriptionCardBadge(text: badge!, color: badgeColor),
            ),
          ),
        ],
        if (isTopRightBadge && badge != null)
          Positioned(
            top: -8,
            right: 16,
            child: SubscriptionCardBadge(
              text: badge!,
              color: badgeColor ?? AppColors.success,
            ),
          ),
      ],
    );
  }
}
