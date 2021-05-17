import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/widgets/Buttons/simplebutton.dart';

void main() {
  group('simple button widget tests', () {
    testWidgets('test simple button creation', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: SimpleButton(onPressed: () {}, label: 'test'),
      );
      await tester.pumpWidget(widget);

      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('label button shows test', (WidgetTester tester) async {
      final label = 'test';
      final widget = MaterialApp(
        home: SimpleButton(onPressed: () {}, label: label),
      );
      await tester.pumpWidget(widget);

      expect(find.text(label), findsOneWidget);
    });
    testWidgets('button press function test', (WidgetTester tester) async {
      var label = 'test';
      final buttonPressedText = 'button Pressed!';
      final widget = MaterialApp(
        home: Column(
          children: [
            SimpleButton(
                onPressed: () {
                  label = buttonPressedText;
                },
                label: label),
          ],
        ),
      );
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(SimpleButton));
      await tester.pump();
      expect(label, buttonPressedText);
    });
  });
}
