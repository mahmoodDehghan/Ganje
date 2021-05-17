import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathProvider {
  static Directory? _tempDir;
  static Directory? _appDocDir;

  static Future<String?> get tempDirPath async {
    _tempDir ??= await getTemporaryDirectory();
    return _tempDir?.path;
  }

  static Future<String?> get appDirPath async {
    _appDocDir ??= await getApplicationDocumentsDirectory();
    return _appDocDir?.path;
  }
}
