import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

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
    this.backgroundColor = AppColors.primaryBg,
    this.gradient,
    this.paddingTop = 24.0,
    this.paddingBottom = 24.0,
    this.paddingLeft = 24.0,
    this.paddingRight = 24.0,
    this.paddingZero = false,
  });

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: Padding(
        padding: paddingZero
            ? EdgeInsets.zero
            : EdgeInsets.only(
                top: paddingTop,
                bottom: paddingBottom,
                left: paddingLeft,
                right: paddingRight,
              ),
        child: child,
      ),
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
