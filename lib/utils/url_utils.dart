import 'package:qr_master/services/logger_service.dart';

class UrlUtils {
  static Uri normalizeUrl(String url) {
    String normalizedUrl = url.trim();

    if (normalizedUrl.isEmpty) {
      throw ArgumentError('URL cannot be empty');
    }

    if (!normalizedUrl.startsWith('http://') &&
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'https://$normalizedUrl';
      LoggerService.info('Added https:// prefix to URL: $normalizedUrl');
    }

    final uri = Uri.parse(normalizedUrl);
    LoggerService.info('Normalized URL: $url -> ${uri.toString()}');
    return uri;
  }
}
