import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/widgets/containers/apptheme.dart';

void main() {
  group('general theme widget tests', () {
    testWidgets('theme container simple child test',
        (WidgetTester tester) async {
      final childWidget = Container();
      final themeWidget = AppTheme(
        themeChild: childWidget,
      );
      await tester.pumpWidget(themeWidget);
      expect(find.byWidget(childWidget), findsOneWidget);
    });
    testWidgets('check default primary color set', (WidgetTester tester) async {
      final testWidget = AppTheme(themeChild: Container());

      // Provide the childWidget to the Container.
      await tester.pumpWidget(testWidget);

      // Search for the childWidget in the tree and verify it exists.
      expect(testWidget.themeData.primaryColor, AppTheme.defPrimarySwatch);
    });
  });
}
