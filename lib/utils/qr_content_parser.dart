import 'package:qr_master/models/index.dart';

class QrContentParser {
  static String getDisplayContent(String content, QrCodeType type) {
    switch (type) {
      case QrCodeType.url:
        return _parseUrl(content);
      case QrCodeType.phone:
        return _parsePhone(content);
      case QrCodeType.wifi:
        return _parseWifiNetworkName(content);
      case QrCodeType.text:
        return content;
    }
  }

  static String getSectionTitle(QrCodeType type) {
    switch (type) {
      case QrCodeType.url:
        return 'Website URL';
      case QrCodeType.phone:
        return 'Phone Number';
      case QrCodeType.wifi:
        return 'WiFi Network';
      case QrCodeType.text:
        return 'Text Content';
    }
  }

  static String _parseUrl(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      final uri = Uri.tryParse(content);
      if (uri != null) {
        return '${uri.host}${uri.path}';
      }
    }
    return content;
  }

  static String _parsePhone(String content) {
    if (content.startsWith('tel:')) {
      return content.substring(4);
    }
    return content;
  }

  static String _parseWifiNetworkName(String content) {
    if (content.startsWith('WIFI:')) {
      final parts = content.substring(5).split(';');
      for (final part in parts) {
        if (part.startsWith('S:')) {
          return part.substring(2);
        }
      }
    }
    return content;
  }

  static Map<String, String>? parseWifiDetails(String content) {
    if (!content.startsWith('WIFI:')) {
      return null;
    }

    final parts = content.substring(5).split(';');
    final Map<String, String> details = {};

    for (final part in parts) {
      if (part.startsWith('S:')) {
        details['ssid'] = part.substring(2);
      } else if (part.startsWith('T:')) {
        details['type'] = part.substring(2);
      } else if (part.startsWith('P:')) {
        details['password'] = part.substring(2);
      } else if (part.startsWith('H:')) {
        details['hidden'] = part.substring(2);
      }
    }

    return details.isEmpty ? null : details;
  }

  static String formatWifiContent(String content) {
    final details = parseWifiDetails(content);
    if (details == null) {
      return content;
    }

    final List<String> lines = [];

    if (details.containsKey('ssid') && details['ssid']!.isNotEmpty) {
      lines.add('Network name: ${details['ssid']}');
    }

    if (details.containsKey('type') && details['type']!.isNotEmpty) {
      lines.add('Network type: ${details['type']}');
    }

    if (details.containsKey('password') && details['password']!.isNotEmpty) {
      final passwordLength = details['password']!.length;
      final maskedPassword = '*' * passwordLength;
      lines.add('Password: $maskedPassword');
    }

    return lines.isEmpty ? content : lines.join('\n');
  }
}
