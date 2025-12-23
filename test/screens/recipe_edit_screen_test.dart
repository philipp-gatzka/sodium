import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/screens/recipe_edit_screen.dart';
import 'package:sodium/widgets/ingredients_input.dart';
import 'package:sodium/widgets/instructions_input.dart';

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

    // Note: Edit mode tests with actual database loading are tested in integration tests
    // These tests require a working database which is complex to set up for unit tests

    group('Title input field', () {
      testWidgets('should have a title text field', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.text('Recipe Title'), findsOneWidget);
      });

      testWidgets('should have label text', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.text('Recipe Title'), findsOneWidget);
      });

      testWidgets('should have hint text', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.text('Enter recipe name'), findsOneWidget);
      });

      testWidgets('should accept text input', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        // Find the title text field by its hint text
        final titleField = find.widgetWithText(TextFormField, 'Enter recipe name');
        await tester.enterText(titleField, 'My Recipe');
        await tester.pump();

        expect(find.text('My Recipe'), findsOneWidget);
      });

      testWidgets('should show validation error when empty on save',
          (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        // Tap save without entering title
        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a recipe title'), findsOneWidget);
      });

      testWidgets('should not show error when title is entered',
          (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        // Enter title
        final titleField = find.widgetWithText(TextFormField, 'Enter recipe name');
        await tester.enterText(titleField, 'Valid Title');
        await tester.pump();

        // Tap save
        await tester.tap(find.byIcon(Icons.check));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a recipe title'), findsNothing);
      });

      testWidgets('should have Form widget', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Ingredients input', () {
      testWidgets('should have IngredientsInput widget', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(IngredientsInput), findsOneWidget);
      });

      testWidgets('should display Ingredients label', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.text('Ingredients'), findsOneWidget);
      });
    });

    group('Instructions input', () {
      testWidgets('should have InstructionsInput widget', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(InstructionsInput), findsOneWidget);
      });

      testWidgets('should display Instructions label', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.text('Instructions'), findsOneWidget);
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
