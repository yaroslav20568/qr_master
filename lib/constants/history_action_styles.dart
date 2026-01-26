import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/app_assets.dart';
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
          '${AppAssets.iconsPath}qr_code_icon.svg',
          width: 13,
          height: 13,
        );
      case ScanHistoryAction.created:
        return SvgPicture.asset(
          '${AppAssets.iconsPath}add_icon.svg',
          width: 20,
          height: 20,
        );
      case ScanHistoryAction.shared:
        return SvgPicture.asset('${AppAssets.iconsPath}share_icon.svg');
    }
  }
}
