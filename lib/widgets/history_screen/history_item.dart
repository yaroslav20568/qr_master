import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class HistoryItem extends StatelessWidget {
  final ScanHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const HistoryItem({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
    this.onCopy,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
              size: 48,
              backgroundColor: HistoryActionStyles.getBackgroundColor(
                item.action,
              ),
              child: HistoryActionStyles.getIcon(item.action),
            ),
            const SizedBox(width: 8),
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
                  Text(
                    () {
                      final displayContent = QrContentParser.getDisplayContent(
                        item.content,
                        item.type,
                      );
                      return displayContent.length > 50
                          ? '${displayContent.substring(0, 50)}...'
                          : displayContent;
                    }(),
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 15,
                      height: 1.53,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${HistoryTitleFormatter.getActionText(item.action)} • ',
                        style: AppFonts.interRegular.copyWith(
                          fontSize: 15,
                          height: 1.53,
                          letterSpacing: -0.5,
                          color: AppColors.textSecondary,
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
                ],
              ),
            ),
            if (onCopy != null || onShare != null || onDelete != null)
              Builder(
                builder: (context) {
                  final actions = <ActionsDropdownItem>[];

                  if (onCopy != null) {
                    actions.add(
                      ActionsDropdownItem(
                        icon: Icons.copy,
                        title: 'Copy',
                        onTap: onCopy!,
                      ),
                    );
                  }

                  if (onShare != null &&
                      item.action != ScanHistoryAction.shared) {
                    actions.add(
                      ActionsDropdownItem(
                        icon: Icons.share,
                        title: 'Share',
                        onTap: onShare!,
                      ),
                    );
                  }

                  if (onDelete != null) {
                    actions.add(
                      ActionsDropdownItem(
                        icon: Icons.delete_outline,
                        title: 'Delete',
                        onTap: onDelete!,
                      ),
                    );
                  }

                  return Row(
                    children: [
                      SizedBox(width: 8),
                      ActionsDropdown(
                        items: actions,
                        iconBackgroundSize: 20,
                        iconBackgroundColor: AppColors.transparent,
                        iconButtonSize: 12,
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
