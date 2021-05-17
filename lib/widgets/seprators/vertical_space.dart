import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double space;

  VerticalSpace() : space = 8;
  VerticalSpace.withSpace(this.space);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space,
    );
  }
}
