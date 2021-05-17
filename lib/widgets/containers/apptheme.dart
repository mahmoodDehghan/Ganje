import 'package:flutter/material.dart';

class AppTheme extends StatelessWidget {
  static const MaterialColor defPrimarySwatch = Colors.blue;
  static const MaterialColor defAccentColor = Colors.amber;
  static const String defFontFamily = 'Roboto';
  static const String defkey = 'DefaultTheme';

  final Widget? themeChild;
  final ThemeData _themeData;
  final String? themeKey;

  ThemeData get themeData {
    return _themeData;
  }

  AppTheme(
      {ThemeData? themeData,
      this.themeKey,
      required this.themeChild,
      MaterialColor primarySwatch = defPrimarySwatch,
      MaterialColor accentColor = defAccentColor,
      String? defaultFont = defFontFamily})
      : _themeData = themeData ??
            ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: primarySwatch,
              ),
              primaryColor: primarySwatch,
              accentColor: accentColor,
              fontFamily: defaultFont,
              textTheme: TextTheme(
                headline1: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: TextStyle(
                  fontSize: 16,
                ),
              ),
            );

  @override
  Widget build(BuildContext context) {
    return Theme(
      key: ValueKey(this.themeKey ?? defkey),
      data: _themeData,
      child: themeChild!,
    );
  }
}
