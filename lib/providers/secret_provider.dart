import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ganje/helpers/cryption/rsacipherhelper.dart';
import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/models/dbschema/gsecret.dart';
import 'package:ganje/models/dbschema/gsecret_item.dart';
import 'package:ganje/providers/db_provider.dart';
import 'package:ganje/providers/key_provider.dart';

final secretProvider =
    ChangeNotifierProvider.autoDispose.family<Secret, Map<String, Object?>>(
  (ref, details) => Secret(
    details[Secret.titleConst] as String,
    details[Secret.caseIdConst] as int,
    details[Secret.itemsConst] as Map<Key, Map<String, String>>,
  ),
);

final secretFutureProvider = FutureProvider.autoDispose.family<Secret, int>(
  (ref, id) async {
    var db = await ref.read(dbInstanceProvider.future);
    var secret = await DBQueryHelper.getItem(
      db,
      GanjineSecret.tableName,
      GanjineSecret.allColumns,
      GanjineSecret.idColumnName,
      id,
    );
    var secretItems = await DBQueryHelper.getQueryResult(
      db,
      GanjineSecretItem.tableName,
      columns: GanjineSecretItem.allColumns,
      where: '${GanjineSecretItem.secretIDColumnName} = ?',
      whereArgs: [secret![GanjineSecret.idColumnName]],
    );
    var key = await ref.read(keyProvider.future);
    Map<ValueKey, Map<String, String>> items = {};
    for (var i = 0; i < secretItems.length; i++)
      items[ValueKey(i)] = {
        secretItems.elementAt(i)[GanjineSecretItem.titleColumnName] as String:
            RsaCipherHelper(key).rsaDecrypt(secretItems
                .elementAt(i)[GanjineSecretItem.valueColumnName] as String)
      };
    return Secret(
      secret[GanjineSecret.titleColumnName] as String,
      secret[GanjineSecret.caseIDColumnName] as int,
      items,
    );
  },
);

class Secret extends ChangeNotifier {
  static const String caseIdConst = 'caseId';
  static const String itemsConst = 'items';
  static const String titleConst = 'title';
  String title;
  int caseId;
  Map<Key, Map<String, String>> items;
  Secret(this.title, this.caseId, this.items);

  void addItem(Key key, String title, String value) {
    items[key] = {title: value};
    notifyListeners();
  }

  void removeItem(Key key) {
    items.removeWhere((k, value) => k == key);
    notifyListeners();
  }

  void changeTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void changeCase(int id) {
    this.caseId = id;
    notifyListeners();
  }

  void changeItemValue(Key key, String newValue) {
    var item = this.items[key];
    var k = item!.keys.first;
    item[k] = newValue;
    notifyListeners();
  }

  void changeItemTitle(Key key, String title) {
    var value = this.items[key]!.values.first;
    this.items[key]!.remove(title);
    this.items[key] = {title: value};
    //notifyListeners();
  }

  bool isValidTitleItem(String title) {
    if (items.values.where((item) => item.keys.first == title).length > 1)
      return false;
    return true;
  }
}
