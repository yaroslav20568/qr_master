import 'package:qr_master/models/index.dart';

class QrContentFormatter {
  static String formatContentForQr(String content, QrCodeType type) {
    switch (type) {
      case QrCodeType.url:
        return _formatUrl(content);
      case QrCodeType.phone:
        return _formatPhone(content);
      case QrCodeType.email:
        return _formatEmail(content);
      case QrCodeType.contact:
        return content;
      case QrCodeType.wifi:
        return content;
      case QrCodeType.text:
        return content;
    }
  }

  static String _formatUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }

  static String _formatPhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('tel:')) {
      return trimmed;
    }
    return 'tel:$trimmed';
  }

  static String _formatEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('mailto:')) {
      return trimmed;
    }
    return 'mailto:$trimmed';
  }

  static String formatWifiContent({
    required String ssid,
    required String password,
    String type = 'WPA',
    bool hidden = false,
  }) {
    final buffer = StringBuffer('WIFI:');
    buffer.write('T:$type;');
    buffer.write('S:$ssid;');
    buffer.write('P:$password;');
    if (hidden) {
      buffer.write('H:true;');
    }
    return buffer.toString();
  }

  static String formatContactContent({
    required String name,
    String? phone,
    String? email,
    String? organization,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$name');
    if (phone != null && phone.isNotEmpty) {
      buffer.writeln('TEL:$phone');
    }
    if (email != null && email.isNotEmpty) {
      buffer.writeln('EMAIL:$email');
    }
    if (organization != null && organization.isNotEmpty) {
      buffer.writeln('ORG:$organization');
    }
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }
}
