import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class ChipButton<T> extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ChipButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.secondaryBg,
      labelStyle: AppFonts.interMedium.copyWith(
        fontSize: 15,
        letterSpacing: -0.5,
        color: isSelected ? AppColors.primaryBg : AppColors.grayDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999),
        side: BorderSide(color: AppColors.transparent, width: 0),
      ),
      showCheckmark: false,
    );
  }
}
