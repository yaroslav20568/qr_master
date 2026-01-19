import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class Dot extends StatelessWidget {
  final double size;
  final double opacity;
  final Color color;

  const Dot({
    super.key,
    this.size = 8,
    this.opacity = 1.0,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
