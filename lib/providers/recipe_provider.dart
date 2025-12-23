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
