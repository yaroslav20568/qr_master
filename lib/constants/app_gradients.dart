import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_colors.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  static const LinearGradient qrCardLargeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  static const LinearGradient qrCardSmallGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  static const LinearGradient screenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryLight, AppColors.primaryBg],
  );

  static const LinearGradient scanningLineGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.transparent, AppColors.primary, AppColors.transparent],
    stops: [0.0, 0.5, 1.0],
  );
}
