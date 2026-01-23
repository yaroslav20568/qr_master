import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class HistoryItem extends StatelessWidget {
  final ScanHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRescan;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const HistoryItem({
    super.key,
    required this.item,
    required this.onTap,
    this.onDelete,
    this.onRescan,
    this.onCopy,
    this.onShare,
  });

  String _getActionText() {
    switch (item.action) {
      case ScanHistoryAction.scanned:
        return 'Scanned';
      case ScanHistoryAction.created:
        return 'Created';
      case ScanHistoryAction.shared:
        return 'Shared';
    }
  }

  String _getTypeText() {
    switch (item.type) {
      case QrCodeType.url:
        return 'website link';
      case QrCodeType.wifi:
        return 'Wi-Fi QR';
      case QrCodeType.phone:
        return 'phone QR';
      case QrCodeType.email:
        return 'email QR';
      case QrCodeType.contact:
        return 'contact QR';
      case QrCodeType.text:
        return 'text message';
    }
  }

  String _getDisplayTitle() {
    final actionText = _getActionText();
    final typeText = _getTypeText();
    return '$actionText $typeText';
  }

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
              color: Colors.black.withValues(alpha: 0.06),
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
                    _getDisplayTitle(),
                    style: AppFonts.interMedium.copyWith(
                      fontSize: 17,
                      height: 26 / 17,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                      fontSize: 13,
                      height: 20 / 13,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  TimeAgoText(
                    timestamp: item.timestamp,
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 15,
                      height: 23 / 15,
                      letterSpacing: -0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onCopy != null ||
                onShare != null ||
                onRescan != null ||
                onDelete != null)
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onSelected: (value) {
                  switch (value) {
                    case 'copy':
                      onCopy?.call();
                      break;
                    case 'share':
                      onShare?.call();
                      break;
                    case 'rescan':
                      onRescan?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onCopy != null)
                    const PopupMenuItem<String>(
                      value: 'copy',
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 12),
                          Text('Copy'),
                        ],
                      ),
                    ),
                  if (onShare != null)
                    const PopupMenuItem<String>(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 12),
                          Text('Share'),
                        ],
                      ),
                    ),
                  if (onRescan != null)
                    PopupMenuItem<String>(
                      value: 'rescan',
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/scan_qr_icon.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text('Rescan'),
                        ],
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/chevron_right_icon.svg',
              width: 7,
              height: 13,
            ),
          ],
        ),
      ),
    );
  }
}
