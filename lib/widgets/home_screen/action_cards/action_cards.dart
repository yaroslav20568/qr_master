import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/home_screen/action_cards/action_card.dart';

class ActionCards extends StatelessWidget {
  final VoidCallback onScanTap;
  final VoidCallback onCreateTap;
  final VoidCallback onMyQrCodesTap;
  final VoidCallback onHistoryTap;

  const ActionCards({
    super.key,
    required this.onScanTap,
    required this.onCreateTap,
    required this.onMyQrCodesTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final actionCards = [
      {
        'iconPath': '${AppAssets.iconsPath}actions/scan_icon.svg',
        'title': 'Scan QR',
        'subtitle': 'Quick scan',
        'iconBackgroundColor': AppColors.primary,
        'onTap': onScanTap,
      },
      {
        'iconPath': '${AppAssets.iconsPath}actions/add_icon.svg',
        'title': 'Create QR',
        'subtitle': 'Generate new',
        'iconBackgroundColor': AppColors.success,
        'onTap': onCreateTap,
      },
      {
        'iconPath': '${AppAssets.iconsPath}actions/folder_icon.svg',
        'title': 'My QR Codes',
        'subtitle': 'Saved codes',
        'iconBackgroundColor': AppColors.warning,
        'onTap': onMyQrCodesTap,
      },
      {
        'iconPath': '${AppAssets.iconsPath}actions/history_icon.svg',
        'title': 'History',
        'subtitle': 'Recent scans',
        'iconBackgroundColor': AppColors.textDisabled,
        'onTap': onHistoryTap,
      },
    ];

    return Column(
      children: [
        for (int i = 0; i < actionCards.length; i += 2) ...[
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  iconPath: actionCards[i]['iconPath'] as String,
                  title: actionCards[i]['title'] as String,
                  subtitle: actionCards[i]['subtitle'] as String,
                  iconBackgroundColor:
                      actionCards[i]['iconBackgroundColor'] as Color,
                  onTap: actionCards[i]['onTap'] as VoidCallback,
                ),
              ),
              if (i + 1 < actionCards.length) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: ActionCard(
                    iconPath: actionCards[i + 1]['iconPath'] as String,
                    title: actionCards[i + 1]['title'] as String,
                    subtitle: actionCards[i + 1]['subtitle'] as String,
                    iconBackgroundColor:
                        actionCards[i + 1]['iconBackgroundColor'] as Color,
                    onTap: actionCards[i + 1]['onTap'] as VoidCallback,
                  ),
                ),
              ],
            ],
          ),
          if (i + 2 < actionCards.length) const SizedBox(height: 16),
        ],
      ],
    );
  }
}
