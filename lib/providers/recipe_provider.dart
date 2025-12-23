import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
import '../models/sort_option.dart';
import '../repositories/recipe_repository.dart';
import 'database_provider.dart';

/// Provider that creates and provides the RecipeRepository instance.
///
/// This provider depends on [isarProvider] and creates a repository
/// that can be used for all recipe CRUD operations.
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return RecipeRepository(isar);
});

/// Provider to track the current sort option.
///
/// Defaults to [RecipeSortOption.newestFirst].
final sortOptionProvider =
    StateProvider<RecipeSortOption>((ref) => RecipeSortOption.newestFirst);

/// Provider that fetches and manages the list of all recipes.
///
/// Returns recipes sorted by creation date (newest first).
/// Automatically refreshes when invalidated.
final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getAllRecipes();
});

/// Provider that fetches recipes with the current sort option applied.
///
/// Watches [sortOptionProvider] and returns recipes sorted accordingly.
final sortedRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  final sortOption = ref.watch(sortOptionProvider);
  return repository.getAllRecipesSorted(sortOption);
});

/// Provider that searches for recipes by title.
///
/// Takes a search query as parameter and returns matching recipes.
/// The search is case-insensitive. Returns all recipes for empty query.
/// Results are sorted by creation date (newest first).
final recipeSearchProvider =
    FutureProvider.family<List<Recipe>, String>((ref, query) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.searchRecipes(query);
});

/// Provider that fetches a single recipe by its ID.
///
/// Returns null if the recipe doesn't exist.
final recipeByIdProvider = FutureProvider.family<Recipe?, int>((ref, id) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getRecipeById(id);
});

/// Provider that fetches all favorite recipes.
///
/// Returns only recipes where [isFavorite] is true.
/// Results are sorted by creation date (newest first).
final favoriteRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getFavoriteRecipes();
});

/// Provider to track whether the home screen shows only favorites.
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

/// Provider that fetches all unique categories from recipes.
///
/// Returns a sorted list of category names used across all recipes.
final allCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getAllCategories();
});

/// Provider to track the currently selected category filter.
///
/// Null means "All" (no category filter).
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Provider that fetches recipes filtered by category.
///
/// Takes a category name as parameter and returns matching recipes.
/// The match is case-insensitive.
final recipesByCategoryProvider =
    FutureProvider.family<List<Recipe>, String>((ref, category) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getRecipesByCategory(category);
});
