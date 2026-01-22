import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class QrCodeLayout extends StatelessWidget {
  final Widget child;

  const QrCodeLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            offset: Offset.zero,
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
