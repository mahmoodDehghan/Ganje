import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecretItemWidget extends StatefulWidget {
  final Key widgetKey;
  final void Function() onPlusClick;
  final void Function(Key key) onMinusClick;
  final void Function(String? val, Key key) onSecretItemSaved;
  final void Function(String? val, Key key) onSecretItemTitleSaved;
  final void Function(String? val) onItemTitleChanged;
  final void Function(String? val) onItemValueChanged;
  final String? Function(String? val)? onTitleValidate;
  final String? initialTitle;
  final String? initialValue;
  final bool isFirst;
  final bool isLast;

  const SecretItemWidget({
    required this.widgetKey,
    required this.onPlusClick,
    required this.onMinusClick,
    required this.onSecretItemSaved,
    required this.onItemTitleChanged,
    required this.onItemValueChanged,
    required this.onSecretItemTitleSaved,
    this.initialTitle,
    this.initialValue,
    String? Function(String? val)? titleValidator,
    this.isFirst = false,
    this.isLast = false,
  }) : this.onTitleValidate = titleValidator;
  @override
  _SecretItemWidgetState createState() => _SecretItemWidgetState();
}

class _SecretItemWidgetState extends State<SecretItemWidget> {
  var _isRich = false;
  var _isRichChanged = false;
  final _valueFocus = FocusNode();

  String? defValidator(val) {
    if (val == null || val.isEmpty) return 'can\'t be empty!';
  }

  @override
  Widget build(BuildContext context) {
    if (_isRichChanged && _valueFocus.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
      _isRichChanged = false;
    }
    return Padding(
      key: widget.widgetKey,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                TextFormField(
                  validator: widget.onTitleValidate ?? defValidator,
                  decoration: InputDecoration(hintText: 'item title'),
                  onSaved: (_) =>
                      widget.onSecretItemTitleSaved(_, widget.widgetKey),
                  onChanged: widget.onItemTitleChanged,
                  initialValue: widget.initialTitle,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _valueFocus,
                  validator: defValidator,
                  initialValue: widget.initialValue,
                  onChanged: widget.onItemValueChanged,
                  onSaved: (_) => widget.onSecretItemSaved(_, widget.widgetKey),
                  decoration: InputDecoration(hintText: 'item value'),
                  maxLines: _isRich ? 20 : 1,
                  minLines: 1,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: CheckboxListTile(
                  title: Text(
                    'rich',
                  ),
                  value: _isRich,
                  onChanged: (val) {
                    setState(() {
                      _isRich = val!;
                      _isRichChanged = true;
                    });
                  }),
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              return Flexible(
                flex: 1,
                child: Column(
                  children: [
                    if (widget.isLast)
                      IconButton(
                          icon: Icon(Icons.add_circle),
                          onPressed: () {
                            widget.onPlusClick();
                          }),
                    SizedBox(
                      height: 10,
                    ),
                    if (!widget.isFirst)
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          widget.onMinusClick(widget.widgetKey);
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
