import 'package:sqflite/sqflite.dart' as sqlite;

import '../../helpers/db/db_query_helper.dart';
import '../../helpers/db/db_schema_heper.dart';

import '../db/sqlmodel.dart';

class GanjineCase extends SqlModel {
  //sql model helper for create and modify cases
  static const String tableName = 'ganjine_case';
  static const String idColumnName = '_id';
  static const String nameColumnName = 'name';
  static const List<String> allColumns = [idColumnName, nameColumnName];

  int id = -1;
  String name;

  GanjineCase(this.id, this.name);
  GanjineCase.withName(this.name);
  GanjineCase.fromMap(Map<String, Object?> data)
      : this.id = data[idColumnName] as int,
        this.name = data[nameColumnName] as String;

  static String createFieldString() {
    return ''' 
    $idColumnName integer primary key autoincrement,
    $nameColumnName text unique not null
    ''';
  }

  static List<GanjineCase> getAll(List<Map<String, Object?>> records) {
    List<GanjineCase> list = [];
    for (final record in records) list.add(GanjineCase.fromMap(record));
    return list;
  }

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      nameColumnName: name,
    };
    if (id != -1) {
      map[idColumnName] = id;
    }
    return map;
  }

  @override
  List<String> listofColumnNames() {
    return [idColumnName, nameColumnName];
  }

  static void createTable(sqlite.Batch dbBatch) {
    DBSchemaHelper.createTable(dbBatch, tableName, createFieldString());
  }

  @override
  Future<int> deleteFromDB(sqlite.Database dbInstance) async {
    return DBQueryHelper.delete(dbInstance, tableName, idColumnName, this.id);
  }

  @override
  Future<int> insertToDB(sqlite.Database dbInstance) {
    return DBQueryHelper.insert(dbInstance, tableName, this.toMap());
  }

  @override
  Future<int> updateInDB(sqlite.Database dbInstance) {
    return DBQueryHelper.update(
        dbInstance, tableName, this.toMap(), idColumnName, this.id);
  }
}
