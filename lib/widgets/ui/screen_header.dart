import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final IconData? rightIcon;
  final VoidCallback? onRightIconTap;
  final Color? iconColor;
  final Widget? content;

  const ScreenHeader({
    super.key,
    required this.title,
    this.rightIcon,
    this.onRightIconTap,
    this.iconColor = AppColors.grayDark,
    this.content,
  });

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await AuthService().signOut();
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.auth, (route) => false);
      }
    } catch (e) {
      LoggerService.error('Error during logout', error: e);
      if (context.mounted) {
        SnackbarService.showError(context, message: 'Failed to logout');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppFonts.interBold.copyWith(
                    fontSize: 22,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    if (rightIcon != null && onRightIconTap != null)
                      BackgroundCircleIcon(
                        size: 40,
                        backgroundColor: AppColors.secondaryBg,
                        child: IconButton(
                          icon: Icon(rightIcon),
                          onPressed: onRightIconTap,
                          color: iconColor,
                          iconSize: 15,
                        ),
                      ),
                    if (rightIcon != null && onRightIconTap != null)
                      const SizedBox(width: 10),
                    BackgroundCircleIcon(
                      size: 40,
                      backgroundColor: AppColors.secondaryBg,
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _handleLogout(context),
                        color: iconColor,
                        iconSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
                right: 16,
                bottom: 16,
                left: 16,
              ),
              child: content,
            ),
        ],
      ),
    );
  }
}
