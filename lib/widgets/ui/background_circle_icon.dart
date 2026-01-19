import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class BackgroundCircleIcon extends StatelessWidget {
  final Widget child;
  final double? size;
  final Color? backgroundColor;

  const BackgroundCircleIcon({
    super.key,
    required this.child,
    this.size = 48,
    this.backgroundColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}
