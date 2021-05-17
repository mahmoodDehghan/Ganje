import 'package:flutter/material.dart';
import '../customtextfields/pincode_textfield.dart';

class PinCode extends StatelessWidget {
  final int pinCount;
  final String pin;
  final List<TextEditingController> controllers = [];
  final double pinHeight;
  final double pinWidth;
  final bool isCircle;
  final bool isSquare;
  final bool isKeyBoardEnabled;
  final double pinBoarderRadius;

  PinCode({
    required this.pinCount,
    required this.pinHeight,
    required this.pinWidth,
    required this.isCircle,
    required this.isSquare,
    required this.pin,
    this.isKeyBoardEnabled = true,
    required this.pinBoarderRadius,
  }) {
    for (int i = 0; i < pinCount; i++)
      controllers.add(
        TextEditingController(
          text: (pin.length - 1 >= i) ? pin.characters.elementAt(i) : '',
        ),
      );
  }

  PinCode.squarePins({
    required this.pinCount,
    required double size,
    required this.pin,
    this.isKeyBoardEnabled = true,
    required this.pinBoarderRadius,
  })   : this.pinWidth = size,
        this.pinHeight = size,
        this.isSquare = true,
        this.isCircle = false {
    for (int i = 0; i < pinCount; i++)
      controllers.add(
        TextEditingController(
          text: (pin.length - 1 >= i) ? pin.characters.elementAt(i) : '',
        ),
      );
  }

  PinCode.circlePins({
    required this.pinCount,
    required double size,
    this.isKeyBoardEnabled = true,
    required this.pin,
  })   : this.pinWidth = size,
        this.pinHeight = size,
        this.pinBoarderRadius = size * (4 / 10),
        this.isSquare = false,
        this.isCircle = true {
    for (int i = 0; i < pinCount; i++)
      controllers.add(
        TextEditingController(
          text: (pin.length - 1 >= i) ? pin.characters.elementAt(i) : '',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < pinCount; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: PinTextField(
              height: pinHeight,
              width: pinWidth,
              enabled: isKeyBoardEnabled,
              controller: controllers[i],
              borderRadius: pinBoarderRadius,
              textFieldkey: ValueKey(i),
            ),
          )
      ],
    );
  }
}
