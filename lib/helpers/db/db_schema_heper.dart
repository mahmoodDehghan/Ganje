import 'package:sqflite/sqflite.dart' as sqlite;

class DBSchemaHelper {
  static void createTable(
      sqlite.Batch dbBatch, String tableName, String tableFields) {
    dbBatch.execute('drop table if exists $tableName');
    dbBatch.execute('''create table $tableName (
      $tableFields
      )''');
  }

  static void alterTable(
      sqlite.Batch dbBatch, String tableName, String alterString) {
    dbBatch.execute('''ALTER TABLE $tableName $alterString ''');
  }

  static void dropTable(sqlite.Batch dbBatch, String tableName) {
    dbBatch.execute('''DROP TABLE $tableName''');
  }
}
