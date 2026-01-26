import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/create_qr_screen/create_qr_design_options/index.dart';

class CreateQrDesignOptions extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const CreateQrDesignOptions({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            offset: Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Color',
                style: AppFonts.interMedium.copyWith(
                  fontSize: 15,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  ColorOptionButton(
                    color: AppColors.black,
                    isSelected:
                        selectedColor.toARGB32() == AppColors.black.toARGB32(),
                    onTap: () => onColorSelected(AppColors.black),
                  ),
                  const SizedBox(width: 8),
                  ColorOptionButton(
                    color: AppColors.primary,
                    isSelected:
                        selectedColor.toARGB32() ==
                        AppColors.primary.toARGB32(),
                    onTap: () => onColorSelected(AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  ColorOptionButton(
                    color: AppColors.success,
                    isSelected:
                        selectedColor.toARGB32() ==
                        AppColors.success.toARGB32(),
                    onTap: () => onColorSelected(AppColors.success),
                  ),
                  const SizedBox(width: 8),
                  ColorOptionButton(
                    color: AppColors.warning,
                    isSelected:
                        selectedColor.toARGB32() ==
                        AppColors.warning.toARGB32(),
                    onTap: () => onColorSelected(AppColors.warning),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  final appHudService = AppHudService();
                  if (appHudService.hasActiveSubscription) {
                    SnackbarService.showInfo(
                      context,
                      message: 'Add logo feature coming soon',
                    );
                  } else {
                    Navigator.of(context).pushNamed(AppRoutes.subscription);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Add Logo',
                      style: AppFonts.interMedium.copyWith(
                        fontSize: 15,
                        letterSpacing: -0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Pro Feature',
                style: AppFonts.interRegular.copyWith(
                  fontSize: 13,
                  height: 1.54,
                  letterSpacing: -0.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
