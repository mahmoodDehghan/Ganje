import 'package:flutter/material.dart';

import '../Buttons/ripplebutton.dart';

class PinPad extends StatefulWidget {
  final double buttonSize;
  final double pinRadius;
  final double verticalSpace;
  final double pinPadding;
  final void Function(String pin) onButtonClick;

  PinPad({required this.onButtonClick})
      : this.buttonSize = 40,
        this.pinRadius = 10,
        this.verticalSpace = 15,
        this.pinPadding = 5;

  PinPad.custom(
      {double? buttonSize,
      double? pinRadius,
      double? verticalSpace,
      double? pinPadding,
      required this.onButtonClick})
      : this.buttonSize = buttonSize ?? 40,
        this.pinRadius = pinRadius ?? 10,
        this.pinPadding = pinPadding ?? 5,
        this.verticalSpace = verticalSpace ?? 15;

  @override
  _PinPadState createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  Widget _getPinButtons(String numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < numbers.length; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.pinPadding),
            child: RippleButton.squareSize(
              size: widget.buttonSize,
              cornerRadius: widget.pinRadius,
              label: numbers.characters.elementAt(i),
              onClick: () => widget.onButtonClick(
                numbers.characters.elementAt(i),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _getPinButtons('123'),
        _getPinButtons('456'),
        _getPinButtons('789'),
        _getPinButtons('0'),
      ],
    );
  }
}
