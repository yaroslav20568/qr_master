import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/history_screen/history_item.dart';
import 'package:qr_master/widgets/ui/index.dart';

class HistoryList extends StatelessWidget {
  final List<ScanHistoryItem> items;
  final Function(ScanHistoryItem) onItemTap;
  final Function(ScanHistoryItem)? onItemDelete;
  final VoidCallback? onItemRescan;
  final Function(ScanHistoryItem)? onItemCopy;
  final Function(ScanHistoryItem)? onItemShare;

  const HistoryList({
    super.key,
    required this.items,
    required this.onItemTap,
    this.onItemDelete,
    this.onItemRescan,
    this.onItemCopy,
    this.onItemShare,
  });

  Map<String, List<ScanHistoryItem>> _groupByDate(List<ScanHistoryItem> items) {
    final Map<String, List<ScanHistoryItem>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final item in items) {
      final itemDate = DateTime(
        item.timestamp.year,
        item.timestamp.month,
        item.timestamp.day,
      );

      String dateKey;
      if (itemDate == today) {
        dateKey = 'Today';
      } else if (itemDate == yesterday) {
        dateKey = 'Yesterday';
      } else {
        final monthNames = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        dateKey =
            '${monthNames[item.timestamp.month - 1]} ${item.timestamp.day}, ${item.timestamp.year}';
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(item);
    }

    return grouped;
  }

  List<String> _getSortedDateKeys(Map<String, List<ScanHistoryItem>> grouped) {
    final keys = grouped.keys.toList();
    keys.sort((a, b) {
      if (a == 'Today') return -1;
      if (b == 'Today') return 1;
      if (a == 'Yesterday') return -1;
      if (b == 'Yesterday') return 1;
      return b.compareTo(a);
    });
    return keys;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyData(title: 'No history items found');
    }

    final grouped = _groupByDate(items);
    final dateKeys = _getSortedDateKeys(grouped);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dateKeys.length,
      itemBuilder: (context, dateIndex) {
        final dateKey = dateKeys[dateIndex];
        final dateItems = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                dateKey,
                style: AppFonts.interSemiBold.copyWith(
                  fontSize: 17,
                  height: 1.53,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ...dateItems.asMap().entries.map((entry) {
              final isLast = entry.key == dateItems.length - 1;
              final isLastInAll = dateIndex == dateKeys.length - 1 && isLast;
              return Padding(
                padding: EdgeInsets.only(bottom: isLastInAll ? 0 : 12),
                child: HistoryItem(
                  item: entry.value,
                  onTap: () => onItemTap(entry.value),
                  onDelete: onItemDelete != null
                      ? () => onItemDelete!(entry.value)
                      : null,
                  onRescan: onItemRescan,
                  onCopy: onItemCopy != null
                      ? () => onItemCopy!(entry.value)
                      : null,
                  onShare: onItemShare != null
                      ? () => onItemShare!(entry.value)
                      : null,
                ),
              );
            }),
            if (dateIndex < dateKeys.length - 1) const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
