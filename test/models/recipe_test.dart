import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:sodium/models/recipe.dart';

void main() {
  group('Recipe', () {
    group('Creation', () {
      test('should create recipe with all fields', () {
        final now = DateTime.now();
        final recipe = Recipe()
          ..title = 'Pasta Carbonara'
          ..ingredients = ['pasta', 'eggs', 'bacon', 'parmesan']
          ..instructions = ['Boil pasta', 'Fry bacon', 'Mix eggs', 'Combine']
          ..createdAt = now
          ..updatedAt = now;

        expect(recipe.title, 'Pasta Carbonara');
        expect(recipe.ingredients, ['pasta', 'eggs', 'bacon', 'parmesan']);
        expect(recipe.instructions,
            ['Boil pasta', 'Fry bacon', 'Mix eggs', 'Combine']);
        expect(recipe.createdAt, now);
        expect(recipe.updatedAt, now);
      });

      test('should create recipe with minimal fields', () {
        final recipe = Recipe()
          ..title = 'Simple Recipe'
          ..ingredients = ['ingredient']
          ..instructions = ['step'];

        expect(recipe.title, 'Simple Recipe');
        expect(recipe.ingredients.length, 1);
        expect(recipe.instructions.length, 1);
      });
    });

    group('Default values', () {
      test('should have auto-increment ID by default', () {
        final recipe = Recipe();

        expect(recipe.id, Isar.autoIncrement);
      });

      test('should have null createdAt by default', () {
        final recipe = Recipe();

        expect(recipe.createdAt, isNull);
      });

      test('should have null updatedAt by default', () {
        final recipe = Recipe();

        expect(recipe.updatedAt, isNull);
      });
    });

    group('ID handling', () {
      test('should allow setting custom ID', () {
        final recipe = Recipe()..id = 42;

        expect(recipe.id, 42);
      });

      test('should accept zero as ID', () {
        final recipe = Recipe()..id = 0;

        expect(recipe.id, 0);
      });

      test('should accept large ID values', () {
        final recipe = Recipe()..id = 999999999;

        expect(recipe.id, 999999999);
      });
    });

    group('Title field', () {
      test('should accept empty string as title', () {
        final recipe = Recipe()
          ..title = ''
          ..ingredients = []
          ..instructions = [];

        expect(recipe.title, '');
      });

      test('should accept long title', () {
        final longTitle = 'A' * 1000;
        final recipe = Recipe()
          ..title = longTitle
          ..ingredients = []
          ..instructions = [];

        expect(recipe.title, longTitle);
        expect(recipe.title.length, 1000);
      });

      test('should accept title with special characters', () {
        final recipe = Recipe()
          ..title = 'Recipe with "quotes" & <special> chars!'
          ..ingredients = []
          ..instructions = [];

        expect(recipe.title, 'Recipe with "quotes" & <special> chars!');
      });

      test('should accept unicode title', () {
        final recipe = Recipe()
          ..title = 'Recipe 日本語 🍕'
          ..ingredients = []
          ..instructions = [];

        expect(recipe.title, 'Recipe 日本語 🍕');
      });
    });

    group('Ingredients list', () {
      test('should accept empty ingredients list', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = [];

        expect(recipe.ingredients, isEmpty);
      });

      test('should accept single ingredient', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['salt']
          ..instructions = [];

        expect(recipe.ingredients.length, 1);
        expect(recipe.ingredients.first, 'salt');
      });

      test('should accept many ingredients', () {
        final ingredients = List.generate(100, (i) => 'Ingredient $i');
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ingredients
          ..instructions = [];

        expect(recipe.ingredients.length, 100);
        expect(recipe.ingredients[50], 'Ingredient 50');
      });

      test('should preserve ingredient order', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['first', 'second', 'third']
          ..instructions = [];

        expect(recipe.ingredients[0], 'first');
        expect(recipe.ingredients[1], 'second');
        expect(recipe.ingredients[2], 'third');
      });

      test('should allow duplicate ingredients', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['salt', 'salt', 'pepper']
          ..instructions = [];

        expect(recipe.ingredients.where((i) => i == 'salt').length, 2);
      });
    });

    group('Instructions list', () {
      test('should accept empty instructions list', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = [];

        expect(recipe.instructions, isEmpty);
      });

      test('should accept single instruction', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = ['Mix well'];

        expect(recipe.instructions.length, 1);
        expect(recipe.instructions.first, 'Mix well');
      });

      test('should accept many instructions', () {
        final instructions = List.generate(50, (i) => 'Step ${i + 1}');
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = instructions;

        expect(recipe.instructions.length, 50);
        expect(recipe.instructions.last, 'Step 50');
      });

      test('should preserve instruction order', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = ['Preheat oven', 'Mix ingredients', 'Bake'];

        expect(recipe.instructions[0], 'Preheat oven');
        expect(recipe.instructions[1], 'Mix ingredients');
        expect(recipe.instructions[2], 'Bake');
      });

      test('should accept long instructions', () {
        final longInstruction = 'A' * 5000;
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = [longInstruction];

        expect(recipe.instructions.first.length, 5000);
      });
    });

    group('Timestamp fields', () {
      test('should accept DateTime for createdAt', () {
        final now = DateTime.now();
        final recipe = Recipe()..createdAt = now;

        expect(recipe.createdAt, now);
      });

      test('should accept DateTime for updatedAt', () {
        final now = DateTime.now();
        final recipe = Recipe()..updatedAt = now;

        expect(recipe.updatedAt, now);
      });

      test('should allow different createdAt and updatedAt', () {
        final created = DateTime(2024, 1, 1, 10, 0);
        final updated = DateTime(2024, 6, 15, 14, 30);
        final recipe = Recipe()
          ..createdAt = created
          ..updatedAt = updated;

        expect(recipe.createdAt, created);
        expect(recipe.updatedAt, updated);
        expect(recipe.updatedAt!.isAfter(recipe.createdAt!), isTrue);
      });

      test('should accept null timestamps', () {
        final recipe = Recipe()
          ..createdAt = null
          ..updatedAt = null;

        expect(recipe.createdAt, isNull);
        expect(recipe.updatedAt, isNull);
      });

      test('should handle timestamps with milliseconds', () {
        final timestamp = DateTime(2024, 12, 25, 12, 30, 45, 123);
        final recipe = Recipe()..createdAt = timestamp;

        expect(recipe.createdAt?.millisecond, 123);
      });
    });

    group('Mutability', () {
      test('should allow modifying title after creation', () {
        final recipe = Recipe()
          ..title = 'Original'
          ..ingredients = []
          ..instructions = [];

        recipe.title = 'Modified';

        expect(recipe.title, 'Modified');
      });

      test('should allow modifying ingredients after creation', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['original']
          ..instructions = [];

        recipe.ingredients = ['modified'];

        expect(recipe.ingredients, ['modified']);
      });

      test('should allow modifying instructions after creation', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = ['original'];

        recipe.instructions = ['modified'];

        expect(recipe.instructions, ['modified']);
      });

      test('should allow adding to ingredients list', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['item1']
          ..instructions = [];

        recipe.ingredients.add('item2');

        expect(recipe.ingredients.length, 2);
        expect(recipe.ingredients, contains('item2'));
      });

      test('should allow removing from ingredients list', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['item1', 'item2']
          ..instructions = [];

        recipe.ingredients.remove('item1');

        expect(recipe.ingredients.length, 1);
        expect(recipe.ingredients, isNot(contains('item1')));
      });
    });

    group('Edge cases', () {
      test('should handle whitespace in title', () {
        final recipe = Recipe()
          ..title = '  Spaced Title  '
          ..ingredients = []
          ..instructions = [];

        expect(recipe.title, '  Spaced Title  ');
      });

      test('should handle empty strings in ingredients', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = ['', 'valid', '']
          ..instructions = [];

        expect(recipe.ingredients.length, 3);
        expect(recipe.ingredients.where((i) => i.isEmpty).length, 2);
      });

      test('should handle newlines in instructions', () {
        final recipe = Recipe()
          ..title = 'Test'
          ..ingredients = []
          ..instructions = ['Line 1\nLine 2\nLine 3'];

        expect(recipe.instructions.first.contains('\n'), isTrue);
      });
    });
  });
}
