import 'package:qr_master/models/index.dart';

class HistoryTitleFormatter {
  static String formatTitle(ScanHistoryAction action, QrCodeType type) {
    final actionText = getActionText(action);
    final typeText = getTypeText(type);
    return '$actionText $typeText';
  }

  static String getActionText(ScanHistoryAction action) {
    switch (action) {
      case ScanHistoryAction.scanned:
        return 'Scanned';
      case ScanHistoryAction.created:
        return 'Created';
      case ScanHistoryAction.shared:
        return 'Shared';
    }
  }

  static String getTypeText(QrCodeType type) {
    switch (type) {
      case QrCodeType.url:
        return 'website link';
      case QrCodeType.wifi:
        return 'Wi-Fi QR';
      case QrCodeType.phone:
        return 'phone QR';
      case QrCodeType.email:
        return 'email QR';
      case QrCodeType.contact:
        return 'contact QR';
      case QrCodeType.text:
        return 'text message';
    }
  }
}
