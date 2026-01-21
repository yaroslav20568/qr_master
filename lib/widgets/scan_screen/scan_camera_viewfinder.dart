import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanCameraViewfinder extends StatelessWidget {
  final Widget? cameraWidget;

  const ScanCameraViewfinder({super.key, this.cameraWidget});

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            cameraWidget ?? const SizedBox.shrink(),
            if (cameraWidget == null)
              const Positioned(
                bottom: 84,
                left: 0,
                right: 0,
                child: ScanningLine(),
              ),
          ],
        ),
      ),
    );
  }
}
