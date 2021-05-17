import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/helpers/utils.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import 'package:ganje/models/dbschema/gsecret.dart';
import 'package:ganje/providers/page_states_provider.dart';
import 'package:ganje/screens/add_secret_screen.dart';
import 'package:ganje/screens/secret_detail_screen.dart';
import 'package:ganje/widgets/Buttons/simplebutton.dart';
import 'package:ganje/widgets/page_structures/basescaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/db_provider.dart';

class SecretsListScreen extends HookWidget {
  //TODO: all query in default 'all' case
  //TODO: remove ability of edit Name and delete in default 'all' case
  static const String routeName = '/secrets';
  final _formKey = GlobalKey<FormState>();

  Future<dynamic> showConfirmDialog(
      BuildContext context, String message) async {
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (ctx) {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Wrap(children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Text(
                                message,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SimpleButton(
                                    label: 'No',
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                  SimpleButton(
                                    label: 'Yes',
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var caseId = ModalRoute.of(context)!.settings.arguments as int;
    var secretCase = useProvider(caseProvider(caseId));
    var secrets = useProvider(secretsProvider(caseId));
    var pageCase = useProvider(casePageProvider);
    return BaseScaffold(
      hasFloating: true,
      hasActionButton: true,
      hasTextTitle: !pageCase.isInEdit,
      titleWidget: pageCase.isInEdit
          ? Form(
              key: _formKey,
              child: TextFormField(
                initialValue: pageCase.currentCase!.name,
                validator: requiredValidator,
                onSaved: (val) {
                  pageCase.changeCaseName(val!);
                },
              ),
            )
          : null,
      actionWidget: pageCase.isInEdit
          ? IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  var db = await context.read(dbInstanceProvider.future);
                  DBQueryHelper.update(
                    db,
                    GanjineCase.tableName,
                    pageCase.currentCase!.toMap(),
                    GanjineCase.idColumnName,
                    caseId,
                  );
                  pageCase.exitEditMode();
                }
              },
            )
          : IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                pageCase.enterEditMode();
              },
            ),
      floatingWidget: pageCase.isInEdit
          ? FloatingActionButton(
              child: const Icon(Icons.delete),
              onPressed: () async {
                var result = await showConfirmDialog(
                  context,
                  'are you sure want to delete this case? \n' +
                      'all the secrets of this case will be deleted too!!!',
                ) as bool;
                if (result) {
                  var db = await context.read(dbInstanceProvider.future);
                  if (pageCase.secrets != null)
                    for (var item in pageCase.secrets!)
                      await DBQueryHelper.delete(db, GanjineSecret.tableName,
                          GanjineSecret.idColumnName, item.id);
                  DBQueryHelper.delete(db, GanjineCase.tableName,
                      GanjineCase.idColumnName, caseId);
                  Navigator.of(context).pop();
                }
              },
            )
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).pushNamed(
                  AddSecretScreen.routeName,
                  arguments: {'from': 'secretlist', 'data': caseId},
                );
                context.refresh(secretsProvider(caseId));
              },
            ),
      hasAppbar: true,
      title: secretCase.when(
        data: (data) {
          pageCase.setCase(data);
          return data.name;
        },
        loading: () => 'loading...',
        error: (_, __) => 'something\'s wrong!',
      ),
      child: secrets.when(data: (data) {
        pageCase.setSecrets(data);
        if (data.isEmpty)
          return Center(
            child: Text('There is no secret in this case!'),
          );
        return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 1.0,
                color: Theme.of(context).primaryColor,
              );
            },
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].title),
                trailing: pageCase.isInEdit
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          var result = await showConfirmDialog(
                            context,
                            'are you sure to delete this secret?',
                          ) as bool;
                          if (result) {
                            var dbInstance =
                                await context.read(dbInstanceProvider.future);
                            await DBQueryHelper.delete(
                                dbInstance,
                                GanjineSecret.tableName,
                                GanjineSecret.idColumnName,
                                data[index].id);
                            context.refresh(secretsProvider(caseId));
                          }
                        },
                      )
                    : Icon(
                        Icons.note,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                    SecretDetailScreen.routeName,
                    arguments: data[index].id,
                  );
                  context.refresh(secretsProvider(caseId));
                },
              );
            });
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }, error: (err, stack) {
        print(err);
        return Center(
          child: Text('Somthing\'s wrong happenned!'),
        );
      }),
    );
  }
}
