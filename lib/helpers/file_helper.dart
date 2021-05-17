import 'dart:io';

import 'package:path/path.dart';
import './path/pathhelper.dart';

class FileManager {
  final String fileName;
  final String filePath;
  final File currentFile;

  FileManager({required this.fileName, required this.filePath})
      : currentFile = File(PathHelper.pathJoin(filePath, fileName));

  FileManager.withFile({required this.currentFile})
      : fileName = basename(currentFile.path),
        filePath = currentFile.path.split(basename(currentFile.path))[0];

  Future<File> stringWrite(Object data) {
    return currentFile.writeAsString(data.toString());
  }

  Future<File> byteWrite(List<int> data) {
    return currentFile.writeAsBytes(data);
  }

  Future<bool> isExists() {
    return currentFile.exists();
  }

  Future<File> makeFile() {
    return currentFile.create();
  }

  Future<String> readString() {
    return currentFile.readAsString();
  }

  Future<FileSystemEntity> deleteFile() {
    return currentFile.delete();
  }
}
