import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class ActionsDropdownItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const ActionsDropdownItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  });

  Color get _defaultBackgroundColor {
    if (title.toLowerCase().contains('share')) {
      return AppColors.success;
    } else if (title.toLowerCase().contains('delete')) {
      return AppColors.warning;
    }
    return AppColors.primary;
  }

  Color get effectiveBackgroundColor =>
      backgroundColor ?? _defaultBackgroundColor;
}
