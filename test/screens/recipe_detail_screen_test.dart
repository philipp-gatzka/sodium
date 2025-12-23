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
