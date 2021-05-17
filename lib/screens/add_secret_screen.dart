import 'package:flutter/material.dart';
import 'package:ganje/helpers/cryption/rsacipherhelper.dart';
import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import 'package:ganje/models/dbschema/gsecret.dart';
import 'package:ganje/models/dbschema/gsecret_item.dart';
import 'package:ganje/providers/db_provider.dart';
import 'package:ganje/providers/key_provider.dart';
import 'package:ganje/providers/secret_provider.dart';
import 'package:ganje/widgets/compositions/secret_item_widget.dart';
import 'package:ganje/widgets/page_structures/basescaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddSecretScreen extends StatefulWidget {
  static const String routeName = '/addSecret';
  static const String pageTitle = 'addSecret';

  @override
  _AddSecretScreenState createState() => _AddSecretScreenState();
}

class _AddSecretScreenState extends State<AddSecretScreen> {
  //TODO: isRich initial in Edit mode
  //TODO: check duplicate title in a case

  var _isInit = true;
  var titleController = TextEditingController();
  var _currentSecId = 0;
  var _isInEdit = false;
  var _valKey = 1;
  late Map<Key, Map<String, String>> secretItems;

  final _formKey = GlobalKey<FormState>();
  int? _caseId;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      secretItems = {
        ValueKey(_valKey): {'': ''}
      };
      if (ModalRoute.of(context)!.settings.arguments != null) {
        var _args =
            ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
        if (_args['from'] == 'secretlist') _caseId = _args['data'] as int;
        if (_args['from'] == 'detail') {
          //var secret = _args['data'] as Secret;
          _currentSecId = _args['secId'] as int;
          var secret =
              await context.read(secretFutureProvider(_currentSecId).future);
          titleController.text = secret.title;
          setState(() {
            _caseId = secret.caseId;
            secretItems = secret.items;
            _isInEdit = true;
            _valKey = secretItems.length + 1;
            _isInit = false;
          });
        }
      }
    }
    super.didChangeDependencies();
  }

  void addItem(Secret current) {
    var k = ValueKey(_valKey);
    current.addItem(k, '', '');
  }

  void onPlusClicked(Secret current) {
    //_formKey.currentState!.save();
    addItem(current);
    _valKey++;
  }

  void onMinusClicked(Key key, Secret current) {
    //_formKey.currentState!.save();
    current.removeItem(key);
    // current.removeFromTempTitles(key as ValueKey<int>);
  }

  void onSavedItemTitle(val, key, current) {
    current.changeItemTitle(key, val ?? '');
  }

  void onSavedItem(String? val, Key key, Secret current) {
    current.changeItemValue(key, val ?? '');
  }

  String? onTitleValidator(val, current) {
    if (val == null || val.isEmpty) return 'please enter the field title!';
    if (!current.isValidTitleItem(val)) return 'duplicate title!';
  }

  void onItemTitleChanged(String? val, Key key, Secret current) {
    var entry = val ?? '';
    current.changeItemTitle(key, entry);
    // current.changeItemValue(key, val!);
    // current.addToTempTitles(key, val);
  }

  void onItemValueChanged(String? val, Key key, Secret current) {
    var entry = val ?? '';
    current.changeItemValue(key, entry);
  }

  SecretItemWidget getSecretItem(Key key, Map<String, String> value,
      bool isFirst, bool isLast, Secret current) {
    return SecretItemWidget(
        widgetKey: key,
        onPlusClick: () => onPlusClicked(current),
        onMinusClick: (key) => onMinusClicked(key, current),
        onSecretItemSaved: (_, __) => onSavedItem(_, __, current),
        onItemTitleChanged: (val) => onItemTitleChanged(val, key, current),
        onItemValueChanged: (val) => onItemValueChanged(val, key, current),
        titleValidator: (_) => onTitleValidator(_, current),
        initialTitle: value.keys.first,
        initialValue: value.values.first,
        isFirst: isFirst,
        isLast: isLast,
        onSecretItemTitleSaved: (_, __) => onSavedItemTitle(_, __, current));
  }

  void onDonePressed(Secret current) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var data;
      var secretId;
      var db = await context.read(dbInstanceProvider.future);
      if (_isInEdit) {
        await DBQueryHelper.deleteAll(
          db,
          GanjineSecretItem.tableName,
          "${GanjineSecretItem.secretIDColumnName} = ?",
          [_currentSecId],
        );
        var secMapData = await DBQueryHelper.getItem(
            db,
            GanjineSecret.tableName,
            GanjineSecret.allColumns,
            GanjineCase.idColumnName,
            _currentSecId);
        data = GanjineSecret.fromMap(secMapData!);
        data.caseId = current.caseId;
        data.title = current.title;
        secretId = _currentSecId;
        await DBQueryHelper.update(db, GanjineSecret.tableName, data.toMap(),
            GanjineCase.idColumnName, _currentSecId);
      } else {
        data = GanjineSecret.withTitle(current.title, current.caseId);
        secretId = await DBQueryHelper.insert(
            db, GanjineSecret.tableName, data.toMap());
      }
      var key = await context.read(keyProvider.future);
      var cipherHelper = RsaCipherHelper(key);
      for (var item in current.items.values)
        DBQueryHelper.insert(
            db,
            GanjineSecretItem.tableName,
            GanjineSecretItem.withSecretID(
              secretId,
              item.entries.first.key,
              cipherHelper.rsaEncrypt(item.entries.first.value),
            ).toMap());
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var cases = context.read(casesProvider);

    return Consumer(
      builder: (context, watch, child) {
        var secret = watch(secretProvider({
          Secret.titleConst: titleController.text,
          Secret.caseIdConst: _caseId ?? 1,
          Secret.itemsConst: secretItems,
        }));
        return BaseScaffold(
          hasAppbar: true,
          hasActionButton: true,
          actionWidget: IconButton(
            icon: Icon(Icons.done),
            onPressed: () => onDonePressed(secret),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'choose a title',
                      labelText: 'main title',
                    ),
                    controller: titleController,
                    onSaved: (newValue) => secret.changeTitle(newValue!),
                    validator: (newValue) {
                      if (newValue == null || newValue.isEmpty)
                        return 'title is required!';
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: cases.when(
                      data: (_cases) {
                        if (_cases.isEmpty) return Text('Error!');
                        return DropdownButtonFormField<GanjineCase>(
                          validator: (value) {
                            if (value == null) return 'please choose a case!';
                          },
                          decoration: InputDecoration(
                            labelText: 'Case',
                          ),
                          items: _cases
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e,
                                ),
                              )
                              .toList(),
                          value: _caseId != null
                              ? _cases
                                  .where((element) => element.id == _caseId)
                                  .first
                              : null,
                          elevation: 4,
                          onChanged: (val) {
                            secret.changeCase(val!.id);
                            setState(() {
                              _caseId = val.id;
                            });
                          },
                        );
                      },
                      loading: () => CircularProgressIndicator(),
                      error: (err, stack) => Text('error occurred!'),
                    ),
                  ),
                  ...secret.items.entries.map(
                    (key) {
                      return getSecretItem(
                          key.key,
                          key.value,
                          key.key == secret.items.keys.first,
                          key.key == secret.items.keys.last,
                          secret);
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
