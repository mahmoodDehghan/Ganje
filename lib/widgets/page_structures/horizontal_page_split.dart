import 'package:flutter/material.dart';

class HorizontalSplitSection extends StatelessWidget {
  final Widget leftSection;
  final Widget rightSection;
  final int leftFlex;
  final int rightFlex;
  HorizontalSplitSection({
    required this.leftSection,
    required this.rightSection,
    required this.leftFlex,
    required this.rightFlex,
  });
  HorizontalSplitSection.halfSplit({
    required this.leftSection,
    required this.rightSection,
  })   : this.leftFlex = 1,
        this.rightFlex = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: leftSection,
          flex: leftFlex,
        ),
        Expanded(
          child: rightSection,
          flex: rightFlex,
        )
      ],
    );
  }
}
