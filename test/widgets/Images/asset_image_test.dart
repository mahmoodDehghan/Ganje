import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/widgets/Images/asset_image.dart';

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
  group('asset image widget tests', () {
    final imageAddress = 'assets/images/gsafe.png';
    testWidgets('creation test', (WidgetTester tester) async {
      final widget = ImageViewFromAsset(imageAddress);
      await tester.pumpWidget(widgetStructure(widget));
      expect(find.byWidget(widget), findsOneWidget);
    });
    testWidgets('image with squaresize', (WidgetTester tester) async {
      final widget = ImageViewFromAsset.squreSize(
        imageAddress: imageAddress,
        size: 70,
      );
      await tester.pumpWidget(widgetStructure(widget));
      expect(widget.height, 70);
    });
    testWidgets('image with custom Boxfit', (WidgetTester tester) async {
      final widget = ImageViewFromAsset.withCustomFit(
          imageAddress: imageAddress, height: 50, width: 100, fit: BoxFit.fill);
      await tester.pumpWidget(widgetStructure(widget));
      expect(widget.fit, BoxFit.fill);
    });
  });
}
