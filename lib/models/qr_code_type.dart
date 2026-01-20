enum QrCodeType { url, text, contact, wifi }

extension QrCodeTypeExtension on QrCodeType {
  String get displayName {
    switch (this) {
      case QrCodeType.url:
        return 'URL';
      case QrCodeType.text:
        return 'Text';
      case QrCodeType.contact:
        return 'Contact';
      case QrCodeType.wifi:
        return 'WiFi';
    }
  }
}
