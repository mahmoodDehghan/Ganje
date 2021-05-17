import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import 'package:ganje/models/dbschema/gsecret.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

import '../models/ganjine_db_model.dart';

final dbInstanceProvider =
    FutureProvider.autoDispose<sqlite.Database>((_) async {
  return await GanjineDB.open();
});

final casesProvider =
    FutureProvider.autoDispose<List<GanjineCase>>((ref) async {
  var db = await ref.read(dbInstanceProvider.future);
  return GanjineCase.getAll(
      await DBQueryHelper.getAll(db, GanjineCase.tableName));
});

final caseProvider = FutureProvider.family.autoDispose((ref, id) async {
  var db = await ref.read(dbInstanceProvider.future);
  var item = await DBQueryHelper.getItem(db, GanjineCase.tableName,
      GanjineCase.allColumns, GanjineCase.idColumnName, id);
  return GanjineCase.fromMap(item!);
});

final secretsProvider = FutureProvider.family.autoDispose((ref, caseId) async {
  var db = await ref.read(dbInstanceProvider.future);
  var results = await DBQueryHelper.getQueryResult(
    db,
    GanjineSecret.tableName,
    where: '${GanjineSecret.caseIDColumnName} = ?',
    whereArgs: [caseId],
  );
  return results.map((e) => GanjineSecret.fromMap(e)).toList();
});
