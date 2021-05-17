import 'package:flutter/material.dart';

class PinTextField extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final TextEditingController controller;
  final Key textFieldkey;
  final bool keyboardEnabled;

  PinTextField(
      {required this.height,
      required this.width,
      required this.borderRadius,
      TextEditingController? controller,
      bool? enabled,
      required this.textFieldkey})
      : this.keyboardEnabled = enabled ?? true,
        this.controller = controller ?? TextEditingController();

  PinTextField.squareSize(
      {required double size,
      required this.borderRadius,
      TextEditingController? controller,
      bool? enabled,
      required this.textFieldkey})
      : this.width = size,
        this.keyboardEnabled = enabled ?? true,
        this.controller = controller ?? TextEditingController(),
        this.height = size;

  PinTextField.circle(
      {required double size,
      TextEditingController? controller,
      bool? enabled,
      required this.textFieldkey})
      : this.width = size,
        this.height = size,
        this.keyboardEnabled = enabled ?? true,
        this.controller = controller ?? TextEditingController(),
        this.borderRadius = size * (4 / 10);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: TextField(
          controller: controller,
          key: textFieldkey,
          textAlign: TextAlign.center,
          enabled: keyboardEnabled,
          decoration: InputDecoration(
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
