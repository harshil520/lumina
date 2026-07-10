import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/app.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LuminaApp(),
      ),
    );

    // Verify the app bar title renders
    expect(find.text('LUMINA GEMS'), findsOneWidget);
  });
}
