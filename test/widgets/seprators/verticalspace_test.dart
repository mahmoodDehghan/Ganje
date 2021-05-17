import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/widgets/Seprators/vertical_space.dart';

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
  group('vertical space widget tests', () {
    testWidgets('creation test', (WidgetTester tester) async {
      final widget = VerticalSpace();
      await tester.pumpWidget(widgetStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('creation with custom space test', (WidgetTester tester) async {
      final double size = 20;
      final widget = VerticalSpace.withSpace(size);
      await tester.pumpWidget(widgetStructure(widget));
      expect(widget.space, size);
    });
  });
}
