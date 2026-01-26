import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';

class ContentTypeButton extends StatelessWidget {
  final QrCodeType type;
  final QrCodeType selectedType;
  final Object icon;
  final String label;
  final VoidCallback onTap;

  const ContentTypeButton({
    super.key,
    required this.type,
    required this.selectedType,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBg : AppColors.secondaryBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.grayLight : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon is String)
                SvgPicture.asset(
                  icon as String,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.dark : AppColors.grayDark,
                    BlendMode.srcIn,
                  ),
                )
              else if (icon is IconData)
                Icon(
                  icon as IconData,
                  size: 20,
                  color: isSelected ? AppColors.dark : AppColors.grayDark,
                ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppFonts.interMedium.copyWith(
                  fontSize: 15,
                  letterSpacing: -0.5,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
