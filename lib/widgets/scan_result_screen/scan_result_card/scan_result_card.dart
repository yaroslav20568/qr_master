import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/scan_result_screen/scan_result_card/scan_result_full_content.dart';
import 'package:qr_master/widgets/scan_result_screen/scan_result_card/scan_result_metadata.dart';
import 'package:qr_master/widgets/scan_result_screen/scan_result_card/scan_result_type_section.dart';

class ScanResultCard extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultCard({super.key, required this.scanItem});

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
          ScanResultTypeSection(scanItem: scanItem),
          ScanResultFullContent(scanItem: scanItem),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          const SizedBox(height: 16),
          ScanResultMetadata(scanItem: scanItem),
        ],
      ),
    );
  }
}
