import 'package:flutter/material.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import 'package:ganje/models/dbschema/gsecret.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final casePageProvider =
    ChangeNotifierProvider.autoDispose((ref) => CasePageState());

class CasePageState extends ChangeNotifier {
  bool _isInEditMode = false;
  GanjineCase? currentCase;
  List<GanjineSecret>? secrets;

  void setCase(GanjineCase cc) {
    currentCase = cc;
  }

  void changeCaseName(String newName) {
    currentCase!.name = newName;
    notifyListeners();
  }

  void setSecrets(List<GanjineSecret> items) {
    secrets = items;
  }

  bool get isInEdit {
    return _isInEditMode;
  }

  void enterEditMode() {
    _isInEditMode = true;
    notifyListeners();
  }

  void exitEditMode() {
    _isInEditMode = false;
    notifyListeners();
  }
}
