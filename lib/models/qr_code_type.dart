enum QrCodeType {
  url,
  text,
  contact,
  wifi,
  email,
  phone,
  sms,
  calendar,
  social,
}

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
      case QrCodeType.email:
        return 'Email';
      case QrCodeType.phone:
        return 'Phone';
      case QrCodeType.sms:
        return 'SMS';
      case QrCodeType.calendar:
        return 'Calendar';
      case QrCodeType.social:
        return 'Social';
    }
  }
}
