import 'package:sqflite/sqflite.dart' as sqlite;

import '../../helpers/db/db_query_helper.dart';
import '../../helpers/db/db_schema_heper.dart';
import '../../helpers/datehelper.dart';

import '../db/sqlmodel.dart';
import './gcase.dart';

class GanjineSecret extends SqlModel {
  //sql model helper for create and modify secrets
  static const tableName = 'ganjine_secret';
  static const idColumnName = '_id';
  static const titleColumnName = 'title';
  static const createdDateColumnName = 'created_date';
  static const caseIDColumnName = 'case_id';
  static const List<String> allColumns = [
    idColumnName,
    titleColumnName,
    caseIDColumnName,
    createdDateColumnName
  ];

  int id = -1;
  String title;
  DateTime createdDate;
  int caseId;

  GanjineSecret(this.id, this.title, this.createdDate, this.caseId);
  GanjineSecret.withTitle(this.title, this.caseId)
      : createdDate = DateTime.now();
  GanjineSecret.fromMap(Map<String, Object?> data)
      : this.id = data[idColumnName] as int,
        this.title = data[titleColumnName] as String,
        this.caseId = data[caseIDColumnName] as int,
        this.createdDate = DateHelper.normalStringToDate(
            data[createdDateColumnName] as String);

  static String createFieldString() {
    return '''
      $idColumnName integer primary key autoincrement,
      $titleColumnName text not null,
      $createdDateColumnName text not null,
      $caseIDColumnName integer not null,
      foreign key ($caseIDColumnName) references 
      ${GanjineCase.tableName}(${GanjineCase.idColumnName})
    ''';
  }

  static void createTable(sqlite.Batch dbBatch) {
    DBSchemaHelper.createTable(dbBatch, tableName, createFieldString());
  }

  @override
  Future<int> deleteFromDB(sqlite.Database dbInstance) async {
    return DBQueryHelper.delete(dbInstance, tableName, idColumnName, this.id);
  }

  @override
  Future<int> insertToDB(sqlite.Database dbInstance) async {
    return DBQueryHelper.insert(dbInstance, tableName, this.toMap());
  }

  @override
  List<String> listofColumnNames() {
    return [
      idColumnName,
      titleColumnName,
      createdDateColumnName,
      caseIDColumnName
    ];
  }

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      titleColumnName: this.title,
      createdDateColumnName: DateHelper.normalDateToString(this.createdDate),
      caseIDColumnName: this.caseId,
    };
    if (id != -1) {
      map[idColumnName] = id;
    }

    return map;
  }

  @override
  Future<int> updateInDB(sqlite.Database dbInstance) async {
    return DBQueryHelper.update(
        dbInstance, tableName, this.toMap(), idColumnName, this.id);
  }
}
