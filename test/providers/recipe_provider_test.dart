import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/providers/database_provider.dart';
import 'package:sodium/providers/recipe_provider.dart';
import 'package:sodium/repositories/recipe_repository.dart';

void main() {
  late Isar testIsar;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    testIsar = await Isar.open(
      [RecipeSchema],
      directory: '',
    );
  });

  tearDown(() async {
    await testIsar.close(deleteFromDisk: true);
  });

  group('recipeRepositoryProvider', () {
    test('should be a Provider<RecipeRepository>', () {
      expect(recipeRepositoryProvider, isA<Provider<RecipeRepository>>());
    });

    test('should provide RecipeRepository instance', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      // Wait for isar to be ready
      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);

      expect(repository, isA<RecipeRepository>());
    });

    test('should use Isar instance from isarProvider', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);

      // Verify by performing an operation
      final recipe = await repository.addRecipe(Recipe()
        ..title = 'Test Recipe'
        ..ingredients = ['ingredient']
        ..instructions = ['step']);

      expect(recipe.id, isNot(Isar.autoIncrement));

      // Verify it's in the database
      final retrieved = await testIsar.recipes.get(recipe.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.title, equals('Test Recipe'));
    });

    test('should allow CRUD operations through repository', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);

      // Create
      final recipe = await repository.addRecipe(Recipe()
        ..title = 'CRUD Test'
        ..ingredients = ['item1']
        ..instructions = ['do something']);

      // Read
      final fetched = await repository.getRecipeById(recipe.id);
      expect(fetched, isNotNull);
      expect(fetched!.title, equals('CRUD Test'));

      // Update
      fetched.title = 'Updated CRUD Test';
      await repository.updateRecipe(fetched);

      final updated = await repository.getRecipeById(recipe.id);
      expect(updated!.title, equals('Updated CRUD Test'));

      // Delete
      final deleted = await repository.deleteRecipe(recipe.id);
      expect(deleted, isTrue);

      final afterDelete = await repository.getRecipeById(recipe.id);
      expect(afterDelete, isNull);
    });

    test('should support search operations', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);

      await repository.addRecipe(Recipe()
        ..title = 'Chocolate Cake'
        ..ingredients = []
        ..instructions = []);
      await repository.addRecipe(Recipe()
        ..title = 'Vanilla Ice Cream'
        ..ingredients = []
        ..instructions = []);

      final results = await repository.searchRecipes('Chocolate');

      expect(results.length, equals(1));
      expect(results.first.title, equals('Chocolate Cake'));
    });
  });

  group('recipesProvider', () {
    test('should be a FutureProvider<List<Recipe>>', () {
      expect(recipesProvider, isA<FutureProvider<List<Recipe>>>());
    });

    test('should return empty list when no recipes exist', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final recipes = await container.read(recipesProvider.future);

      expect(recipes, isEmpty);
    });

    test('should return all recipes from repository', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'Recipe 1'
        ..ingredients = []
        ..instructions = []);
      await repository.addRecipe(Recipe()
        ..title = 'Recipe 2'
        ..ingredients = []
        ..instructions = []);

      // Invalidate to refresh
      container.invalidate(recipesProvider);

      final recipes = await container.read(recipesProvider.future);

      expect(recipes.length, equals(2));
    });

    test('should return recipes sorted by newest first', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'First Recipe'
        ..ingredients = []
        ..instructions = []);

      await Future.delayed(const Duration(milliseconds: 10));

      await repository.addRecipe(Recipe()
        ..title = 'Second Recipe'
        ..ingredients = []
        ..instructions = []);

      container.invalidate(recipesProvider);

      final recipes = await container.read(recipesProvider.future);

      expect(recipes.length, equals(2));
      expect(recipes[0].title, equals('Second Recipe'));
      expect(recipes[1].title, equals('First Recipe'));
    });

    test('should expose loading state', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final asyncValue = container.read(recipesProvider);

      expect(
        asyncValue,
        anyOf(
          isA<AsyncLoading<List<Recipe>>>(),
          isA<AsyncData<List<Recipe>>>(),
        ),
      );
    });

    test('should refresh when invalidated', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      // Initially empty
      var recipes = await container.read(recipesProvider.future);
      expect(recipes, isEmpty);

      // Add a recipe
      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'New Recipe'
        ..ingredients = []
        ..instructions = []);

      // Invalidate to refresh
      container.invalidate(recipesProvider);

      // Should now have the recipe
      recipes = await container.read(recipesProvider.future);
      expect(recipes.length, equals(1));
      expect(recipes.first.title, equals('New Recipe'));
    });
  });

  group('recipeSearchProvider', () {
    test('should be a FutureProvider.family', () {
      expect(
        recipeSearchProvider,
        isA<FutureProviderFamily<List<Recipe>, String>>(),
      );
    });

    test('should return matching recipes', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'Chocolate Cake'
        ..ingredients = []
        ..instructions = []);
      await repository.addRecipe(Recipe()
        ..title = 'Vanilla Pudding'
        ..ingredients = []
        ..instructions = []);
      await repository.addRecipe(Recipe()
        ..title = 'Chocolate Mousse'
        ..ingredients = []
        ..instructions = []);

      final results =
          await container.read(recipeSearchProvider('Chocolate').future);

      expect(results.length, equals(2));
      expect(results.every((r) => r.title.contains('Chocolate')), isTrue);
    });

    test('should return empty list when no matches', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'Apple Pie'
        ..ingredients = []
        ..instructions = []);

      final results =
          await container.read(recipeSearchProvider('Chocolate').future);

      expect(results, isEmpty);
    });

    test('should be case-insensitive', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'CHOCOLATE CAKE'
        ..ingredients = []
        ..instructions = []);
      await repository.addRecipe(Recipe()
        ..title = 'chocolate mousse'
        ..ingredients = []
        ..instructions = []);

      final results =
          await container.read(recipeSearchProvider('ChOcOlAtE').future);

      expect(results.length, equals(2));
    });

    test('should return all recipes for empty query', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'Recipe 1'
        ..ingredients = []
        ..instructions = []);
      await repository.addRecipe(Recipe()
        ..title = 'Recipe 2'
        ..ingredients = []
        ..instructions = []);

      final results = await container.read(recipeSearchProvider('').future);

      expect(results.length, equals(2));
    });

    test('should trim whitespace from query', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      await container.read(isarProvider.future);

      final repository = container.read(recipeRepositoryProvider);
      await repository.addRecipe(Recipe()
        ..title = 'Chocolate Cake'
        ..ingredients = []
        ..instructions = []);

      final results =
          await container.read(recipeSearchProvider('  Chocolate  ').future);

      expect(results.length, equals(1));
      expect(results.first.title, equals('Chocolate Cake'));
    });
  });
}
