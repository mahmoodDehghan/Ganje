import 'package:flutter/material.dart';

class RippleButton extends StatelessWidget {
  final double height;
  final double width;
  final double cornerRadius;
  final void Function() onClick;
  final String label;
  final double elevation;

  RippleButton({
    required this.height,
    required this.width,
    required this.elevation,
    required this.cornerRadius,
    required this.label,
    required this.onClick,
  });

  RippleButton.squareSize({
    required double size,
    this.elevation = 2,
    required this.cornerRadius,
    required this.label,
    required this.onClick,
  })   : this.width = size,
        this.height = size;

  RippleButton.circleShape({
    required double size,
    this.elevation = 2,
    required this.label,
    required this.onClick,
  })   : this.width = size,
        this.height = size,
        this.cornerRadius = size * (4 / 10);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).accentColor,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        child: SizedBox(
          height: this.height,
          width: this.width,
          child: Center(
            child: Text(label),
          ),
        ),
        onTap: onClick,
      ),
    );
  }
}
