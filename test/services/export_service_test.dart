import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/services/export_service.dart';

void main() {
  group('ExportService', () {
    late ExportService exportService;

    setUp(() {
      exportService = ExportService();
    });

    group('exportToJson', () {
      test('should return valid JSON structure with empty list', () {
        final result = exportService.exportToJson([]);

        expect(result['version'], ExportService.exportVersion);
        expect(result['exportDate'], isNotNull);
        expect(result['recipeCount'], 0);
        expect(result['recipes'], isEmpty);
      });

      test('should include all recipe fields', () {
        final recipe = Recipe()
          ..title = 'Test Recipe'
          ..description = 'A test description'
          ..ingredients = ['Ingredient 1', 'Ingredient 2']
          ..instructions = ['Step 1', 'Step 2']
          ..prepTimeMinutes = 15
          ..cookTimeMinutes = 30
          ..servings = 4
          ..difficulty = RecipeDifficulty.easy
          ..categories = ['Dinner', 'Quick']
          ..isFavorite = true
          ..createdAt = DateTime.utc(2024, 1, 15, 10, 30)
          ..updatedAt = DateTime.utc(2024, 1, 16, 12, 0);

        final result = exportService.exportToJson([recipe]);

        expect(result['recipeCount'], 1);

        final exportedRecipe = result['recipes'][0] as Map<String, dynamic>;
        expect(exportedRecipe['title'], 'Test Recipe');
        expect(exportedRecipe['description'], 'A test description');
        expect(exportedRecipe['ingredients'], ['Ingredient 1', 'Ingredient 2']);
        expect(exportedRecipe['instructions'], ['Step 1', 'Step 2']);
        expect(exportedRecipe['prepTimeMinutes'], 15);
        expect(exportedRecipe['cookTimeMinutes'], 30);
        expect(exportedRecipe['servings'], 4);
        expect(exportedRecipe['difficulty'], 'easy');
        expect(exportedRecipe['categories'], ['Dinner', 'Quick']);
        expect(exportedRecipe['isFavorite'], true);
        expect(exportedRecipe['createdAt'], '2024-01-15T10:30:00.000Z');
        expect(exportedRecipe['updatedAt'], '2024-01-16T12:00:00.000Z');
      });

      test('should handle null optional fields', () {
        final recipe = Recipe()
          ..title = 'Simple Recipe'
          ..ingredients = ['One ingredient']
          ..instructions = ['One step'];

        final result = exportService.exportToJson([recipe]);
        final exportedRecipe = result['recipes'][0] as Map<String, dynamic>;

        expect(exportedRecipe['title'], 'Simple Recipe');
        expect(exportedRecipe['description'], isNull);
        expect(exportedRecipe['prepTimeMinutes'], isNull);
        expect(exportedRecipe['cookTimeMinutes'], isNull);
        expect(exportedRecipe['servings'], isNull);
        expect(exportedRecipe['difficulty'], isNull);
        expect(exportedRecipe['createdAt'], isNull);
        expect(exportedRecipe['updatedAt'], isNull);
      });

      test('should export multiple recipes', () {
        final recipes = [
          Recipe()
            ..title = 'Recipe 1'
            ..ingredients = ['A']
            ..instructions = ['Do A'],
          Recipe()
            ..title = 'Recipe 2'
            ..ingredients = ['B']
            ..instructions = ['Do B'],
          Recipe()
            ..title = 'Recipe 3'
            ..ingredients = ['C']
            ..instructions = ['Do C'],
        ];

        final result = exportService.exportToJson(recipes);

        expect(result['recipeCount'], 3);
        expect(result['recipes'].length, 3);
        expect(result['recipes'][0]['title'], 'Recipe 1');
        expect(result['recipes'][1]['title'], 'Recipe 2');
        expect(result['recipes'][2]['title'], 'Recipe 3');
      });

      test('should include valid ISO 8601 export date', () {
        final before = DateTime.now().toUtc();
        final result = exportService.exportToJson([]);
        final after = DateTime.now().toUtc();

        final exportDate = DateTime.parse(result['exportDate'] as String);

        expect(
          exportDate.isAfter(before.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          exportDate.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
      });

      test('should handle all difficulty levels', () {
        final recipes = [
          Recipe()
            ..title = 'Easy'
            ..ingredients = []
            ..instructions = []
            ..difficulty = RecipeDifficulty.easy,
          Recipe()
            ..title = 'Medium'
            ..ingredients = []
            ..instructions = []
            ..difficulty = RecipeDifficulty.medium,
          Recipe()
            ..title = 'Hard'
            ..ingredients = []
            ..instructions = []
            ..difficulty = RecipeDifficulty.hard,
        ];

        final result = exportService.exportToJson(recipes);

        expect(result['recipes'][0]['difficulty'], 'easy');
        expect(result['recipes'][1]['difficulty'], 'medium');
        expect(result['recipes'][2]['difficulty'], 'hard');
      });
    });

    group('exportToJsonString', () {
      test('should return valid JSON string', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['A']
          ..instructions = ['B'];

        final jsonString = exportService.exportToJsonString([recipe]);

        // Should be valid JSON
        expect(() => jsonDecode(jsonString), returnsNormally);

        // Should be pretty-printed (contains newlines)
        expect(jsonString.contains('\n'), isTrue);
      });

      test('should be parseable back to same data', () {
        final recipe = Recipe()
          ..title = 'Roundtrip Test'
          ..description = 'Testing roundtrip'
          ..ingredients = ['Ingredient']
          ..instructions = ['Step']
          ..prepTimeMinutes = 10
          ..cookTimeMinutes = 20
          ..servings = 2
          ..difficulty = RecipeDifficulty.medium
          ..categories = ['Test']
          ..isFavorite = true;

        final jsonString = exportService.exportToJsonString([recipe]);
        final parsed = jsonDecode(jsonString) as Map<String, dynamic>;

        expect(parsed['recipeCount'], 1);
        expect(parsed['recipes'][0]['title'], 'Roundtrip Test');
        expect(parsed['recipes'][0]['description'], 'Testing roundtrip');
        expect(parsed['recipes'][0]['prepTimeMinutes'], 10);
        expect(parsed['recipes'][0]['cookTimeMinutes'], 20);
        expect(parsed['recipes'][0]['servings'], 2);
        expect(parsed['recipes'][0]['difficulty'], 'medium');
        expect(parsed['recipes'][0]['isFavorite'], true);
      });
    });

    group('exportVersion', () {
      test('should be a valid semver string', () {
        const version = ExportService.exportVersion;

        // Should match semver pattern (x.y.z)
        expect(RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version), isTrue);
      });

      test('should be 1.0.0 for initial release', () {
        expect(ExportService.exportVersion, '1.0.0');
      });
    });
  });
}
