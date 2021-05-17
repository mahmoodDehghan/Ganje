import 'package:flutter/material.dart';

Widget getPageStructure(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Container(
        child: child,
      ),
    ),
  );
}
