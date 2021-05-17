import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  ///creates simple elevated button with [primaryColor]
  ///background and default [textStyle]
  final void Function() onPressed;
  final String label;

  SimpleButton({
    required this.onPressed,
    required this.label,
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //style: ButtonStyle(),
      child: Center(
        child: Text(label),
      ),
      onPressed: onPressed,
    );
  }
}
