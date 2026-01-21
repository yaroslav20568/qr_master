import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/index.dart';

class ScanCameraControlButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ScanCameraControlButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BackgroundCircleIcon(
            size: 48,
            backgroundColor: isActive
                ? AppColors.primary
                : AppColors.secondaryBg,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.primaryBg : AppColors.grayDark,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppFonts.interMedium.copyWith(
              fontSize: 13,
              height: 1.53,
              letterSpacing: -0.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
