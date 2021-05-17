import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/widgets/page_structures/basescaffold.dart';

Widget pageStructure(Widget child) {
  return MaterialApp(home: child);
}

void main() {
  group('basescaffold tests', () {
    var widget;
    final title = 'testScaff';
    final testChild = Container();
    setUp(() {
      widget = BaseScaffold(title: title, child: testChild);
    });

    testWidgets('test creation', (WidgetTester tester) async {
      await tester.pumpWidget(pageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('test title in page', (WidgetTester tester) async {
      await tester.pumpWidget(pageStructure(widget));
      expect(find.text(title), findsOneWidget);
    });
    testWidgets('test child in page', (WidgetTester tester) async {
      await tester.pumpWidget(pageStructure(widget));
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
