import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class ColorOptionButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOptionButton({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.grayLight : AppColors.border,
            width: isSelected ? 3 : 1,
          ),
        ),
      ),
    );
  }
}
