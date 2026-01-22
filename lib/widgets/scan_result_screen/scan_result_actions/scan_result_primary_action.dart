import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanResultPrimaryAction extends StatelessWidget {
  final ScanHistoryItem scanItem;
  final VoidCallback? onOpenLink;
  final VoidCallback? onCallPhone;
  final VoidCallback? onConnectToWifi;

  const ScanResultPrimaryAction({
    super.key,
    required this.scanItem,
    this.onOpenLink,
    this.onCallPhone,
    this.onConnectToWifi,
  });

  @override
  Widget build(BuildContext context) {
    switch (scanItem.type) {
      case QrCodeType.url:
        return Builder(
          builder: (context) => Button(
            text: 'Open Link',
            icon: const Icon(
              Icons.open_in_new,
              color: AppColors.primaryBg,
              size: 24,
            ),
            onPressed: onOpenLink,
            height: 56,
          ),
        );
      case QrCodeType.phone:
        return Builder(
          builder: (context) => Button(
            text: 'Call',
            icon: const Icon(Icons.phone, color: AppColors.primaryBg, size: 24),
            onPressed: onCallPhone,
            height: 56,
          ),
        );
      case QrCodeType.wifi:
        return Builder(
          builder: (context) => Button(
            text: 'Connect to WiFi',
            icon: const Icon(Icons.wifi, color: AppColors.primaryBg, size: 24),
            onPressed: onConnectToWifi,
            height: 56,
          ),
        );
      case QrCodeType.text:
        return const SizedBox.shrink();
    }
  }
}
