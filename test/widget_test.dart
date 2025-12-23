import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/app.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/providers/recipe_provider.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipesProvider.overrideWith((ref) async => <Recipe>[]),
        ],
        child: const SodiumApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Recipes'), findsOneWidget);
  });
}
