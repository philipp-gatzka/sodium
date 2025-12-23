import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/recipe.dart';
import 'package:sodium/widgets/recipe_card.dart';

void main() {
  group('RecipeCard', () {
    late Recipe recipe;

    setUp(() {
      recipe = Recipe()
        ..id = 1
        ..title = 'Test Recipe'
        ..ingredients = ['flour', 'sugar', 'eggs']
        ..instructions = ['mix', 'bake'];
    });

    testWidgets('should display recipe title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(recipe: recipe),
          ),
        ),
      );

      expect(find.text('Test Recipe'), findsOneWidget);
    });

    testWidgets('should display ingredient count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(recipe: recipe),
          ),
        ),
      );

      expect(find.text('3 ingredients'), findsOneWidget);
    });

    testWidgets('should display singular ingredient for one item',
        (tester) async {
      recipe.ingredients = ['flour'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(recipe: recipe),
          ),
        ),
      );

      expect(find.text('1 ingredient'), findsOneWidget);
    });

    testWidgets('should display no ingredients message when empty',
        (tester) async {
      recipe.ingredients = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(recipe: recipe),
          ),
        ),
      );

      expect(find.text('No ingredients'), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(
              recipe: recipe,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RecipeCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('should have a Card widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(recipe: recipe),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should have an InkWell for tap effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeCard(recipe: recipe),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should handle long titles with ellipsis', (tester) async {
      recipe.title =
          'This is a very long recipe title that should be truncated with ellipsis';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: RecipeCard(recipe: recipe),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text(recipe.title));
      expect(textWidget.maxLines, equals(2));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });
  });
}
