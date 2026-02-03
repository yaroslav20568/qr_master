import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/create_qr_screen/create_qr_design_options/index.dart';

class CreateQrDesignOptions extends StatelessWidget {
  final Color selectedColor;
  final Uint8List? selectedLogo;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onLogoSelected;
  final VoidCallback onLogoRemoved;

  const CreateQrDesignOptions({
    super.key,
    required this.selectedColor,
    this.selectedLogo,
    required this.onColorSelected,
    required this.onLogoSelected,
    required this.onLogoRemoved,
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
              if (selectedLogo != null)
                GestureDetector(
                  onTap: onLogoRemoved,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(selectedLogo!, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Remove Logo',
                        style: AppFonts.interMedium.copyWith(
                          fontSize: 15,
                          letterSpacing: -0.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: onLogoSelected,
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
