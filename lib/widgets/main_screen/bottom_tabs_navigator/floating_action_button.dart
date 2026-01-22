import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/main_screen/bottom_tabs_navigator/nav_item.dart';
import 'package:qr_master/widgets/ui/index.dart';

class BottomTabsFloatingActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(BottomNavItem) onItemSelected;

  const BottomTabsFloatingActionButton({
    super.key,
    this.onTap,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => onItemSelected(BottomNavItem.create),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.success,
              offset: const Offset(0, 0),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BackgroundCircleIcon(
          size: 52,
          backgroundColor: AppColors.success,
          child: SvgPicture.asset('assets/icons/add.svg'),
        ),
      ),
    );
  }
}
