import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/models/sort_option.dart';
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
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) {
              return Future.value(<Recipe>[]);
            }),
            sortedRecipesProvider.overrideWith((ref) {
              return Future.value(<Recipe>[]);
            }),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('should display empty state when no recipes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async => recipes),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async {
              throw Exception('Test error');
            }),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Failed to load recipes. Please try again.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
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
            sortedRecipesProvider.overrideWith((ref) async => recipes),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
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
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('New Recipe'), findsOneWidget);
    });

    testWidgets('should have sort button in app bar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            sortOptionProvider
                .overrideWith((ref) => RecipeSortOption.newestFirst),
            allCategoriesProvider.overrideWith((ref) async => <String>[]),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    group('Favorites filter', () {
      testWidgets('should display favorites toggle button in app bar',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortOptionProvider
                  .overrideWith((ref) => RecipeSortOption.newestFirst),
              allCategoriesProvider.overrideWith((ref) async => <String>[]),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      });

      testWidgets('should toggle favorites filter when button is tapped',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortOptionProvider
                  .overrideWith((ref) => RecipeSortOption.newestFirst),
              allCategoriesProvider.overrideWith((ref) async => <String>[]),
              favoriteRecipesProvider.overrideWith((ref) async => <Recipe>[]),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final appBarFavoriteBorderButton = find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.favorite_border),
        );
        expect(appBarFavoriteBorderButton, findsOneWidget);

        await tester.tap(appBarFavoriteBorderButton);
        await tester.pumpAndSettle();

        final appBarFavoriteButton = find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.favorite),
        );
        expect(appBarFavoriteButton, findsOneWidget);

        final appBarFavoriteBorderButtonAfter = find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.favorite_border),
        );
        expect(appBarFavoriteBorderButtonAfter, findsNothing);
      });

      testWidgets('should display empty state for favorites when no favorites',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortOptionProvider
                  .overrideWith((ref) => RecipeSortOption.newestFirst),
              allCategoriesProvider.overrideWith((ref) async => <String>[]),
              favoriteRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              showFavoritesOnlyProvider.overrideWith((ref) => true),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(EmptyState), findsOneWidget);
        expect(find.text('No favorites yet'), findsOneWidget);
        expect(
          find.text('Tap the heart icon on a recipe to add it to favorites'),
          findsOneWidget,
        );
      });

      testWidgets('should display favorite recipes when filter is on',
          (tester) async {
        final favoriteRecipes = [
          Recipe()
            ..id = 1
            ..title = 'Favorite Recipe'
            ..ingredients = ['ingredient']
            ..instructions = ['step']
            ..isFavorite = true,
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortOptionProvider
                  .overrideWith((ref) => RecipeSortOption.newestFirst),
              allCategoriesProvider.overrideWith((ref) async => <String>[]),
              favoriteRecipesProvider
                  .overrideWith((ref) async => favoriteRecipes),
              showFavoritesOnlyProvider.overrideWith((ref) => true),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(RecipeCard), findsOneWidget);
        expect(find.text('Favorite Recipe'), findsOneWidget);
      });

      testWidgets('favorites button should have correct tooltip when off',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortOptionProvider
                  .overrideWith((ref) => RecipeSortOption.newestFirst),
              allCategoriesProvider.overrideWith((ref) async => <String>[]),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final iconButton = find.ancestor(
          of: find.byIcon(Icons.favorite_border),
          matching: find.byType(IconButton),
        );

        expect(iconButton, findsOneWidget);
        final widget = tester.widget<IconButton>(iconButton);
        expect(widget.tooltip, 'Show favorites only');
      });

      testWidgets('favorites button should have correct tooltip when on',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortedRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              sortOptionProvider
                  .overrideWith((ref) => RecipeSortOption.newestFirst),
              allCategoriesProvider.overrideWith((ref) async => <String>[]),
              favoriteRecipesProvider.overrideWith((ref) async => <Recipe>[]),
              showFavoritesOnlyProvider.overrideWith((ref) => true),
            ],
            child: const MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final iconButton = find.ancestor(
          of: find.byIcon(Icons.favorite),
          matching: find.byType(IconButton),
        );

        expect(iconButton, findsOneWidget);
        final widget = tester.widget<IconButton>(iconButton);
        expect(widget.tooltip, 'Show all recipes');
      });
    });
  });
}
