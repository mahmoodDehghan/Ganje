import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/path/path_provider_helper.dart';
import '../models/cryption/rsakey.dart';
import '../helpers/file_helper.dart';
import '../helpers/cryption/cryptionhelper.dart';

final keyProvider = FutureProvider.autoDispose<RsaKey>((ref) async {
  const String CIFileName = 'ci.k';
  final path = await PathProvider.appDirPath;
  final ciFile = FileManager(fileName: CIFileName, filePath: path!);
  final isKeyExist = await ciFile.isExists();
  if (isKeyExist) {
    String keyContent = await ciFile.readString();
    var keyMap = json.decode(keyContent);
    return RsaKey.fromMap(keyMap);
  } else {
    var key = RsaKey(CryptionHelper.generateRsaKey());
    await ciFile.makeFile();
    await ciFile.stringWrite(json.encode(key.toStringMap));
    return key;
  }
});
