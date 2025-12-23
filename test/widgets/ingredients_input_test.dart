import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/ingredients_input.dart';

void main() {
  group('IngredientsInput', () {
    group('Initial state', () {
      testWidgets('should display one empty text field by default',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should display "Ingredients" label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Ingredients'), findsOneWidget);
      });

      testWidgets('should display hint text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('e.g., 2 cups flour'), findsOneWidget);
      });

      testWidgets('should display Add Ingredient button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Add Ingredient'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('should not show remove button when only one field',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNothing);
      });
    });

    group('Initial ingredients', () {
      testWidgets('should populate fields with initial ingredients',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                initialIngredients: const ['Salt', 'Pepper', 'Olive Oil'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.text('Salt'), findsOneWidget);
        expect(find.text('Pepper'), findsOneWidget);
        expect(find.text('Olive Oil'), findsOneWidget);
      });

      testWidgets('should show remove buttons when multiple initial ingredients',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                initialIngredients: const ['Salt', 'Pepper'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNWidgets(2));
      });
    });

    group('Adding ingredients', () {
      testWidgets('should add new text field when Add button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);

        await tester.tap(find.text('Add Ingredient'));
        await tester.pump();

        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('should show remove buttons after adding second field',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNothing);

        await tester.tap(find.text('Add Ingredient'));
        await tester.pump();

        expect(find.byIcon(Icons.close), findsNWidgets(2));
      });

      testWidgets('should call onChange when adding ingredient', (tester) async {
        var callCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) => callCount++,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Ingredient'));
        await tester.pump();

        expect(callCount, 1);
      });
    });

    group('Removing ingredients', () {
      testWidgets('should remove text field when X button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                initialIngredients: const ['Salt', 'Pepper'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsNWidgets(2));

        // Tap first remove button
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should hide remove buttons when down to one field',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                initialIngredients: const ['Salt', 'Pepper'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNWidgets(2));

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();

        expect(find.byIcon(Icons.close), findsNothing);
      });

      testWidgets('should call onChange when removing ingredient',
          (tester) async {
        List<String> lastIngredients = [];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                initialIngredients: const ['Salt', 'Pepper'],
                onChange: (ingredients) => lastIngredients = ingredients,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();

        expect(lastIngredients, ['Pepper']);
      });

      testWidgets('should remove correct ingredient', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                initialIngredients: const ['First', 'Second', 'Third'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        // Find the second close button and tap it
        await tester.tap(find.byIcon(Icons.close).at(1));
        await tester.pump();

        expect(find.text('First'), findsOneWidget);
        expect(find.text('Second'), findsNothing);
        expect(find.text('Third'), findsOneWidget);
      });
    });

    group('Text input', () {
      testWidgets('should accept text input', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), '2 cups flour');
        await tester.pump();

        expect(find.text('2 cups flour'), findsOneWidget);
      });

      testWidgets('should call onChange when text is entered', (tester) async {
        List<String> lastIngredients = [];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (ingredients) => lastIngredients = ingredients,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), '2 cups flour');
        await tester.pump();

        expect(lastIngredients, ['2 cups flour']);
      });

      testWidgets('should filter out empty ingredients in onChange',
          (tester) async {
        List<String> lastIngredients = [];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (ingredients) => lastIngredients = ingredients,
              ),
            ),
          ),
        );

        // Add another ingredient field (now we have 2)
        await tester.tap(find.text('Add Ingredient'));
        await tester.pump();

        // Enter text only in first field
        await tester.enterText(find.byType(TextFormField).first, 'Salt');
        await tester.pump();

        // onChange should only contain 'Salt', not the empty second field
        expect(lastIngredients, ['Salt']);
      });
    });

    group('Layout', () {
      testWidgets('should have Column as root widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(IngredientsInput),
            matching: find.byType(Column),
          ),
          findsOneWidget,
        );
      });

      testWidgets('Add button should be tappable', (tester) async {
        var tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IngredientsInput(
                onChange: (_) => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Ingredient'));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });
  });
}
