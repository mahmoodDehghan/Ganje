import 'package:sqflite/sqflite.dart' as sqlite;

abstract class SqlModel {
  List<String> listofColumnNames();
  Map<String, Object?> toMap();
  void insertToDB(sqlite.Database dbInstance);
  void deleteFromDB(sqlite.Database dbInstance);
  void updateInDB(sqlite.Database dbInstance);
}
