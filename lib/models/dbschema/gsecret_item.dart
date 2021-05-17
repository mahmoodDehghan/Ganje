import 'package:sqflite/sqflite.dart' as sqlite;

import '../db/sqlmodel.dart';
import './gsecret.dart';

import '../../helpers/db/db_schema_heper.dart';
import '../../helpers/db/db_query_helper.dart';

class GanjineSecretItem extends SqlModel {
  static const String tableName = 'ganjine_secret_item';
  static const String idColumnName = '_id';
  static const String titleColumnName = 'item_title';
  static const String valueColumnName = 'item_value';
  static const String secretIDColumnName = 'secret_id';
  static const List<String> allColumns = [
    idColumnName,
    titleColumnName,
    valueColumnName,
    secretIDColumnName,
  ];

  int id = -1;
  String itemTitle;
  String itemValue;
  int secretID;

  GanjineSecretItem(this.id, this.itemTitle, this.itemValue, this.secretID);
  GanjineSecretItem.withSecretID(this.secretID,
      [this.itemTitle = '', this.itemValue = '']);
  GanjineSecretItem.fromMap(Map<String, Object?> data)
      : this.id = data[idColumnName] as int,
        this.itemTitle = data[titleColumnName] as String,
        this.itemValue = data[valueColumnName] as String,
        this.secretID = data[secretIDColumnName] as int;

  static String createFieldString() {
    return '''
      $idColumnName integer primary key autoincrement,
      $titleColumnName text not null,
      $valueColumnName text not null,
      $secretIDColumnName integer,
      foreign key ($secretIDColumnName) references 
      ${GanjineSecret.tableName}(${GanjineSecret.idColumnName})
    ''';
  }

  static void createTable(sqlite.Batch dbBatch) async {
    DBSchemaHelper.createTable(dbBatch, tableName, createFieldString());
  }

  @override
  Future<int> deleteFromDB(sqlite.Database dbInstance) async {
    return DBQueryHelper.delete(dbInstance, tableName, idColumnName, this.id);
  }

  @override
  Future<int> insertToDB(sqlite.Database db) async {
    return DBQueryHelper.insert(db, tableName, this.toMap());
  }

  @override
  List<String> listofColumnNames() {
    return [idColumnName, titleColumnName, valueColumnName, secretIDColumnName];
  }

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      titleColumnName: this.itemTitle,
      valueColumnName: this.itemValue,
      secretIDColumnName: this.secretID
    };
    if (this.id != -1) map[idColumnName] = this.id;

    return map;
  }

  @override
  void updateInDB(sqlite.Database dbInstance) {
    DBQueryHelper.update(
        dbInstance, tableName, this.toMap(), idColumnName, this.id);
  }
}
