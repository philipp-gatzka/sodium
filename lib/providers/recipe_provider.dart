import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
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

/// Provider that fetches and manages the list of all recipes.
///
/// Returns recipes sorted by creation date (newest first).
/// Automatically refreshes when invalidated.
final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getAllRecipes();
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
