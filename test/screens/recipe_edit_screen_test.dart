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

    group('Title input field', () {
      testWidgets('should have a title text field', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RecipeEditScreen(),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
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

        await tester.enterText(find.byType(TextFormField), 'My Recipe');
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
        await tester.enterText(find.byType(TextFormField), 'Valid Title');
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
