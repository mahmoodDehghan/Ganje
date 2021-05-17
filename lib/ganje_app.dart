import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ganje/screens/add_secret_screen.dart';
import 'package:ganje/screens/home_screen.dart';
import 'package:ganje/screens/secret_detail_screen.dart';
import 'package:ganje/screens/secrets_list_screen.dart';

import './screens/pin_screen.dart';

import './widgets/containers/apptheme.dart';
import './screens/splash_screen.dart';

class GanjeApp extends HookWidget {
  static const String appName = 'Ganje';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: AppTheme(
        themeChild: Text('rsaKey.toString() + db.toString()'),
      ).themeData,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        PinScreen.routeName: (ctx) => PinScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        SecretsListScreen.routeName: (ctx) => SecretsListScreen(),
        AddSecretScreen.routeName: (ctx) => AddSecretScreen(),
        SecretDetailScreen.routeName: (ctx) => SecretDetailScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
