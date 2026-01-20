import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/home_screen/recent_activity/recent_activity_item.dart';

class RecentActivity extends StatelessWidget {
  final Function(ScanHistoryItem)? onItemTap;

  const RecentActivity({super.key, this.onItemTap});

  static List<ScanHistoryItem> get _mockItems => [
    ScanHistoryItem(
      id: '1',
      content: 'https://example.com',
      type: QrCodeType.url,
      action: ScanHistoryAction.scanned,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    ScanHistoryItem(
      id: '2',
      content: 'WIFI:T:WPA;S:MyNetwork;P:password123;;',
      type: QrCodeType.wifi,
      action: ScanHistoryAction.created,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ScanHistoryItem(
      id: '3',
      content: 'BEGIN:VCARD\nFN:John Doe\nEND:VCARD',
      type: QrCodeType.contact,
      action: ScanHistoryAction.shared,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ScanHistoryItem(
      id: '4',
      content: 'Hello, this is a text message',
      type: QrCodeType.text,
      action: ScanHistoryAction.scanned,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = _mockItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppFonts.interSemiBold.copyWith(
            fontSize: 22,
            height: 1.5,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RecentActivityItem(
                    item: item,
                    onTap: () => onItemTap?.call(item),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
