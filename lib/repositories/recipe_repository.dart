import 'package:isar/isar.dart';

import '../models/recipe.dart';

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
}
