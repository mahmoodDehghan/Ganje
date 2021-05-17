import 'package:flutter/material.dart';
import 'package:ganje/helpers/db/db_query_helper.dart';
import 'package:ganje/helpers/file_helper.dart';
import 'package:ganje/helpers/path/path_provider_helper.dart';
import 'package:ganje/models/dbschema/gcase.dart';
import '../helpers/package_info.dart';
import '../screens/pin_screen.dart';
import '../widgets/page_structures/two_part_vertical_page.dart';
import '../providers/db_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../providers/key_provider.dart';

import 'dart:async';

import '../widgets/page_structures/basescaffold.dart';
import '../widgets/Images/asset_image.dart';
import '../widgets/seprators/vertical_space.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  static const String pageTitle = 'Splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final Widget upperPart = Center(
    child: ImageViewFromAsset.squreSize(
      imageAddress: 'assets/images/gsafe.png',
      size: 70,
    ),
  );

  Future<PinScreenState> _initApp() async {
    //final rsaKey = await context.read(keyProvider.future);
    final appPath = await PathProvider.appDirPath;
    final keyFile =
        FileManager(fileName: PinScreen.keyFileName, filePath: appPath!);
    var pstate;
    if (await keyFile.isExists())
      pstate = PinScreenState.login;
    else
      pstate = PinScreenState.register;
    final dbInstnce = await context.read(dbInstanceProvider.future);
    var gCases = await DBQueryHelper.getAll(dbInstnce, GanjineCase.tableName);
    if (gCases.isEmpty) {
      await DBQueryHelper.insert(dbInstnce, GanjineCase.tableName,
          GanjineCase.withName('All').toMap());
    }
    _timer = Timer(
        Duration(seconds: 3),
        () => Navigator.of(context)
            .pushReplacementNamed(PinScreen.routeName, arguments: pstate));
    return pstate;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pstate = _initApp();
    final Widget lowerPart = Column(
      children: <Widget>[
        FutureBuilder(
            future: pstate,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              else
                return Text('initializing...');
            }),
        VerticalSpace(),
        FutureBuilder(
            future: PackageInfoHelper.appVersion,
            builder: (context, snapshot) {
              if (snapshot.hasData) return Text('version: ${snapshot.data}');
              return Text('');
            }),
      ],
    );
    return BaseScaffold(
      hasAppbar: false,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: TwoPartVerticalPage.customFlex(
            upperPart: upperPart, lowerPart: lowerPart, upFlex: 4, lowFlex: 1),
      ),
    );
  }
}
