import 'package:flutter/material.dart';
import 'package:ganje/widgets/Buttons/simplebutton.dart';

String? requiredValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'this can\'t be empty!';
  }
}

Future<dynamic> showConfirmDialog(BuildContext context, String message) async {
  return showDialog(
      context: context,
      useSafeArea: true,
      builder: (ctx) {
        return Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Wrap(children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SimpleButton(
                                  label: 'No',
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                SimpleButton(
                                  label: 'Yes',
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      });
}
