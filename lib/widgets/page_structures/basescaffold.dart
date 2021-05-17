import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool hasAppbar;
  final bool hasActionButton;
  final bool hasFloating;
  final bool hasTextTitle;
  final Widget? floatingWidget;
  final Widget? actionWidget;
  final Widget? titleWidget;

  BaseScaffold({
    this.title = '',
    required this.child,
    hasAppbar = true,
    this.hasFloating = false,
    this.hasActionButton = false,
    this.hasTextTitle = true,
    this.floatingWidget,
    this.actionWidget,
    this.titleWidget,
  }) : this.hasAppbar = hasActionButton ? hasActionButton : hasAppbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppbar
          ? AppBar(
              title: hasTextTitle ? Text('$title') : titleWidget,
              actions: hasActionButton ? [actionWidget!] : [],
            )
          : null,
      body: child,
      floatingActionButton: hasFloating ? floatingWidget : null,
    );
  }
}
