import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class BottomModal {
  static void show(BuildContext context, {required Widget content}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.black.withValues(alpha: 0.5),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text(
                  'Cancel',
                  style: AppFonts.interMedium.copyWith(
                    fontSize: 15,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
