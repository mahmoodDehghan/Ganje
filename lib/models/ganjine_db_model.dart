import 'package:sqflite/sqflite.dart' as sqlite;

import '../helpers/db/dbHelper.dart';

import 'dbschema/gcase.dart';
import 'dbschema/gsecret.dart';
import 'dbschema/gsecret_item.dart';

class GanjineDB {
  static const String dbName = 'ganje.db';

  static Future<void> onCreate(sqlite.Database db, int version) async {
    var batch = db.batch();

    GanjineCase.createTable(batch);
    GanjineSecret.createTable(batch);
    GanjineSecretItem.createTable(batch);

    await batch.commit();
  }

  static Future<sqlite.Database> open() async {
    return await DBHelper.openDatabase(
        dbName: GanjineDB.dbName,
        onCreate: onCreate,
        version: 1,
        onConfig: null,
        onUpgrade: null);
  }

  static Future<void> close() async {
    await DBHelper.closeDatabase();
  }
}
