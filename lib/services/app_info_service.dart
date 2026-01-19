import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  static PackageInfo? _packageInfo;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized = true;
    }
  }

  static String get version {
    return _packageInfo?.version ?? '1.0.0';
  }

  static String get versionString {
    return 'Version $version';
  }
}
