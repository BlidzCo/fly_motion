import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fly_motion/fly_motion.dart';

void main() {
  group('FlyMotion', () {
    testWidgets('launchFromKeys throws exception when origin key not found',
        (WidgetTester tester) async {
      final destinationKey = GlobalKey();

      await tester.pumpWidget(
        FlyMotionOverlaySupport(
          child: MaterialApp(
            home: Scaffold(
              body: Container(key: destinationKey),
            ),
          ),
        ),
      );

      expect(
        () => FlyMotion.launchFromKeys(
          originKey: GlobalKey(),
          destinationKey: destinationKey,
          widget: (_) => const FlutterLogo(),
        ),
        throwsA(isA<FlyMotionException>().having(
          (e) => e.message,
          'message',
          'Origin key not found',
        )),
      );
    });

    testWidgets(
        'launchFromKeys throws exception when destination key not found',
        (WidgetTester tester) async {
      final originKey = GlobalKey();

      await tester.pumpWidget(
        FlyMotionOverlaySupport(
          child: MaterialApp(
            home: Scaffold(
              body: Container(key: originKey),
            ),
          ),
        ),
      );

      expect(
        () => FlyMotion.launchFromKeys(
          originKey: originKey,
          destinationKey: GlobalKey(),
          widget: (_) => const FlutterLogo(),
        ),
        throwsA(isA<FlyMotionException>().having(
          (e) => e.message,
          'message',
          'Destination key not found',
        )),
      );
    });
  });
}
