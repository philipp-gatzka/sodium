import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/repositories/recipe_repository.dart';

void main() {
  late Isar isar;
  late RecipeRepository repository;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [RecipeSchema],
      directory: '',
    );
    repository = RecipeRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('RecipeRepository', () {
    group('addRecipe', () {
      test('should save recipe and return with valid ID', () async {
        final recipe = Recipe()
          ..title = 'Test Recipe'
          ..ingredients = ['ingredient 1', 'ingredient 2']
          ..instructions = ['step 1', 'step 2'];

        final result = await repository.addRecipe(recipe);

        expect(result.id, isNot(Isar.autoIncrement));
        expect(result.title, equals('Test Recipe'));
        expect(result.ingredients, equals(['ingredient 1', 'ingredient 2']));
        expect(result.instructions, equals(['step 1', 'step 2']));
      });

      test('should set createdAt timestamp', () async {
        final beforeSave = DateTime.now();
        final recipe = Recipe()
          ..title = 'Test Recipe'
          ..ingredients = []
          ..instructions = [];

        final result = await repository.addRecipe(recipe);
        final afterSave = DateTime.now();

        expect(result.createdAt, isNotNull);
        expect(
          result.createdAt!
              .isAfter(beforeSave.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          result.createdAt!.isBefore(afterSave.add(const Duration(seconds: 1))),
          isTrue,
        );
      });

      test('should set updatedAt timestamp', () async {
        final beforeSave = DateTime.now();
        final recipe = Recipe()
          ..title = 'Test Recipe'
          ..ingredients = []
          ..instructions = [];

        final result = await repository.addRecipe(recipe);
        final afterSave = DateTime.now();

        expect(result.updatedAt, isNotNull);
        expect(
          result.updatedAt!
              .isAfter(beforeSave.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          result.updatedAt!.isBefore(afterSave.add(const Duration(seconds: 1))),
          isTrue,
        );
      });

      test('should persist recipe to database', () async {
        final recipe = Recipe()
          ..title = 'Persisted Recipe'
          ..ingredients = ['flour', 'water']
          ..instructions = ['mix', 'bake'];

        final saved = await repository.addRecipe(recipe);
        final retrieved = await isar.recipes.get(saved.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.title, equals('Persisted Recipe'));
        expect(retrieved.ingredients, equals(['flour', 'water']));
        expect(retrieved.instructions, equals(['mix', 'bake']));
      });
    });

    group('getAllRecipes', () {
      test('should return empty list when no recipes exist', () async {
        final recipes = await repository.getAllRecipes();

        expect(recipes, isEmpty);
      });

      test('should return all recipes from database', () async {
        await repository.addRecipe(Recipe()
          ..title = 'Recipe 1'
          ..ingredients = []
          ..instructions = []);
        await repository.addRecipe(Recipe()
          ..title = 'Recipe 2'
          ..ingredients = []
          ..instructions = []);
        await repository.addRecipe(Recipe()
          ..title = 'Recipe 3'
          ..ingredients = []
          ..instructions = []);

        final recipes = await repository.getAllRecipes();

        expect(recipes.length, equals(3));
      });

      test('should return recipes sorted by createdAt descending', () async {
        await repository.addRecipe(Recipe()
          ..title = 'First Recipe'
          ..ingredients = []
          ..instructions = []);

        // Small delay to ensure different timestamps
        await Future.delayed(const Duration(milliseconds: 10));

        await repository.addRecipe(Recipe()
          ..title = 'Second Recipe'
          ..ingredients = []
          ..instructions = []);

        await Future.delayed(const Duration(milliseconds: 10));

        await repository.addRecipe(Recipe()
          ..title = 'Third Recipe'
          ..ingredients = []
          ..instructions = []);

        final recipes = await repository.getAllRecipes();

        expect(recipes.length, equals(3));
        // Newest first
        expect(recipes[0].title, equals('Third Recipe'));
        expect(recipes[1].title, equals('Second Recipe'));
        expect(recipes[2].title, equals('First Recipe'));
      });
    });

    group('getRecipeById', () {
      test('should return recipe for valid ID', () async {
        final recipe = Recipe()
          ..title = 'Test Recipe'
          ..ingredients = ['ingredient 1']
          ..instructions = ['step 1'];

        final saved = await repository.addRecipe(recipe);
        final retrieved = await repository.getRecipeById(saved.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(saved.id));
        expect(retrieved.title, equals('Test Recipe'));
        expect(retrieved.ingredients, equals(['ingredient 1']));
        expect(retrieved.instructions, equals(['step 1']));
      });

      test('should return null for non-existent ID', () async {
        final retrieved = await repository.getRecipeById(99999);

        expect(retrieved, isNull);
      });

      test('should return correct recipe when multiple exist', () async {
        final recipe1 = await repository.addRecipe(Recipe()
          ..title = 'Recipe 1'
          ..ingredients = []
          ..instructions = []);
        await repository.addRecipe(Recipe()
          ..title = 'Recipe 2'
          ..ingredients = []
          ..instructions = []);

        final retrieved = await repository.getRecipeById(recipe1.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.title, equals('Recipe 1'));
      });
    });

    group('updateRecipe', () {
      test('should update recipe fields in database', () async {
        final recipe = await repository.addRecipe(Recipe()
          ..title = 'Original Title'
          ..ingredients = ['original ingredient']
          ..instructions = ['original step']);

        recipe.title = 'Updated Title';
        recipe.ingredients = ['updated ingredient 1', 'updated ingredient 2'];
        recipe.instructions = ['updated step 1', 'updated step 2'];

        await repository.updateRecipe(recipe);
        final retrieved = await repository.getRecipeById(recipe.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.title, equals('Updated Title'));
        expect(
          retrieved.ingredients,
          equals(['updated ingredient 1', 'updated ingredient 2']),
        );
        expect(
          retrieved.instructions,
          equals(['updated step 1', 'updated step 2']),
        );
      });

      test('should update updatedAt timestamp', () async {
        final recipe = await repository.addRecipe(Recipe()
          ..title = 'Test Recipe'
          ..ingredients = []
          ..instructions = []);

        final originalUpdatedAt = recipe.updatedAt;

        await Future.delayed(const Duration(milliseconds: 10));

        final beforeUpdate = DateTime.now();
        final updated = await repository.updateRecipe(recipe);
        final afterUpdate = DateTime.now();

        expect(updated.updatedAt, isNotNull);
        expect(updated.updatedAt!.isAfter(originalUpdatedAt!), isTrue);
        expect(
          updated.updatedAt!
              .isAfter(beforeUpdate.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          updated.updatedAt!
              .isBefore(afterUpdate.add(const Duration(seconds: 1))),
          isTrue,
        );
      });

      test('should preserve createdAt timestamp', () async {
        final recipe = await repository.addRecipe(Recipe()
          ..title = 'Test Recipe'
          ..ingredients = []
          ..instructions = []);

        final originalCreatedAt = recipe.createdAt;

        await Future.delayed(const Duration(milliseconds: 10));

        recipe.title = 'Updated Title';
        final updated = await repository.updateRecipe(recipe);

        expect(updated.createdAt, equals(originalCreatedAt));
      });
    });

    group('deleteRecipe', () {
      test('should delete recipe and return true', () async {
        final recipe = await repository.addRecipe(Recipe()
          ..title = 'Recipe to Delete'
          ..ingredients = []
          ..instructions = []);

        final deleted = await repository.deleteRecipe(recipe.id);

        expect(deleted, isTrue);
      });

      test('should return false for non-existent ID', () async {
        final deleted = await repository.deleteRecipe(99999);

        expect(deleted, isFalse);
      });

      test('should remove recipe from database', () async {
        final recipe = await repository.addRecipe(Recipe()
          ..title = 'Recipe to Delete'
          ..ingredients = []
          ..instructions = []);

        await repository.deleteRecipe(recipe.id);
        final retrieved = await repository.getRecipeById(recipe.id);

        expect(retrieved, isNull);
      });

      test('should not affect other recipes', () async {
        final recipe1 = await repository.addRecipe(Recipe()
          ..title = 'Recipe 1'
          ..ingredients = []
          ..instructions = []);
        final recipe2 = await repository.addRecipe(Recipe()
          ..title = 'Recipe 2'
          ..ingredients = []
          ..instructions = []);

        await repository.deleteRecipe(recipe1.id);

        final retrieved = await repository.getRecipeById(recipe2.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.title, equals('Recipe 2'));
      });
    });
  });
}
