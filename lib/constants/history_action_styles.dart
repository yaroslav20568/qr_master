import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/app_colors.dart';
import 'package:qr_master/models/index.dart';

class HistoryActionStyles {
  static Color getBackgroundColor(ScanHistoryAction action) {
    switch (action) {
      case ScanHistoryAction.scanned:
        return AppColors.primary;
      case ScanHistoryAction.created:
        return AppColors.success;
      case ScanHistoryAction.shared:
        return AppColors.warning;
    }
  }

  static Widget getIcon(ScanHistoryAction action) {
    switch (action) {
      case ScanHistoryAction.scanned:
        return SvgPicture.asset(
          'assets/icons/qr_code_icon.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryBg,
            BlendMode.srcIn,
          ),
        );
      case ScanHistoryAction.created:
        return SvgPicture.asset(
          'assets/icons/add.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryBg,
            BlendMode.srcIn,
          ),
        );
      case ScanHistoryAction.shared:
        return SvgPicture.asset(
          'assets/icons/result_actions/share_icon.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryBg,
            BlendMode.srcIn,
          ),
        );
    }
  }
}
