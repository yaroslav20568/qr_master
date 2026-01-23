import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/home_screen/recent_activity/recent_activity_item.dart';
import 'package:qr_master/widgets/ui/index.dart';

class RecentActivity extends StatelessWidget {
  final Function(ScanHistoryItem)? onItemTap;

  const RecentActivity({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

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
        StreamBuilder<List<ScanHistoryItem>>(
          stream: firestoreService.getScanHistoryStream(limit: 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const EmptyData(title: 'Error loading activity');
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return const EmptyData();
            }

            return Column(
              children: items
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key < items.length - 1 ? 12 : 0,
                      ),
                      child: RecentActivityItem(
                        item: entry.value,
                        onTap: () => onItemTap?.call(entry.value),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
