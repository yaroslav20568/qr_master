import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';

enum BottomNavItem { home, scan, create, history, settings }

class NavItem extends StatelessWidget {
  final String iconName;
  final String label;
  final BottomNavItem item;
  final bool isSelected;
  final Function(BottomNavItem) onItemSelected;

  const NavItem({
    super.key,
    required this.iconName,
    required this.label,
    required this.item,
    required this.isSelected,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final iconFile = isSelected ? 'filled.svg' : 'outline.svg';
    final iconPath = 'assets/icons/bottom_tabs/$iconName/$iconFile';

    return GestureDetector(
      onTap: () => onItemSelected(item),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppFonts.interMedium.copyWith(
              fontSize: 10,
              height: 15 / 10,
              letterSpacing: -0.5,
              color: isSelected ? AppColors.primary : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
