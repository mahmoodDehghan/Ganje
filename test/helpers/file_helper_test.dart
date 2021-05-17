import 'package:test/test.dart';
import '../../lib/helpers/path/path_provider_helper.dart';
import '../../lib/helpers/file_helper.dart';

Future<FileManager> provideTestFile(String fileName) async {
  var testPath = await PathProvider.appDirPath;
  return FileManager(fileName: fileName, filePath: testPath!);
}

void main() {
  group('basic file manager test', () {
    const testString = 'testString';
    var testFileName = 'testFile.name';
    var fileManager;
    setUp(() async {
      fileManager = await provideTestFile(testFileName);
      await fileManager.makeFile();
    });
    tearDown(() async {
      if (await fileManager.isExists()) await fileManager.deleteFile();
    });
    test('test not existing a file', () async {
      var fileName = 'imnotexist.n';
      var fileManager = await provideTestFile(fileName);
      expect(await fileManager.isExists(), isFalse);
    });
    test('test create file', () async {
      expect(await fileManager.isExists(), isTrue);
    });
    test('test delete a file', () async {
      await fileManager.deleteFile();
      expect(await fileManager.isExists(), isFalse);
    });
    test('write string to a file test', () async {
      await fileManager.stringWrite(testString);
      var contents = await fileManager.readString();
      expect(contents.contains(testString), isTrue);
    });
    test('read from a file test', () async {
      var contents = await fileManager.readString();
      expect(contents, isNotNull);
    });
  });
}
