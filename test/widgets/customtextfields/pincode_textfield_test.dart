import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import '../widgettesthelper.dart' as helper;
import '../../../lib/widgets/customtextfields/pincode_textfield.dart';

void main() {
  group('pincode_textfield tests', () {
    var widget;
    var key = ValueKey('value');
    setUp(() {
      widget = PinTextField(
        height: 10,
        width: 10,
        borderRadius: 2,
        textFieldkey: key,
      );
    });
    testWidgets('creation test', (WidgetTester tester) async {
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('constructor test', (WidgetTester tester) async {
      final testEntry = 'testEntry';
      await tester.pumpWidget(helper.getPageStructure(widget));
      await tester.enterText(find.byWidget(widget), testEntry);
      await tester.pump();
      expect(find.text(testEntry), findsOneWidget);
      expect(widget.height, 10);
      expect(widget.width, 10);
      expect(widget.borderRadius, 2);
      expect(widget.controller.text, testEntry);
      expect(widget.textFieldkey, key);
    });
    testWidgets('square constructor test', (WidgetTester tester) async {
      final widget = PinTextField.squareSize(
        size: 12,
        borderRadius: 5,
        textFieldkey: key,
      );
      final testEntry = 'testEntry';
      await tester.pumpWidget(helper.getPageStructure(widget));
      await tester.enterText(find.byWidget(widget), testEntry);
      expect(find.text(testEntry), findsOneWidget);
      expect(widget.height, 12);
      expect(widget.width, 12);
      expect(widget.borderRadius, 5);
      expect(widget.controller.text, testEntry);
      expect(widget.textFieldkey, key);
    });
    testWidgets('circle constructor test', (WidgetTester tester) async {
      final widget = PinTextField.circle(
        size: 20,
        textFieldkey: key,
      );
      final testEntry = 'testEntry';
      await tester.pumpWidget(helper.getPageStructure(widget));
      await tester.enterText(find.byWidget(widget), testEntry);
      expect(find.text(testEntry), findsOneWidget);
      expect(widget.height, 20);
      expect(widget.width, 20);
      expect(widget.borderRadius, 8);
      expect(widget.controller.text, testEntry);
      expect(widget.textFieldkey, key);
    });
  });
}
