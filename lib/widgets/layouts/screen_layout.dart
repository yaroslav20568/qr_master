import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;

  const ScreenLayout({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.secondaryBg,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: child,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: child),
    );
  }
}
