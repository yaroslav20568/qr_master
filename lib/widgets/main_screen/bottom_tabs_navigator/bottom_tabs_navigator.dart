import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/main_screen/bottom_tabs_navigator/index.dart';

class BottomTabsNavigator extends StatelessWidget {
  final BottomNavItem currentItem;
  final Function(BottomNavItem) onItemSelected;
  final VoidCallback? onFabTap;

  const BottomTabsNavigator({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
    this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: BottomNavBarClipper(screenWidth: context.screenWidth),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Container(
              height: 92,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NavItem(
                            iconName: 'home',
                            label: 'Home',
                            item: BottomNavItem.home,
                            isSelected: currentItem == BottomNavItem.home,
                            onItemSelected: onItemSelected,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconName: 'scan',
                            label: 'Scan QR',
                            item: BottomNavItem.scan,
                            isSelected: currentItem == BottomNavItem.scan,
                            onItemSelected: onItemSelected,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NavItem(
                            iconName: 'my_qr_codes',
                            label: 'My QR Codes',
                            item: BottomNavItem.settings,
                            isSelected: currentItem == BottomNavItem.settings,
                            onItemSelected: onItemSelected,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconName: 'history',
                            label: 'History',
                            item: BottomNavItem.history,
                            isSelected: currentItem == BottomNavItem.history,
                            onItemSelected: onItemSelected,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: -4,
          top: -20,
          child: Center(
            child: BottomTabsFloatingActionButton(
              onTap: onFabTap,
              onItemSelected: onItemSelected,
            ),
          ),
        ),
      ],
    );
  }
}
