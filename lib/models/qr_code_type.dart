enum QrCodeType { url, text, phone, email, contact, wifi }

extension QrCodeTypeExtension on QrCodeType {
  String get displayName {
    switch (this) {
      case QrCodeType.url:
        return 'URL';
      case QrCodeType.text:
        return 'Text';
      case QrCodeType.phone:
        return 'Phone';
      case QrCodeType.email:
        return 'Email';
      case QrCodeType.contact:
        return 'Contact';
      case QrCodeType.wifi:
        return 'Wi-Fi';
    }
  }
}
