import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/providers/database_provider.dart';

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

  group('isarProvider', () {
    test('should be a FutureProvider<Isar>', () {
      expect(isarProvider, isA<FutureProvider<Isar>>());
    });

    test('should provide Isar instance when overridden', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      final isar = await container.read(isarProvider.future);

      expect(isar, isA<Isar>());
      expect(isar, equals(testIsar));
    });

    test('should allow recipe operations through overridden provider',
        () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      final isar = await container.read(isarProvider.future);

      // Write a recipe
      await isar.writeTxn(() async {
        await isar.recipes.put(Recipe()
          ..title = 'Test Recipe'
          ..ingredients = ['ingredient']
          ..instructions = ['step']);
      });

      // Read it back
      final recipes = await isar.recipes.where().findAll();

      expect(recipes.length, equals(1));
      expect(recipes.first.title, equals('Test Recipe'));
    });

    test('should expose loading state', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      final asyncValue = container.read(isarProvider);

      // Initially might be loading or already loaded depending on timing
      expect(
        asyncValue,
        anyOf(
          isA<AsyncLoading<Isar>>(),
          isA<AsyncData<Isar>>(),
        ),
      );
    });

    test('should expose data state after loading', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => testIsar),
        ],
      );
      addTearDown(container.dispose);

      // Wait for the future to complete
      await container.read(isarProvider.future);

      final asyncValue = container.read(isarProvider);

      expect(asyncValue, isA<AsyncData<Isar>>());
      expect(asyncValue.value, equals(testIsar));
    });

    test('should expose error state on failure', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async {
            throw Exception('Database initialization failed');
          }),
        ],
      );
      addTearDown(container.dispose);

      // Wait for the future to complete (with error)
      try {
        await container.read(isarProvider.future);
      } catch (_) {
        // Expected to throw
      }

      final asyncValue = container.read(isarProvider);

      expect(asyncValue, isA<AsyncError<Isar>>());
    });
  });
}
