import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class RecentActivityItem extends StatelessWidget {
  final ScanHistoryItem item;
  final VoidCallback onTap;

  const RecentActivityItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  Color _getIconColor() {
    switch (item.type) {
      case QrCodeType.url:
        return AppColors.primary;
      case QrCodeType.wifi:
        return AppColors.success;
      case QrCodeType.phone:
        return AppColors.warning;
      case QrCodeType.text:
        return AppColors.primary;
    }
  }

  String _getActionText() {
    switch (item.action) {
      case ScanHistoryAction.scanned:
        return 'Scanned';
      case ScanHistoryAction.created:
        return 'Created';
      case ScanHistoryAction.shared:
        return 'Shared';
    }
  }

  String _getTypeText() {
    switch (item.type) {
      case QrCodeType.url:
        return 'website link';
      case QrCodeType.wifi:
        return 'WiFi QR';
      case QrCodeType.phone:
        return 'phone QR';
      case QrCodeType.text:
        return 'text message';
    }
  }

  String _getDisplayTitle() {
    final actionText = _getActionText();
    final typeText = _getTypeText();
    return '$actionText $typeText';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            BackgroundCircleIcon(
              size: 40,
              backgroundColor: _getIconColor(),
              child: SvgPicture.asset(
                'assets/icons/qr_code_icon.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBg,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getDisplayTitle(),
                    style: AppFonts.interMedium.copyWith(
                      fontSize: 17,
                      height: 26 / 17,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    item.timeAgo,
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 15,
                      height: 23 / 15,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/chevron_right_icon.svg',
              width: 7,
              height: 13,
            ),
          ],
        ),
      ),
    );
  }
}
