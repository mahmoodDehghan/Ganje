import 'package:flutter_test/flutter_test.dart';
import '../widgettesthelper.dart' as helper;
import '../../../lib/widgets/customtextfields/pincode.dart';

void main() {
  group('pincode widget tests', () {
    var widget;
    setUp(() {
      widget = PinCode(
          pinCount: 4,
          pinHeight: 50,
          pinWidth: 50,
          pin: '',
          isCircle: false,
          isSquare: false,
          pinBoarderRadius: 10);
    });
    testWidgets('creation test', (WidgetTester tester) async {
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
      expect(widget.pinCount, 4);
      expect(widget.pinHeight, 50);
      expect(widget.pinWidth, 50);
      expect(widget.isCircle, isFalse);
      expect(widget.isSquare, isFalse);
      expect(widget.pinBoarderRadius, 10);
    });
    testWidgets('square creation test', (WidgetTester tester) async {
      final widget = PinCode.squarePins(
          pinCount: 4, size: 40, pin: '', pinBoarderRadius: 8);
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
      expect(widget.pinCount, 4);
      expect(widget.pinHeight, 40);
      expect(widget.pinWidth, 40);
      expect(widget.isCircle, isFalse);
      expect(widget.isSquare, isTrue);
      expect(widget.pinBoarderRadius, 8);
    });
    testWidgets('circle creation test', (WidgetTester tester) async {
      final widget = PinCode.circlePins(pinCount: 4, pin: '', size: 40);
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
      expect(widget.pinCount, 4);
      expect(widget.pinHeight, 40);
      expect(widget.pinWidth, 40);
      expect(widget.isCircle, isTrue);
      expect(widget.isSquare, isFalse);
      expect(widget.pinBoarderRadius, 16);
    });
    testWidgets('set pin test', (WidgetTester tester) async {
      final widget = PinCode.circlePins(pinCount: 4, pin: '12', size: 40);
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(widget.controllers[0].text, '1');
      expect(widget.controllers[1].text, '2');
    });
  });
}
