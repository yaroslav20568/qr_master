import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/background_circle_icon.dart';

class ActionsDropdown extends StatelessWidget {
  final List<ActionsDropdownItem> items;
  final double iconBackgroundSize;
  final Color? iconBackgroundColor;
  final double iconButtonSize;

  const ActionsDropdown({
    super.key,
    required this.items,
    this.iconBackgroundSize = 24,
    this.iconBackgroundColor = AppColors.secondaryBg,
    this.iconButtonSize = 7,
  });

  void _showActionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  item.onTap();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackgroundCircleIcon(
                      size: 56,
                      backgroundColor: item.effectiveBackgroundColor,
                      child: Icon(
                        item.icon,
                        color: AppColors.primaryBg,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: AppFonts.interMedium.copyWith(
                        fontSize: 13,
                        letterSpacing: -0.5,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showActionsModal(context),
      child: BackgroundCircleIcon(
        size: iconBackgroundSize,
        backgroundColor: iconBackgroundColor,
        child: SvgPicture.asset(
          '${AppAssets.iconsPath}more_icon.svg',
          width: iconButtonSize,
        ),
      ),
    );
  }
}
