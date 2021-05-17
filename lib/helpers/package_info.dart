import 'package:package_info/package_info.dart';

class PackageInfoHelper {
  static Future<PackageInfo> get info async {
    return await PackageInfo.fromPlatform();
  }

  static Future<String> get appName async {
    var package = await info;
    return package.appName;
  }

  static Future<String> get appPackage async {
    var package = await info;
    return package.packageName;
  }

  static Future<String> get appVersion async {
    var package = await info;
    return package.version;
  }

  static Future<String> get appBuildNumber async {
    var package = await info;
    return package.buildNumber;
  }
}
