import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:sodium/app.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/providers/database_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Isar testIsar;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    testIsar = await Isar.open(
      [RecipeSchema],
      directory: '',
      name: 'integration_test_${DateTime.now().millisecondsSinceEpoch}',
    );
    // Clear any existing data
    await testIsar.writeTxn(() => testIsar.recipes.clear());
  });

  tearDown(() async {
    await testIsar.close(deleteFromDisk: true);
  });

  group('Recipe CRUD Flow', () {
    testWidgets('Complete recipe lifecycle: create, view, edit, delete',
        (tester) async {
      // Launch app with test database
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWith((ref) async => testIsar),
          ],
          child: const SodiumApp(),
        ),
      );

      // Wait for app to load
      await tester.pumpAndSettle();

      // Step 1: Verify app starts with empty state
      expect(find.text('My Recipes'), findsOneWidget);
      expect(find.text('No recipes yet'), findsOneWidget);
      expect(find.text('Tap + to add your first recipe'), findsOneWidget);

      // Step 2: Tap FAB to create new recipe
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're on the create screen
      expect(find.text('New Recipe'), findsOneWidget);

      // Step 3: Fill in recipe details
      // Enter title
      final titleField =
          find.widgetWithText(TextFormField, 'Enter recipe name');
      await tester.enterText(titleField, 'Test Chocolate Cake');
      await tester.pump();

      // Add an ingredient
      final addIngredientButton = find.byIcon(Icons.add).first;
      await tester.tap(addIngredientButton);
      await tester.pump();

      // Find ingredient text fields and enter data
      final ingredientFields = find.byType(TextFormField);
      // The first one is title, look for ingredient fields
      await tester.enterText(ingredientFields.at(1), '2 cups flour');
      await tester.pump();

      // Add an instruction
      // Find the add button for instructions (second add icon)
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pump();

      // Find instruction text fields
      final allTextFields = find.byType(TextFormField);
      // Enter instruction in one of the instruction fields
      await tester.enterText(allTextFields.last, 'Mix all ingredients');
      await tester.pump();

      // Step 4: Save recipe
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Step 5: Verify recipe appears in list
      expect(find.text('My Recipes'), findsOneWidget);
      expect(find.text('Test Chocolate Cake'), findsOneWidget);
      expect(find.text('No recipes yet'), findsNothing);

      // Step 6: Tap recipe to view details
      await tester.tap(find.text('Test Chocolate Cake'));
      await tester.pumpAndSettle();

      // Verify details are displayed
      expect(find.text('Test Chocolate Cake'), findsOneWidget);
      expect(find.text('Ingredients'), findsOneWidget);
      expect(find.text('Instructions'), findsOneWidget);
      expect(find.text('2 cups flour'), findsOneWidget);
      expect(find.text('Mix all ingredients'), findsOneWidget);

      // Step 7: Tap edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Verify edit screen
      expect(find.text('Edit Recipe'), findsOneWidget);

      // Step 8: Modify recipe title
      final editTitleField =
          find.widgetWithText(TextFormField, 'Enter recipe name');
      await tester.enterText(editTitleField, 'Updated Chocolate Cake');
      await tester.pump();

      // Step 9: Save changes
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Step 10: Verify updates reflected in detail view
      expect(find.text('Updated Chocolate Cake'), findsOneWidget);

      // Step 11: Delete recipe
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Delete this recipe?'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);

      // Confirm delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Step 12: Verify list is empty again
      expect(find.text('My Recipes'), findsOneWidget);
      expect(find.text('No recipes yet'), findsOneWidget);
      expect(find.text('Updated Chocolate Cake'), findsNothing);
    });

    testWidgets('Search functionality works correctly', (tester) async {
      // Pre-populate with recipes
      await testIsar.writeTxn(() async {
        await testIsar.recipes.putAll([
          Recipe()
            ..title = 'Apple Pie'
            ..ingredients = ['apples', 'sugar']
            ..instructions = ['bake'],
          Recipe()
            ..title = 'Banana Bread'
            ..ingredients = ['bananas', 'flour']
            ..instructions = ['mix', 'bake'],
          Recipe()
            ..title = 'Cherry Tart'
            ..ingredients = ['cherries']
            ..instructions = ['prepare'],
        ]);
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWith((ref) async => testIsar),
          ],
          child: const SodiumApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify all recipes are shown
      expect(find.text('Apple Pie'), findsOneWidget);
      expect(find.text('Banana Bread'), findsOneWidget);
      expect(find.text('Cherry Tart'), findsOneWidget);

      // Search for "Banana"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Banana');
      await tester.pump(const Duration(milliseconds: 400)); // Wait for debounce
      await tester.pumpAndSettle();

      // Only Banana Bread should be visible
      expect(find.text('Banana Bread'), findsOneWidget);
      expect(find.text('Apple Pie'), findsNothing);
      expect(find.text('Cherry Tart'), findsNothing);

      // Clear search
      await tester.enterText(searchField, '');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // All recipes should be visible again
      expect(find.text('Apple Pie'), findsOneWidget);
      expect(find.text('Banana Bread'), findsOneWidget);
      expect(find.text('Cherry Tart'), findsOneWidget);
    });

    testWidgets('Cancel delete returns to detail screen', (tester) async {
      // Pre-populate with a recipe
      await testIsar.writeTxn(() async {
        await testIsar.recipes.put(
          Recipe()
            ..title = 'Test Recipe'
            ..ingredients = ['test']
            ..instructions = ['test'],
        );
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWith((ref) async => testIsar),
          ],
          child: const SodiumApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to detail screen
      await tester.tap(find.text('Test Recipe'));
      await tester.pumpAndSettle();

      // Tap delete
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Cancel delete
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Should still be on detail screen
      expect(find.text('Test Recipe'), findsOneWidget);
      expect(find.text('Ingredients'), findsOneWidget);
    });

    testWidgets('Empty search shows no results message', (tester) async {
      // Pre-populate with a recipe
      await testIsar.writeTxn(() async {
        await testIsar.recipes.put(
          Recipe()
            ..title = 'Apple Pie'
            ..ingredients = []
            ..instructions = [],
        );
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isarProvider.overrideWith((ref) async => testIsar),
          ],
          child: const SodiumApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Search for something that doesn't exist
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'NonExistent');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Should show no results message
      expect(find.text('No recipes found'), findsOneWidget);
      expect(find.text('Try a different search term'), findsOneWidget);
    });
  });
}
