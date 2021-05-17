import 'package:flutter/material.dart';
import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import 'package:ganje/providers/db_provider.dart';
import 'package:ganje/widgets/Buttons/simplebutton.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddCaseScreen extends StatefulWidget {
  @override
  _AddCaseScreenState createState() => _AddCaseScreenState();
}

class _AddCaseScreenState extends State<AddCaseScreen> {
  final _formKey = GlobalKey<FormState>();
  var _currentCase = GanjineCase.withName('');
  var _nameUniqueValidation = true;

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'please choose a name for case!';
    if (!_nameUniqueValidation) return 'you can\'t use this name!';
  }

  @override
  Widget build(BuildContext context) {
    if (_formKey.currentState != null) _formKey.currentState!.validate();
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: SizedBox(
        height: 200,
        width: 300,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: nameValidator,
                  onChanged: (value) {
                    _nameUniqueValidation = true;
                  },
                  onSaved: (value) {
                    _currentCase.name = value!;
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 90,
                  child: SimpleButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        var cases = await context.read(casesProvider.future);
                        for (var item in cases) {
                          if (item.name.toLowerCase() ==
                              _currentCase.name.toLowerCase()) {
                            setState(() {
                              _nameUniqueValidation = false;
                            });
                            return;
                          }
                        }
                        var db = await context.read(dbInstanceProvider.future);
                        await DBQueryHelper.insert(
                            db, GanjineCase.tableName, _currentCase.toMap());
                        Navigator.pop(context, true);
                      }
                    },
                    label: 'add',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
