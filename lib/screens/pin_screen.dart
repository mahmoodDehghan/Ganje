import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ganje/helpers/cryption/rsacipherhelper.dart';
import 'package:ganje/providers/key_provider.dart';
import 'package:ganje/screens/home_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/file_helper.dart';
import '../helpers/path/path_provider_helper.dart';
import '../widgets/compositions/pin_pad.dart';
import '../widgets/customtextfields/pincode.dart';
import '../widgets/page_structures/basescaffold.dart';
import '../widgets/page_structures/two_part_vertical_page.dart';

enum PinScreenState { login, register, confirm }

class PinScreen extends StatefulWidget {
  static const keyFileName = 'uk.k';
  //TODO: make progress bar for saving file and long procees of transition to home
  static const String routeName = '/pinScreen';
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _enteredPin = '';
  String _message = '';
  String _currentPin = '';
  late PinScreenState _pageState;

  @override
  void didChangeDependencies() {
    if (_message.isEmpty) {
      var arg = ModalRoute.of(context)!.settings.arguments as PinScreenState;
      _pageState = arg;
      if (_pageState == PinScreenState.register)
        _message = 'Enter a secure pin you can keep in your mind.';
      else
        _message = 'Enter your Pin!';
    }
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    if (_pageState == PinScreenState.confirm) {
      setState(() {
        _pageState = PinScreenState.register;
        _currentPin = '';
        _enteredPin = '';
        _message = 'Enter a secure pin you can keep in your mind.';
      });
      return false;
    }
    return true;
  }

  void _onBackPressed() {
    if (_pageState == PinScreenState.confirm) {
      setState(() {
        _pageState = PinScreenState.register;
        _currentPin = '';
        _enteredPin = '';
        _message = 'Enter a secure pin you can keep in your mind.';
      });
    } else {
      SystemNavigator.pop();
    }
  }

  bool _isEnteredPinCorrect(String pin) {
    return pin == _currentPin;
  }

  Future<FileManager> _getPinFileManager() async {
    final applocal = await PathProvider.appDirPath;
    return FileManager(fileName: PinScreen.keyFileName, filePath: applocal!);
  }

  void _savePinToFile() async {
    var pinFile = await _getPinFileManager();
    if (await pinFile.isExists() == false) await pinFile.makeFile();
    var userKey = await context.read(keyProvider.future);
    var cipherHelper = RsaCipherHelper(userKey);
    await pinFile.stringWrite(cipherHelper.rsaEncrypt(_currentPin));
  }

  void _goToHomePage() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  void onNextPressed() async {
    if (_pageState == PinScreenState.register) {
      if (_currentPin.length < 4) {
        setState(() {
          _currentPin = '';
          _message = 'Enter a 4 Digit pin you can remember!';
        });
      } else {
        setState(() {
          _enteredPin = _currentPin;
          _currentPin = '';
          _message = 'Confirm your secure pin';
          _pageState = PinScreenState.confirm;
        });
      }
    } else if (_pageState == PinScreenState.confirm) {
      if (_isEnteredPinCorrect(_enteredPin)) {
        _savePinToFile();
        _goToHomePage();
      } else {
        setState(() {
          _message = 'It\'s not your entered Pin!' +
              'Please Confirm your secure pin correctly!';
          _currentPin = '';
        });
      }
    } else {
      var pinFile = await _getPinFileManager();
      var userKey = await context.read(keyProvider.future);
      var cipherHelper = RsaCipherHelper(userKey);
      var userPin = cipherHelper.rsaDecrypt(await pinFile.readString());
      if (_isEnteredPinCorrect(userPin))
        _goToHomePage();
      else {
        setState(() {
          _message = 'Wrong Pin! Please Enter your Pin!';
          _currentPin = '';
        });
      }
    }
  }

  void onUndoPressed() {
    setState(() {
      if (_currentPin.length != 0)
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
    });
  }

  onPadButtonClicked(String pin) {
    setState(() {
      if (_currentPin.length < 4) _currentPin += pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget lowerPart = TwoPartVerticalPage.customFlex(
      upperPart: Row(
        children: [
          if (_pageState == PinScreenState.confirm)
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                    color: Theme.of(context).canvasColor,
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: _onBackPressed),
              ),
            ),
          Expanded(
            flex: 8,
            child: Center(
              child: PinCode.squarePins(
                pinCount: 4,
                pin: _currentPin,
                pinBoarderRadius: 5,
                size: 45,
                isKeyBoardEnabled: false,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: IconButton(
                        color: Theme.of(context).canvasColor,
                        icon: Icon(
                          Icons.backspace_rounded,
                        ),
                        onPressed: onUndoPressed),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: IconButton(
                        color: Theme.of(context).canvasColor,
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: onNextPressed),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      lowerPart: PinPad.custom(
        onButtonClick: onPadButtonClicked,
        pinPadding: 10,
        pinRadius: 10,
        buttonSize: 50,
      ),
      upFlex: 1,
      lowFlex: 4,
    );
    final Widget upperPart = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          _message,
          textAlign: TextAlign.center,
        ),
      ),
    );
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BaseScaffold(
        hasAppbar: false,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: TwoPartVerticalPage(
            upperPart: upperPart,
            lowerPart: lowerPart,
          ),
        ),
      ),
    );
  }
}
