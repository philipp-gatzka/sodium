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
}
