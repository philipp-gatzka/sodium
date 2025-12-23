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
  });
}
