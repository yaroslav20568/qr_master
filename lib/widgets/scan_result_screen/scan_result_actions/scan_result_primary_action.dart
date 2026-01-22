import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanResultPrimaryAction extends StatelessWidget {
  final ScanHistoryItem scanItem;
  final VoidCallback? onOpen;
  final VoidCallback? onAddContact;
  final VoidCallback? onConnectToWifi;

  const ScanResultPrimaryAction({
    super.key,
    required this.scanItem,
    this.onOpen,
    this.onAddContact,
    this.onConnectToWifi,
  });

  String _getOpenButtonText() {
    switch (scanItem.type) {
      case QrCodeType.url:
        return 'Open Link';
      case QrCodeType.phone:
        return 'Call';
      case QrCodeType.email:
        return 'Send Email';
      case QrCodeType.contact:
      case QrCodeType.wifi:
      case QrCodeType.text:
        return 'Open';
    }
  }

  Widget _getOpenButtonIcon() {
    switch (scanItem.type) {
      case QrCodeType.url:
        return const Icon(
          Icons.open_in_new,
          color: AppColors.primaryBg,
          size: 24,
        );
      case QrCodeType.phone:
        return const Icon(Icons.phone, color: AppColors.primaryBg, size: 24);
      case QrCodeType.email:
        return const Icon(Icons.email, color: AppColors.primaryBg, size: 24);
      case QrCodeType.contact:
      case QrCodeType.wifi:
      case QrCodeType.text:
        return const Icon(
          Icons.open_in_new,
          color: AppColors.primaryBg,
          size: 24,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (scanItem.type == QrCodeType.text) {
      return const SizedBox.shrink();
    }

    if (scanItem.type == QrCodeType.contact) {
      return Builder(
        builder: (context) => Button(
          text: 'Add to Contacts',
          icon: const Icon(
            Icons.person_add,
            color: AppColors.primaryBg,
            size: 24,
          ),
          onPressed: onAddContact,
          height: 56,
        ),
      );
    }

    if (scanItem.type == QrCodeType.wifi) {
      return Builder(
        builder: (context) => Button(
          text: 'Connect to WiFi',
          icon: const Icon(Icons.wifi, color: AppColors.primaryBg, size: 24),
          onPressed: onConnectToWifi,
          height: 56,
        ),
      );
    }

    return Builder(
      builder: (context) => Button(
        text: _getOpenButtonText(),
        icon: _getOpenButtonIcon(),
        onPressed: onOpen,
        height: 56,
      ),
    );
  }
}
