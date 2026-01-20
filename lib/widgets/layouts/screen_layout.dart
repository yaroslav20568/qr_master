import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/utils/responsive_utils.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool paddingZero;

  const ScreenLayout({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.secondaryBg,
    this.gradient,
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

    final body = SafeArea(
      child: Padding(padding: padding, child: child),
    );

    if (gradient != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: body,
        ),
      );
    }

    return Scaffold(backgroundColor: backgroundColor, body: body);
  }
}
