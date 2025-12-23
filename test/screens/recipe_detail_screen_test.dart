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

        expect(find.text('Failed to load recipe. Please try again.'),
            findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
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
            'Preheat oven to 350\u00b0F',
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
        expect(find.text('\u2022  '), findsNWidgets(3));
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

        expect(find.text('Preheat oven to 350\u00b0F'), findsOneWidget);
        expect(find.text('Mix dry ingredients'), findsOneWidget);
        expect(find.text('Bake for 30 minutes'), findsOneWidget);
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

    group('Favorite button', () {
      testWidgets('should display favorite button in AppBar', (tester) async {
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

        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      });

      testWidgets('should show filled heart when recipe is favorite',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = []
                  ..isFavorite = true;
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsNothing);
      });

      testWidgets('should show unfilled heart when recipe is not favorite',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = []
                  ..isFavorite = false;
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNothing);
      });

      testWidgets('should have tooltip for non-favorite recipe',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = []
                  ..isFavorite = false;
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final favoriteButton = find.ancestor(
          of: find.byIcon(Icons.favorite_border),
          matching: find.byType(IconButton),
        );

        expect(favoriteButton, findsOneWidget);
        final widget = tester.widget<IconButton>(favoriteButton);
        expect(widget.tooltip, 'Add to favorites');
      });

      testWidgets('should have tooltip for favorite recipe', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = []
                  ..isFavorite = true;
              }),
            ],
            child: const MaterialApp(
              home: RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final favoriteButton = find.ancestor(
          of: find.byIcon(Icons.favorite),
          matching: find.byType(IconButton),
        );

        expect(favoriteButton, findsOneWidget);
        final widget = tester.widget<IconButton>(favoriteButton);
        expect(widget.tooltip, 'Remove from favorites');
      });

      testWidgets('favorite heart should have error color when filled',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipeByIdProvider(1).overrideWith((ref) async {
                return Recipe()
                  ..id = 1
                  ..title = 'Test Recipe'
                  ..ingredients = []
                  ..instructions = []
                  ..isFavorite = true;
              }),
            ],
            child: MaterialApp(
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              ),
              home: const RecipeDetailScreen(recipeId: 1),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.favorite));
        final context = tester.element(find.byType(RecipeDetailScreen));
        final expectedColor = Theme.of(context).colorScheme.error;

        expect(iconWidget.color, equals(expectedColor));
      });

      testWidgets('should not display favorite button in loading state',
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

        expect(find.byIcon(Icons.favorite), findsNothing);
        expect(find.byIcon(Icons.favorite_border), findsNothing);
      });

      testWidgets('should not display favorite button in error state',
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

        expect(find.byIcon(Icons.favorite), findsNothing);
        expect(find.byIcon(Icons.favorite_border), findsNothing);
      });

      testWidgets('should not display favorite button when recipe not found',
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

        expect(find.byIcon(Icons.favorite), findsNothing);
        expect(find.byIcon(Icons.favorite_border), findsNothing);
      });

      testWidgets('favorite button should be tappable', (tester) async {
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

        final favoriteButton = find.ancestor(
          of: find.byIcon(Icons.favorite_border),
          matching: find.byType(IconButton),
        );

        expect(favoriteButton, findsOneWidget);
        final widget = tester.widget<IconButton>(favoriteButton);
        expect(widget.onPressed, isNotNull);
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

        final iconButton = find.ancestor(
          of: editButton,
          matching: find.byType(IconButton),
        );
        final widget = tester.widget<IconButton>(iconButton);
        expect(widget.tooltip, 'Edit recipe');
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

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

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

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Test Recipe'), findsOneWidget);
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
