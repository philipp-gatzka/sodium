import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/recipe.dart';

/// Service for exporting and importing recipes.
///
/// Handles converting recipes to JSON format and sharing via system share sheet.
class ExportService {
  /// Export format version for backwards compatibility.
  static const String exportVersion = '1.0.0';

  /// Exports a list of recipes to JSON format.
  ///
  /// Returns a Map containing the export data with version info and recipes.
  Map<String, dynamic> exportToJson(List<Recipe> recipes) {
    return {
      'version': exportVersion,
      'exportDate': DateTime.now().toUtc().toIso8601String(),
      'recipeCount': recipes.length,
      'recipes': recipes.map((recipe) => _recipeToJson(recipe)).toList(),
    };
  }

  /// Converts a single recipe to a JSON-compatible map.
  Map<String, dynamic> _recipeToJson(Recipe recipe) {
    return {
      'title': recipe.title,
      'description': recipe.description,
      'ingredients': recipe.ingredients,
      'instructions': recipe.instructions,
      'prepTimeMinutes': recipe.prepTimeMinutes,
      'cookTimeMinutes': recipe.cookTimeMinutes,
      'servings': recipe.servings,
      'difficulty': recipe.difficulty?.name,
      'categories': recipe.categories,
      'isFavorite': recipe.isFavorite,
      'createdAt': recipe.createdAt?.toUtc().toIso8601String(),
      'updatedAt': recipe.updatedAt?.toUtc().toIso8601String(),
    };
  }

  /// Exports recipes to a JSON file and returns the file.
  ///
  /// The file is saved to the app's temporary directory.
  Future<File> exportToFile(List<Recipe> recipes) async {
    final jsonData = exportToJson(recipes);
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/sodium_recipes_$timestamp.json');

    await file.writeAsString(jsonString);
    return file;
  }

  /// Exports recipes and opens the system share sheet.
  ///
  /// Returns the share result.
  Future<ShareResult> shareRecipes(List<Recipe> recipes) async {
    final file = await exportToFile(recipes);

    final result = await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'My Sodium Recipes',
      text: 'Here are my ${recipes.length} recipe(s) from Sodium.',
    );

    return result;
  }

  /// Generates a formatted JSON string from recipes.
  ///
  /// Useful for previewing the export without creating a file.
  String exportToJsonString(List<Recipe> recipes) {
    final jsonData = exportToJson(recipes);
    return const JsonEncoder.withIndent('  ').convert(jsonData);
  }
}
