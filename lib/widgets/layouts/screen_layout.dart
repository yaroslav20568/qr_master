import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final String? title;
  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;
  final Color? iconColor;
  final Widget? bottomNavigationBar;
  final Widget? headerContent;

  const ScreenLayout({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.secondaryBg,
    this.gradient,
    this.title,
    this.rightIcon,
    this.onRightIconTap,
    this.iconColor,
    this.bottomNavigationBar,
    this.headerContent,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;

    if (title != null) {
      body = Column(
        children: [
          ScreenHeader(
            title: title!,
            rightIcon: rightIcon,
            onRightIconTap: onRightIconTap,
            iconColor: iconColor,
            content: headerContent,
          ),
          Expanded(child: child),
        ],
      );
    }

    if (gradient != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: SafeArea(child: body),
        ),
        bottomNavigationBar: bottomNavigationBar,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
