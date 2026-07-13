import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/app.dart';
import 'package:lumina/features/home/application/home_providers.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWith((ref) => []),
          featuredCollectionsProvider.overrideWith((ref) => []),
          trendingGemstonesProvider.overrideWith((ref) => []),
        ],
        child: const LuminaApp(),
      ),
    );

    // Rebuild and let animation timers complete
    await tester.pump(const Duration(seconds: 1));

    // Verify the app bar title renders
    expect(find.text('LUMINA GEMS'), findsOneWidget);
  });
}
