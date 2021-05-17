import 'package:flutter_test/flutter_test.dart';
import '../widgettesthelper.dart';
import '../../../lib/widgets/Buttons/ripplebutton.dart';

void main() {
  group('ripple button tests', () {
    testWidgets('creation test', (WidgetTester tester) async {
      final widget = RippleButton(
        height: 45,
        width: 45,
        cornerRadius: 15,
        elevation: 2,
        label: 'test',
        onClick: () {},
      );
      await tester.pumpWidget(getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('default constructor test', (WidgetTester tester) async {
      final widget = RippleButton(
        height: 45,
        width: 45,
        cornerRadius: 15,
        elevation: 2,
        label: 'test',
        onClick: () {},
      );
      await tester.pumpWidget(getPageStructure(widget));
      expect(find.text('test'), findsOneWidget);
      expect(widget.height, 45);
      expect(widget.width, 45);
      expect(widget.cornerRadius, 15);
      expect(widget.elevation, 2);
    });
    testWidgets('onclick function test', (WidgetTester tester) async {
      var testVar = 0;
      final widget = RippleButton(
        height: 45,
        width: 45,
        cornerRadius: 15,
        elevation: 2,
        label: 'test',
        onClick: () {
          testVar = 1;
        },
      );
      await tester.pumpWidget(getPageStructure(widget));
      await tester.tap(find.byWidget(widget));
      await tester.pump();
      expect(testVar, 1);
    });
    testWidgets('square constructor test', (WidgetTester tester) async {
      final widget = RippleButton.squareSize(
        size: 45,
        cornerRadius: 15,
        elevation: 2,
        label: 'test',
        onClick: () {},
      );
      await tester.pumpWidget(getPageStructure(widget));
      expect(find.text('test'), findsOneWidget);
      expect(widget.height, 45);
      expect(widget.width, 45);
    });
    testWidgets('circle constructor test', (WidgetTester tester) async {
      final widget = RippleButton.circleShape(
        size: 40,
        elevation: 2,
        label: 'test',
        onClick: () {},
      );
      await tester.pumpWidget(getPageStructure(widget));
      expect(find.text('test'), findsOneWidget);
      expect(widget.height, 40);
      expect(widget.width, 40);
      expect(widget.cornerRadius, 16);
    });
  });
}
