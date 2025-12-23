import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/providers/recipe_provider.dart';
import 'package:sodium/screens/home_screen.dart';
import 'package:sodium/widgets/empty_state.dart';
import 'package:sodium/widgets/loading_widget.dart';
import 'package:sodium/widgets/recipe_card.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Recipes'), findsOneWidget);
    });

    testWidgets('should have a Scaffold', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have an AppBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display loading indicator initially', (tester) async {
      // Use a Completer to control when the future completes
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) {
              // Return a future that resolves immediately but we check before settle
              return Future.value(<Recipe>[]);
            }),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Initial pump shows loading state before async completes
      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Now let it settle to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should display empty state when no recipes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No recipes yet'), findsOneWidget);
      expect(find.text('Tap + to add your first recipe'), findsOneWidget);
    });

    testWidgets('should display recipe cards when recipes exist',
        (tester) async {
      final recipes = [
        Recipe()
          ..id = 1
          ..title = 'Recipe 1'
          ..ingredients = ['ingredient']
          ..instructions = ['step'],
        Recipe()
          ..id = 2
          ..title = 'Recipe 2'
          ..ingredients = ['ingredient']
          ..instructions = ['step'],
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => recipes),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RecipeCard), findsNWidgets(2));
      expect(find.text('Recipe 1'), findsOneWidget);
      expect(find.text('Recipe 2'), findsOneWidget);
    });

    testWidgets('should display error message on error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async {
              throw Exception('Test error');
            }),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display user-friendly error message
      expect(find.text('Failed to load recipes. Please try again.'),
          findsOneWidget);
      // Should have retry button
      expect(find.text('Retry'), findsOneWidget);
      // Should show error icon
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should have ListView when recipes exist', (tester) async {
      final recipes = [
        Recipe()
          ..id = 1
          ..title = 'Recipe 1'
          ..ingredients = []
          ..instructions = [],
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => recipes),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should have a FloatingActionButton', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('FAB should have add icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('FAB should navigate to create screen when tapped',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // FAB should be tappable
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Should navigate to create screen (RecipeEditScreen in create mode)
      expect(find.text('New Recipe'), findsOneWidget);
    });
  });
}
