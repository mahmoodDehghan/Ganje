import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../lib/ganje_app.dart';

void main() {
  group('ganje app widget tests', () {
    testWidgets('creation test', (tester) async {
      var widget = ProviderScope(
        child: GanjeApp(),
      );
      await tester.pumpWidget(widget);
      expect(find.byWidget(widget), findsOneWidget);
    });
  });
}
