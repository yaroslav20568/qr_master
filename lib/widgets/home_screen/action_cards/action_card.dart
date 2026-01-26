import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ActionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BackgroundCircleIcon(
              size: 64,
              backgroundColor: iconBackgroundColor,
              child: SvgPicture.asset(iconPath),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: AppFonts.interSemiBold.copyWith(
                fontSize: 17,
                height: 1.21,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppFonts.interRegular.copyWith(
                fontSize: 13,
                height: 1.21,
                letterSpacing: -0.5,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
