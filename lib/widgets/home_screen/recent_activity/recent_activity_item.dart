import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class RecentActivityItem extends StatelessWidget {
  final ScanHistoryItem item;
  final VoidCallback onTap;

  const RecentActivityItem({
    super.key,
    required this.item,
    required this.onTap,
  });

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
              color: AppColors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            BackgroundCircleIcon(
              size: 40,
              backgroundColor: HistoryActionStyles.getBackgroundColor(
                item.action,
              ),
              child: HistoryActionStyles.getIcon(item.action),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    HistoryTitleFormatter.formatTitle(item.action, item.type),
                    style: AppFonts.interMedium.copyWith(
                      fontSize: 17,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TimeAgoText(
                    timestamp: item.timestamp,
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 15,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              '${AppAssets.iconsPath}chevron_right_icon.svg',
              width: 7,
              height: 13,
            ),
          ],
        ),
      ),
    );
  }
}
