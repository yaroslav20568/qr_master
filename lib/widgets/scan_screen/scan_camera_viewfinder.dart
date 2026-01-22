import 'package:flutter/material.dart';
import 'package:qr_master/widgets/layouts/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanCameraViewfinder extends StatelessWidget {
  final Widget? cameraWidget;

  const ScanCameraViewfinder({super.key, this.cameraWidget});

  @override
  Widget build(BuildContext context) {
    return QrCodeLayout(
      child: Center(
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
      ),
    );
  }
}
