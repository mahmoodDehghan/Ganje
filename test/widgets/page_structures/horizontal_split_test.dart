import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import '../widgettesthelper.dart' as helper;
import '../../../lib/widgets/page_structures/horizontal_page_split.dart';

void main() {
  group('horizontal split tests', () {
    testWidgets('creation test', (WidgetTester tester) async {
      var widget = HorizontalSplitSection(
        leftSection: SizedBox(),
        rightSection: SizedBox(),
        leftFlex: 1,
        rightFlex: 1,
      );
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
      expect(find.byType(SizedBox), findsNWidgets(2));
    });
    testWidgets('creation half split test', (WidgetTester tester) async {
      var widget = HorizontalSplitSection(
        leftSection: SizedBox(),
        rightSection: SizedBox(),
        leftFlex: 1,
        rightFlex: 1,
      );
      await tester.pumpWidget(helper.getPageStructure(widget));
      expect(find.byType(SizedBox), findsNWidgets(2));
      expect(widget.leftFlex, 1);
      expect(widget.rightFlex, 1);
    });
  });
}
