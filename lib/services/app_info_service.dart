import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_master/constants/index.dart';

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
    return _packageInfo?.version ?? AppInfo.defaultVersion;
  }

  static String get versionString {
    return 'Version $version';
  }
}
