import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/scan_screen/scan_camera_controls/scan_camera_control_button.dart';

class ScanCameraControls extends StatelessWidget {
  final bool isFlashOn;
  final VoidCallback onFlashTap;
  final VoidCallback onSwitchCameraTap;
  final VoidCallback onGalleryTap;

  const ScanCameraControls({
    super.key,
    required this.isFlashOn,
    required this.onFlashTap,
    required this.onSwitchCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ScanCameraControlButton(
            iconPath: 'assets/icons/flash_icon.svg',
            label: 'Flash',
            isActive: isFlashOn,
            onTap: onFlashTap,
          ),
          ScanCameraControlButton(
            iconPath: 'assets/icons/switch_camera_icon.svg',
            label: 'Switch',
            isActive: false,
            onTap: onSwitchCameraTap,
          ),
          ScanCameraControlButton(
            iconPath: 'assets/icons/gallery_icon.svg',
            label: 'Gallery',
            isActive: false,
            onTap: onGalleryTap,
          ),
        ],
      ),
    );
  }
}
