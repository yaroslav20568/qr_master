import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class ConfirmModal {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String text,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppFonts.interSemiBold.copyWith(
            fontSize: 17,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          text,
          style: AppFonts.interRegular.copyWith(
            fontSize: 15,
            letterSpacing: -0.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: AppFonts.interMedium.copyWith(
                fontSize: 15,
                letterSpacing: -0.5,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor ?? AppColors.primary,
            ),
            child: Text(
              confirmText,
              style: AppFonts.interMedium.copyWith(
                fontSize: 15,
                letterSpacing: -0.5,
                color: confirmColor ?? AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
