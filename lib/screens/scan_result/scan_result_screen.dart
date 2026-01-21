import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanHistoryItem? scanItem;

  const ScanResultScreen({super.key, this.scanItem});

  @override
  Widget build(BuildContext context) {
    if (scanItem == null) {
      return ScreenLayout(
        child: Center(
          child: Text(
            'No scan result',
            style: AppFonts.interBold.copyWith(
              fontSize: 34,
              height: 1.5,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );
    }

    return ScreenLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan Result',
              style: AppFonts.interBold.copyWith(
                fontSize: 34,
                height: 1.5,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              scanItem!.content,
              style: AppFonts.interRegular.copyWith(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${scanItem!.type.displayName}',
              style: AppFonts.interRegular.copyWith(
                fontSize: 14,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
