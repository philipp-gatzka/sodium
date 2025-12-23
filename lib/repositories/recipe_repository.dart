import 'package:isar/isar.dart';

import '../models/recipe.dart';
import '../models/sort_option.dart';

/// Repository for managing Recipe data in the Isar database.
class RecipeRepository {
  final Isar _isar;

  RecipeRepository(this._isar);

  /// Adds a new recipe to the database.
  ///
  /// Sets the [createdAt] and [updatedAt] timestamps to the current time.
  /// Returns the saved recipe with its generated ID.
  Future<Recipe> addRecipe(Recipe recipe) async {
    final now = DateTime.now();
    recipe.createdAt = now;
    recipe.updatedAt = now;

    await _isar.writeTxn(() async {
      await _isar.recipes.put(recipe);
    });

    return recipe;
  }

  /// Retrieves all recipes from the database.
  ///
  /// Returns recipes sorted by [createdAt] descending (newest first).
  /// Returns an empty list if no recipes exist.
  Future<List<Recipe>> getAllRecipes() async {
    return await _isar.recipes.where().sortByCreatedAtDesc().findAll();
  }

  /// Retrieves all recipes from the database with specified sorting.
  ///
  /// The [sortOption] determines the order of the returned recipes.
  /// Returns an empty list if no recipes exist.
  Future<List<Recipe>> getAllRecipesSorted(RecipeSortOption sortOption) async {
    switch (sortOption) {
      case RecipeSortOption.newestFirst:
        return await _isar.recipes.where().sortByCreatedAtDesc().findAll();
      case RecipeSortOption.oldestFirst:
        return await _isar.recipes.where().sortByCreatedAt().findAll();
      case RecipeSortOption.titleAZ:
        return await _isar.recipes.where().sortByTitle().findAll();
      case RecipeSortOption.titleZA:
        return await _isar.recipes.where().sortByTitleDesc().findAll();
      case RecipeSortOption.quickestFirst:
        // Get all recipes and sort in memory since totalTime is computed
        final recipes = await _isar.recipes.where().findAll();
        recipes.sort((a, b) {
          final aTime = a.totalTimeMinutes ?? double.maxFinite.toInt();
          final bTime = b.totalTimeMinutes ?? double.maxFinite.toInt();
          return aTime.compareTo(bTime);
        });
        return recipes;
      case RecipeSortOption.favoritesFirst:
        // Sort favorites first, then by date
        final recipes = await _isar.recipes.where().findAll();
        recipes.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          // Both same favorite status, sort by date descending
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
        return recipes;
    }
  }

  /// Retrieves a single recipe by its unique ID.
  ///
  /// Returns null if no recipe with the given [id] exists.
  Future<Recipe?> getRecipeById(int id) async {
    return await _isar.recipes.get(id);
  }

  /// Updates an existing recipe in the database.
  ///
  /// Updates the [updatedAt] timestamp to the current time while preserving
  /// the original [createdAt] timestamp. Returns the updated recipe.
  Future<Recipe> updateRecipe(Recipe recipe) async {
    recipe.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.recipes.put(recipe);
    });

    return recipe;
  }

  /// Deletes a recipe from the database by its ID.
  ///
  /// Returns true if the recipe was deleted, false if it didn't exist.
  Future<bool> deleteRecipe(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.recipes.delete(id);
    });
  }

  /// Searches for recipes where the title contains the query.
  ///
  /// The search is case-insensitive. Returns all recipes if query is empty.
  /// Results are sorted by [createdAt] descending (newest first).
  Future<List<Recipe>> searchRecipes(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return getAllRecipes();
    }

    return await _isar.recipes
        .filter()
        .titleContains(trimmedQuery, caseSensitive: false)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Retrieves all favorite recipes.
  ///
  /// Returns recipes where [isFavorite] is true, sorted by [createdAt] descending.
  Future<List<Recipe>> getFavoriteRecipes() async {
    return await _isar.recipes
        .filter()
        .isFavoriteEqualTo(true)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Toggles the favorite status of a recipe.
  ///
  /// Returns the updated recipe with the new favorite status.
  Future<Recipe> toggleFavorite(int id) async {
    final recipe = await _isar.recipes.get(id);
    if (recipe == null) {
      throw StateError('Recipe with id $id not found');
    }

    recipe.isFavorite = !recipe.isFavorite;
    recipe.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.recipes.put(recipe);
    });

    return recipe;
  }

  /// Retrieves all recipes in a specific category.
  ///
  /// The category match is case-insensitive.
  /// Results are sorted by [createdAt] descending.
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final trimmedCategory = category.trim().toLowerCase();
    if (trimmedCategory.isEmpty) {
      return getAllRecipes();
    }

    return await _isar.recipes
        .filter()
        .categoriesElementContains(trimmedCategory, caseSensitive: false)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Retrieves all unique categories used across all recipes.
  ///
  /// Returns a sorted list of unique category names.
  Future<List<String>> getAllCategories() async {
    final recipes = await _isar.recipes.where().findAll();
    final categories = <String>{};

    for (final recipe in recipes) {
      categories.addAll(recipe.categories);
    }

    final sortedCategories = categories.toList()..sort();
    return sortedCategories;
  }

  /// Counts the total number of recipes.
  Future<int> getRecipeCount() async {
    return await _isar.recipes.count();
  }

  /// Counts the number of favorite recipes.
  Future<int> getFavoriteCount() async {
    return await _isar.recipes.filter().isFavoriteEqualTo(true).count();
  }
}
