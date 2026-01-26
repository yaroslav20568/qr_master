import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class SubscriptionCardBadge extends StatelessWidget {
  final String text;
  final Color? color;

  const SubscriptionCardBadge({
    super.key,
    required this.text,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(9999)),
      ),
      child: Text(
        text,
        style: AppFonts.interBold.copyWith(
          fontSize: 12,
          letterSpacing: -0.5,
          color: AppColors.primaryBg,
        ),
      ),
    );
  }
}
