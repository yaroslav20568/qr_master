import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanResultTypeSection extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultTypeSection({super.key, required this.scanItem});

  Color _getIconColor() {
    switch (scanItem.type) {
      case QrCodeType.url:
        return AppColors.primary;
      case QrCodeType.phone:
        return AppColors.warning;
      case QrCodeType.email:
        return AppColors.primary;
      case QrCodeType.contact:
        return AppColors.warning;
      case QrCodeType.wifi:
        return AppColors.success;
      case QrCodeType.text:
        return AppColors.primary;
    }
  }

  Widget _getIcon() {
    switch (scanItem.type) {
      case QrCodeType.url:
        return SvgPicture.asset(
          'assets/icons/link_icon.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryBg,
            BlendMode.srcIn,
          ),
        );
      case QrCodeType.phone:
        return const Icon(Icons.phone, size: 20, color: AppColors.primaryBg);
      case QrCodeType.email:
        return const Icon(Icons.email, size: 20, color: AppColors.primaryBg);
      case QrCodeType.contact:
        return const Icon(Icons.person, size: 20, color: AppColors.primaryBg);
      case QrCodeType.wifi:
        return const Icon(Icons.wifi, size: 20, color: AppColors.primaryBg);
      case QrCodeType.text:
        return const Icon(
          Icons.text_fields,
          size: 20,
          color: AppColors.primaryBg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BackgroundCircleIcon(
              size: 40,
              backgroundColor: _getIconColor(),
              child: _getIcon(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    QrContentParser.getSectionTitle(scanItem.type),
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 13,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    QrContentParser.getDisplayContent(
                      scanItem.content,
                      scanItem.type,
                    ),
                    style: AppFonts.interBold.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: AppColors.border),
        const SizedBox(height: 16),
      ],
    );
  }
}
