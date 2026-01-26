import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isTopCenterBadge && badge != null) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor ?? AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge!,
                          style: AppFonts.interMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.primaryBg,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ] else if (!isTopRightBadge) ...[
                    const SizedBox(height: 0),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppFonts.interSemiBold.copyWith(
                      fontSize: 20,
                      height: 1.3,
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
                              fontSize: 32,
                              height: 1.2,
                              letterSpacing: -0.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              period,
                              style: AppFonts.interRegular.copyWith(
                                fontSize: 16,
                                height: 1.5,
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
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            if (savings != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                savings!,
                                style: AppFonts.interMedium.copyWith(
                                  fontSize: 16,
                                  height: 1.5,
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
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: AppFonts.interRegular.copyWith(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isTopRightBadge && badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppColors.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: AppFonts.interMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.primaryBg,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
