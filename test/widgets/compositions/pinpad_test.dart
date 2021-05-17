import 'package:flutter_test/flutter_test.dart';
import '../../../lib/widgets/compositions/pin_pad.dart';
import '../widgettesthelper.dart' as helper;

void main() {
  group('pinpad tests', () {
    testWidgets('creation test', (WidgetTester tester) async {
      final widget = PinPad(onButtonClick: (_) => {});
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('default constructor fields initialization test',
        (WidgetTester tester) async {
      final widget = PinPad(onButtonClick: (_) => {});
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(widget.buttonSize, 40);
      expect(widget.pinPadding, 5);
      expect(widget.pinRadius, 10);
      expect(widget.verticalSpace, 15);
    });
    testWidgets('custom constructor fields initialization test',
        (WidgetTester tester) async {
      final widget = PinPad.custom(
        onButtonClick: (_) => {},
        buttonSize: 50,
      );
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(widget.buttonSize, 50);
      expect(widget.pinPadding, 5);
      expect(widget.pinRadius, 10);
      expect(widget.verticalSpace, 15);
    });
    // testWidgets('enter pin test', (WidgetTester tester) async {
    //   final widget = PinPad(onButtonClick: (String s) { tester.},);
    //   await tester.pumpWidget(helper.getPageStructure(widget));
    //   await tester.tap(find.widgetWithText(RippleButton, '1'));
    //   await tester.pump();
    //   await tester.tap(find.widgetWithText(RippleButton, '2'));
    //   await tester.pump();
    //   await tester.tap(find.widgetWithText(RippleButton, '3'));
    //   await tester.pump();
    //   await tester.tap(find.widgetWithText(RippleButton, '4'));
    //   await tester.pump();
    //   expect(find.widgetWithText(TextField, '1'), findsOneWidget);
    //   expect(find.widgetWithText(TextField, '2'), findsOneWidget);
    //   expect(find.widgetWithText(TextField, '3'), findsOneWidget);
    //   expect(find.widgetWithText(TextField, '4'), findsOneWidget);
    // });
  });
}
