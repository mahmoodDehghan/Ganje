import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/widgets/page_structures/two_part_vertical_page.dart';

Widget widgetStructure(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Container(
        child: child,
      ),
    ),
  );
}

void main() {
  group('two part vertical page tests', () {
    testWidgets('creation test', (WidgetTester tester) async {
      final widget = TwoPartVerticalPage(
        upperPart: Container(),
        lowerPart: Container(),
      );
      await tester.pumpWidget(widgetStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('creation with custo flex test', (WidgetTester tester) async {
      final widget = TwoPartVerticalPage.customFlex(
        upperPart: Container(),
        lowerPart: Container(),
        upFlex: 4,
        lowFlex: 1,
      );
      await tester.pumpWidget(widgetStructure(widget));
      expect(widget.upFlex, 4);
      expect(widget.lowFlex, 1);
    });
  });
}
