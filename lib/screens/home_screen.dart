import 'package:flutter/material.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import '../providers/db_provider.dart';
import '../screens/add_case_screen.dart';
import '../screens/secrets_list_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/Buttons/expandablefloatingbutton/expandable_floating.dart';
import '../widgets/Buttons/expandablefloatingbutton/round_action_button.dart';
import '../widgets/page_structures/basescaffold.dart';
import '../screens/add_secret_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  static const String pageTitle = 'Ganje';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //TODO: setting option
  //TODO: multilanguage adding persian language and rtl layout
  var _needTorefresh = false;
  //var _cases;

  Widget _makeCasesGrid(List<GanjineCase> datas) {
    return GridView.builder(
      itemCount: datas.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: TextButton.icon(
            icon: Icon(Icons.folder),
            label: Text(datas.elementAt(index).name),
            onPressed: () async {
              await Navigator.of(context).pushNamed(SecretsListScreen.routeName,
                  arguments: datas.elementAt(index).id);
              context.refresh(casesProvider);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: HomeScreen.pageTitle,
      hasAppbar: true,
      hasFloating: true,
      hasActionButton: false,
      floatingWidget: ExpandableFloatButton(
          distance: 75,
          mainIcon: Icon(Icons.add),
          children: [
            ActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddSecretScreen.routeName);
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (context) => AddSecretScreen(_cases));
                },
                icon: Icon(Icons.add_box)),
            ActionButton(
                onPressed: () async {
                  var result = await showModalBottomSheet(
                    context: context,
                    builder: (context) => AddCaseScreen(),
                  );
                  setState(() {
                    _needTorefresh = result as bool;
                  });
                },
                icon: Icon(Icons.dashboard_customize)),
          ]),
      child: Consumer(
        builder: (context, watch, child) {
          var casesp = watch(casesProvider);
          if (_needTorefresh) context.refresh(casesProvider);
          return casesp.map(
            data: (data) {
              var cases = data.value;
              //_cases = cases;
              _needTorefresh = false;
              return _makeCasesGrid(cases);
            },
            loading: (_) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error) => Text('can\'t load cases! beacause of $error'),
          );
        },
      ),
    );
  }
}
