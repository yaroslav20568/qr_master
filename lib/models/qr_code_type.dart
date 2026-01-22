enum QrCodeType { url, text, phone, wifi }

extension QrCodeTypeExtension on QrCodeType {
  String get displayName {
    switch (this) {
      case QrCodeType.url:
        return 'URL';
      case QrCodeType.text:
        return 'Text';
      case QrCodeType.phone:
        return 'Phone';
      case QrCodeType.wifi:
        return 'WiFi';
    }
  }
}
