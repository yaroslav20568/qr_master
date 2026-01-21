import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';
import 'package:qr_master/widgets/scan_screen/index.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isFlashOn = false;

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  void _switchCamera() {}

  void _openGallery() {}

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      backgroundColor: AppColors.secondaryBg,
      child: Center(
        child: SingleChildScrollView(
          child: PaddingLayout(
            child: Column(
              children: [
                const ScanInfoBanner(),
                const SizedBox(height: 40),
                const ScanCameraViewfinder(),
                const SizedBox(height: 40),
                ScanCameraControls(
                  isFlashOn: _isFlashOn,
                  onFlashTap: _toggleFlash,
                  onSwitchCameraTap: _switchCamera,
                  onGalleryTap: _openGallery,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
