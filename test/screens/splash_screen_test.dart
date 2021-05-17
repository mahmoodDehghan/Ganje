import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/widgettesthelper.dart' as structure;
import '../../lib/screens/splash_screen.dart';

void main() {
  group('splash screen widget tests:', () {
    testWidgets('creation test', (tester) async {
      await tester.pumpWidget(
        structure.getPageStructure(SplashScreen()),
        Duration(minutes: 1),
      );
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });
  });
}
