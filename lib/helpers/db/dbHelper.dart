import 'package:sqflite/sqflite.dart' as sqlite;
import 'dart:io';

import '../../helpers/path/pathhelper.dart';
//import '../helpers/path_provider_helper.dart';

class DBHelper {
  static sqlite.Database? db;

  static Future<dynamic> openDatabase(
      {String? dbPath,
      required int version,
      required String dbName,
      Function(sqlite.Database)? onConfig,
      required Function(sqlite.Database, int)? onCreate,
      Function(sqlite.Database, int, int)? onUpgrade}) async {
    dbPath ??= await sqlite.getDatabasesPath(); //.appDirPath;
    try {
      await Directory(dbPath).create(recursive: true);
    } catch (_) {}
    if (dbName.isEmpty) dbName = 'mydb.db';
    dbPath = PathHelper.pathJoin(dbPath, dbName);
    //print('dbpath: $dbPath');
    db ??= await sqlite.openDatabase(dbPath,
        version: version,
        onConfigure: onConfig, //(db) async {},
        onCreate: onCreate, //(db, version) async {},
        onUpgrade: onUpgrade, //(db, oldVersion, newVersion) {},
        onDowngrade: sqlite.onDatabaseDowngradeDelete);
    return db;
  }

  static Future<void> closeDatabase() async {
    await db!.close();
    db = null;
  }
}
