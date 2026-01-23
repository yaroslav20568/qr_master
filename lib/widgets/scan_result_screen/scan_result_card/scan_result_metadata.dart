import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanResultMetadata extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultMetadata({super.key, required this.scanItem});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            TimeAgoText(
              timestamp: scanItem.timestamp,
              style: AppFonts.interMedium.copyWith(
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
            Text(
              scanItem.type.displayName,
              style: AppFonts.interMedium.copyWith(
                fontSize: 15,
                height: 1.53,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
