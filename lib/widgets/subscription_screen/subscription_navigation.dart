import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/index.dart';

class SubscriptionNavigation extends StatelessWidget {
  final VoidCallback onRestore;

  const SubscriptionNavigation({super.key, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: BackgroundCircleIcon(
            size: 40,
            backgroundColor: AppColors.primaryBg,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              color: AppColors.grayDark,
              iconSize: 20,
            ),
          ),
        ),
        TextButton(
          onPressed: onRestore,
          child: Text(
            'Restore',
            style: AppFonts.interMedium.copyWith(
              fontSize: 17,
              letterSpacing: -0.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
