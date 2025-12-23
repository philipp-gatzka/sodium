import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/screens/recipe_edit_screen.dart';

void main() {
  group('RecipeEditScreen', () {
    group('Create mode (no recipeId)', () {
      testWidgets('should display "New Recipe" in AppBar', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.text('New Recipe'), findsOneWidget);
      });

      testWidgets('should have a Scaffold', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should have an AppBar', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should have a save button in AppBar', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('save button should be tappable', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        // Should not throw error
        expect(find.byType(RecipeEditScreen), findsOneWidget);
      });

      testWidgets('should have scrollable body', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Edit mode (with recipeId)', () {
      testWidgets('should display "Edit Recipe" in AppBar', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(recipeId: 1),
            ),
          ),
        );

        expect(find.text('Edit Recipe'), findsOneWidget);
      });

      testWidgets('should have save button in edit mode', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(recipeId: 1),
            ),
          ),
        );

        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });

    testWidgets('should support back navigation', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RecipeEditScreen(),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to RecipeEditScreen
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('New Recipe'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should be back on original screen
      expect(find.text('Open'), findsOneWidget);
    });
  });
}
