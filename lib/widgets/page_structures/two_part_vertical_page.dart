import 'package:flutter/material.dart';

class TwoPartVerticalPage extends StatelessWidget {
  final Widget upperPart;
  final Widget lowerPart;
  final int upFlex;
  final int lowFlex;

  TwoPartVerticalPage({required this.upperPart, required this.lowerPart})
      : upFlex = 1,
        lowFlex = 1;
  TwoPartVerticalPage.customFlex(
      {required this.upperPart,
      required this.lowerPart,
      required this.upFlex,
      required this.lowFlex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: upperPart,
          flex: upFlex,
        ),
        Expanded(
          child: lowerPart,
          flex: lowFlex,
        )
      ],
    );
  }
}
