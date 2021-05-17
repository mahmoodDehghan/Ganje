import 'package:test/test.dart';
import '../../../lib/helpers/path/pathhelper.dart';
import '../../../lib/helpers/path/path_provider_helper.dart';

void main() {
  group('pathproviders test', () {
    var fileName = 'fileName.format';
    test('test path join', () {
      var appDir = 'foo';
      var address = PathHelper.pathJoin(appDir, fileName);
      expect(address, 'foo\\fileName.format');
    });

    test('get app dir path', () {
      expect(PathProvider.appDirPath, isNotNull);
    });
    test('get app cache path', () async {
      var cacheDir = await PathProvider.tempDirPath;
      expect(cacheDir, isNotNull);
    });
  });
}
