import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/providers/recipe_provider.dart';
import 'package:sodium/screens/recipe_detail_screen.dart';
import 'package:sodium/widgets/loading_widget.dart';

void main() {
  group('RecipeDetailScreen', () {
    group('Loading state', () {
      testWidgets('should display LoadingWidget while loading', (tester) async {
        // Use a Completer that never completes to keep loading state
        final completer = Completer<Recipe?>();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) => completer.future),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        expect(find.byType(LoadingWidget), findsOneWidget);
      });

      testWidgets('should display "Loading..." in AppBar while loading',
          (tester) async {
        final completer = Completer<Recipe?>();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) => completer.future),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        expect(find.text('Loading...'), findsOneWidget);
      });
    });

    group('Error state', () {
      testWidgets('should display error message on error', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                throw Exception('Database error');
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Failed to load recipe'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should display "Error" in AppBar on error', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                throw Exception('Database error');
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Error'), findsOneWidget);
      });
    });

    group('Recipe not found', () {
      testWidgets('should display not found message when recipe is null',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async => null),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Recipe not found'), findsOneWidget);
        expect(find.text('The recipe you are looking for does not exist.'),
            findsOneWidget);
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });

      testWidgets('should display "Not Found" in AppBar when recipe is null',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async => null),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Not Found'), findsOneWidget);
      });
    });

    group('Recipe display', () {
      Recipe createTestRecipe() {
        return Recipe()
          ..id = 1
          ..title = 'Chocolate Cake'
          ..ingredients = ['2 cups flour', '1 cup sugar', '3 eggs']
          ..instructions = [
            'Preheat oven to 350°F',
            'Mix dry ingredients',
            'Bake for 30 minutes'
          ];
      }

      testWidgets('should display recipe title in AppBar', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Chocolate Cake'), findsOneWidget);
      });

      testWidgets('should display Ingredients section header', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Ingredients'), findsOneWidget);
      });

      testWidgets('should display ingredients as bullet list', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('2 cups flour'), findsOneWidget);
        expect(find.text('1 cup sugar'), findsOneWidget);
        expect(find.text('3 eggs'), findsOneWidget);
        // Bullet points
        expect(find.text('•  '), findsNWidgets(3));
      });

      testWidgets('should display Instructions section header', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Instructions'), findsOneWidget);
      });

      testWidgets('should display instructions as numbered list',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Preheat oven to 350°F'), findsOneWidget);
        expect(find.text('Mix dry ingredients'), findsOneWidget);
        expect(find.text('Bake for 30 minutes'), findsOneWidget);
        // Step numbers
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('should display step numbers in circles', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find containers with circle shape
        final circleContainers = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration != null) {
            final decoration = widget.decoration as BoxDecoration?;
            return decoration?.shape == BoxShape.circle;
          }
          return false;
        });

        expect(circleContainers, findsNWidgets(3));
      });

      testWidgets('should have scrollable body', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return createTestRecipe();
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Empty lists', () {
      testWidgets('should display message when no ingredients', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Empty Recipe'
                  ..ingredients = []
                  ..instructions = ['Step 1'];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('No ingredients added'), findsOneWidget);
      });

      testWidgets('should display message when no instructions',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Empty Recipe'
                  ..ingredients = ['Flour']
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('No instructions added'), findsOneWidget);
      });
    });

    group('Navigation', () {
      testWidgets('should have back button in AppBar', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RecipeDetailScreen(recipeId: 1),
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

        // Navigate to detail screen
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Should have back button
        expect(find.byType(BackButton), findsOneWidget);
      });

      testWidgets('should support back navigation', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RecipeDetailScreen(recipeId: 1),
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

        // Navigate to detail screen
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test Recipe'), findsOneWidget);

        // Tap back button
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Should be back on original screen
        expect(find.text('Open'), findsOneWidget);
      });
    });

    group('Edit button', () {
      testWidgets('should display edit button in AppBar', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets('should have edit button with tooltip', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final editButton = find.byIcon(Icons.edit);
        expect(editButton, findsOneWidget);

        final iconButton =
            tester.widget<IconButton>(find.byType(IconButton).first);
        expect(iconButton.tooltip, 'Edit recipe');
      });

      // Navigation to RecipeEditScreen requires database setup because
      // RecipeEditScreen loads recipe data from Isar. This test is covered
      // in integration tests where the full database is available.
      testWidgets('should have edit button that is tappable', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify edit button exists and is an IconButton
        final editButton = find.byIcon(Icons.edit);
        expect(editButton, findsOneWidget);

        final iconButton = tester.widget<IconButton>(
          find.ancestor(
            of: editButton,
            matching: find.byType(IconButton),
          ),
        );
        expect(iconButton.onPressed, isNotNull);
      });

      testWidgets('should not display edit button in loading state',
          (tester) async {
        final completer = Completer<Recipe?>();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) => completer.future),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        // In loading state, edit button should not be visible
        expect(find.byIcon(Icons.edit), findsNothing);
      });

      testWidgets('should not display edit button in error state',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                throw Exception('Error');
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // In error state, edit button should not be visible
        expect(find.byIcon(Icons.edit), findsNothing);
      });

      testWidgets('should not display edit button when recipe not found',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async => null),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // When recipe not found, edit button should not be visible
        expect(find.byIcon(Icons.edit), findsNothing);
      });
    });

    group('Delete button', () {
      testWidgets('should display delete button in AppBar', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('should have delete button with tooltip', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final deleteButton = find.byIcon(Icons.delete);
        expect(deleteButton, findsOneWidget);

        // Find the IconButton that contains the delete icon
        final iconButtons = find.byType(IconButton);
        final deleteIconButton = tester.widget<IconButton>(iconButtons.at(1));
        expect(deleteIconButton.tooltip, 'Delete recipe');
      });

      testWidgets('should show confirmation dialog when tapped',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap delete button
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Should show confirmation dialog
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Delete this recipe?'), findsOneWidget);
        expect(find.text('This action cannot be undone.'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('should dismiss dialog when Cancel is tapped',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = [];
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap delete button to show dialog
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Tap Cancel
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Dialog should be dismissed, still on detail screen
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Test Recipe'), findsOneWidget);
      });

      testWidgets('should not display delete button in loading state',
          (tester) async {
        final completer = Completer<Recipe?>();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) => completer.future),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        // In loading state, delete button should not be visible
        expect(find.byIcon(Icons.delete), findsNothing);
      });

      testWidgets('should not display delete button in error state',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                throw Exception('Error');
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // In error state, delete button should not be visible
        expect(find.byIcon(Icons.delete), findsNothing);
      });

      testWidgets('should not display delete button when recipe not found',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async => null),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // When recipe not found, delete button should not be visible
        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });

    testWidgets('should have Scaffold', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipeByIdProvider(1).overrideWith((ref) async {
              return Recipe()
                ..id = 1
                ..title = 'Test'
                ..ingredients = []
                ..instructions = [];
            }),
          ],
          child: const MaterialApp(
            home: RecipeDetailScreen(recipeId: 1),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have AppBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipeByIdProvider(1).overrideWith((ref) async {
              return Recipe()
                ..id = 1
                ..title = 'Test'
                ..ingredients = []
                ..instructions = [];
            }),
          ],
          child: const MaterialApp(
            home: RecipeDetailScreen(recipeId: 1),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
