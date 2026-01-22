import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/create_qr_screen/create_qr_design_options/index.dart';

class CreateQrDesignOptions extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback? onAddLogo;

  const CreateQrDesignOptions({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.onAddLogo,
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
                    color: const Color(0xFF000000),
                    isSelected:
                        selectedColor.toARGB32() ==
                        const Color(0xFF000000).toARGB32(),
                    onTap: () => onColorSelected(const Color(0xFF000000)),
                  ),
                  const SizedBox(width: 8),
                  ColorOptionButton(
                    color: const Color(0xFF7ACBFF),
                    isSelected:
                        selectedColor.toARGB32() ==
                        const Color(0xFF7ACBFF).toARGB32(),
                    onTap: () => onColorSelected(const Color(0xFF7ACBFF)),
                  ),
                  const SizedBox(width: 8),
                  ColorOptionButton(
                    color: const Color(0xFF77C97E),
                    isSelected:
                        selectedColor.toARGB32() ==
                        const Color(0xFF77C97E).toARGB32(),
                    onTap: () => onColorSelected(const Color(0xFF77C97E)),
                  ),
                  const SizedBox(width: 8),
                  ColorOptionButton(
                    color: const Color(0xFFFFB86C),
                    isSelected:
                        selectedColor.toARGB32() ==
                        const Color(0xFFFFB86C).toARGB32(),
                    onTap: () => onColorSelected(const Color(0xFFFFB86C)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onAddLogo != null)
                GestureDetector(
                  onTap: onAddLogo,
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
