import 'package:sqflite/sqflite.dart' as sqlite;

class DBQueryHelper {
  static Future<int> insert(
      sqlite.Database db, String tableName, Map<String, Object?> data) {
    return db.insert(tableName, data);
  }

  static Future<int> update(sqlite.Database dbInstance, String tableName,
      Map<String, Object?> data, String idColumn, dynamic id) async {
    return dbInstance
        .update(tableName, data, where: '$idColumn = ?', whereArgs: [id]);
  }

  static Future<int> delete(sqlite.Database dbInstance, String tableName,
      String idColumn, dynamic id) async {
    return dbInstance
        .delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  static Future<int> deleteAll(sqlite.Database dbInstance, String tableName,
      String where, List<Object?> whereArgs) async {
    return dbInstance.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  static Future<Map<String, Object?>?> getItem(
      sqlite.Database dbInstance,
      String tableName,
      List<String> columns,
      String idColumn,
      dynamic id) async {
    var results = await dbInstance.query(tableName,
        columns: columns, where: '$idColumn = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return results.first;
  }

  static Future<List<Map<String, Object?>>> getAll(
      sqlite.Database db, String tableName,
      {List<String>? columns}) async {
    if (columns == null) return await db.query(tableName);
    return await db.query(tableName, columns: columns);
  }

  static Future<List<Map<String, Object?>>> getQueryResult(
      sqlite.Database db, String tableName,
      {List<String>? columns,
      required String where,
      required List<Object?> whereArgs}) async {
    return db.query(tableName,
        columns: columns, where: where, whereArgs: whereArgs);
  }
}
