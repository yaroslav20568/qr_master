import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanResultFullContent extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultFullContent({super.key, required this.scanItem});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          scanItem.type == QrCodeType.url
              ? GestureDetector(
                  onTap: () async {
                    try {
                      final uri = UrlUtils.normalizeUrl(scanItem.content);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    } catch (e) {
                      LoggerService.error('Error opening URL', error: e);
                    }
                  },
                  child: Text(
                    scanItem.content.trim(),
                    style: AppFonts.interBold.copyWith(
                      fontSize: 15,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
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
    );
  }
}
