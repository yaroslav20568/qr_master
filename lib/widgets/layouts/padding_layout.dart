import 'package:flutter/material.dart';
import 'package:qr_master/utils/responsive_utils.dart';

class PaddingLayout extends StatelessWidget {
  final Widget child;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool paddingZero;

  const PaddingLayout({
    super.key,
    required this.child,
    this.paddingTop = 24.0,
    this.paddingBottom = 24.0,
    this.paddingLeft = 24.0,
    this.paddingRight = 24.0,
    this.paddingZero = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallHeight = context.isSmallHeight;

    final padding = paddingZero
        ? EdgeInsets.zero
        : EdgeInsets.only(
            top: isSmallHeight ? paddingTop * 0.5 : paddingTop,
            bottom: isSmallHeight ? paddingBottom * 0.5 : paddingBottom,
            left: isSmallHeight ? paddingLeft * 0.5 : paddingLeft,
            right: isSmallHeight ? paddingRight * 0.5 : paddingRight,
          );

    return SafeArea(
      child: Padding(padding: padding, child: child),
    );
  }
}
