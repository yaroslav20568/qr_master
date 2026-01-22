import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanResultCard extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultCard({super.key, required this.scanItem});

  Color _getIconColor() {
    switch (scanItem.type) {
      case QrCodeType.url:
        return AppColors.primary;
      case QrCodeType.phone:
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

  Widget _buildTypeSection() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight, width: 0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeSection(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Content',
                  style: AppFonts.interRegular.copyWith(
                    fontSize: 13,
                    height: 1.53,
                    letterSpacing: -0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scanItem.type == QrCodeType.wifi
                      ? QrContentParser.formatWifiContent(scanItem.content)
                      : scanItem.content.trim(),
                  style: AppFonts.interBold.copyWith(
                    fontSize: 15,
                    height: 1.53,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scanned',
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 13,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scanItem.timeAgo,
                    style: AppFonts.interBold.copyWith(
                      fontSize: 15,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Type',
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 13,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scanItem.type.displayName,
                    style: AppFonts.interBold.copyWith(
                      fontSize: 15,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
