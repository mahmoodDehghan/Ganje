import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/helpers/utils.dart';
import 'package:ganje/models/dbschema/gsecret.dart';
import 'package:ganje/providers/db_provider.dart';
import 'package:ganje/screens/add_secret_screen.dart';
import 'package:ganje/widgets/page_structures/basescaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/secret_provider.dart';

class SecretDetailScreen extends HookWidget {
  static const String routeName = '/secretdetail';

  @override
  Widget build(BuildContext context) {
    var secretId = ModalRoute.of(context)!.settings.arguments as int;
    var secret = useProvider(secretFutureProvider(secretId));
    return BaseScaffold(
      hasAppbar: true,
      hasTextTitle: true,
      title: secret.when(
        data: (data) => data.title,
        loading: () => 'loading...',
        error: (error, _stack) {
          print(error);
          print(_stack);
          return 'error';
        },
      ),
      hasActionButton: true,
      hasFloating: true,
      floatingWidget: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(
            AddSecretScreen.routeName,
            arguments: {'from': 'detail', 'secId': secretId},
          );
          context.refresh(secretFutureProvider(secretId));
        },
        child: const Icon(Icons.edit),
      ),
      actionWidget: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          var result = await showConfirmDialog(
            context,
            'are you sure to delete this secret?',
          ) as bool;
          if (result) {
            var dbInstance = await context.read(dbInstanceProvider.future);
            await DBQueryHelper.delete(dbInstance, GanjineSecret.tableName,
                GanjineSecret.idColumnName, secretId);
            Navigator.of(context).pop();
          }
        },
      ),
      child: secret.when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ListView.separated(
              itemCount: data.items.length,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10.0,
                );
              },
              itemBuilder: (context, index) {
                var item = data.items.entries.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(item.value.keys.first + ' : '),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          item.value.values.first,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (_, __) => Center(
          child: Text('error occurred!'),
        ),
      ),
    );
  }
}
