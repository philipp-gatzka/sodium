import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/category_selector.dart';

void main() {
  group('CategorySelector', () {
    testWidgets('should display title and description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategorySelector(
              selectedCategories: const [],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Categories'), findsOneWidget);
      expect(
          find.text('Select categories for this recipe (optional)'),
          findsOneWidget);
    });

    testWidgets('should display all default categories', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      for (final category in defaultCategories) {
        expect(find.text(category), findsOneWidget);
      }
    });

    testWidgets('should show selected categories as selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const ['Breakfast', 'Lunch'],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Find FilterChips with selected state
      final breakfastChip = find.widgetWithText(FilterChip, 'Breakfast');
      final lunchChip = find.widgetWithText(FilterChip, 'Lunch');
      final dinnerChip = find.widgetWithText(FilterChip, 'Dinner');

      expect(breakfastChip, findsOneWidget);
      expect(lunchChip, findsOneWidget);
      expect(dinnerChip, findsOneWidget);

      // Check selected state
      final breakfastWidget = tester.widget<FilterChip>(breakfastChip);
      final lunchWidget = tester.widget<FilterChip>(lunchChip);
      final dinnerWidget = tester.widget<FilterChip>(dinnerChip);

      expect(breakfastWidget.selected, isTrue);
      expect(lunchWidget.selected, isTrue);
      expect(dinnerWidget.selected, isFalse);
    });

    testWidgets('should call onChanged when category is toggled',
        (tester) async {
      List<String>? changedCategories;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (categories) {
                  changedCategories = categories;
                },
              ),
            ),
          ),
        ),
      );

      // Tap on Breakfast chip
      await tester.tap(find.widgetWithText(FilterChip, 'Breakfast'));
      await tester.pump();

      expect(changedCategories, isNotNull);
      expect(changedCategories, contains('Breakfast'));
    });

    testWidgets('should remove category when tapped again', (tester) async {
      List<String>? changedCategories;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const ['Breakfast'],
                onChanged: (categories) {
                  changedCategories = categories;
                },
              ),
            ),
          ),
        ),
      );

      // Tap on Breakfast chip to deselect
      await tester.tap(find.widgetWithText(FilterChip, 'Breakfast'));
      await tester.pump();

      expect(changedCategories, isNotNull);
      expect(changedCategories, isNot(contains('Breakfast')));
    });

    testWidgets('should have custom category text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.widgetWithText(TextField, 'Add custom category'),
          findsOneWidget);
    });

    testWidgets('should add custom category when submitted', (tester) async {
      List<String>? changedCategories;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (categories) {
                  changedCategories = categories;
                },
              ),
            ),
          ),
        ),
      );

      // Enter custom category
      await tester.enterText(find.byType(TextField), 'My Custom Category');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changedCategories, isNotNull);
      expect(changedCategories, contains('My Custom Category'));
    });

    testWidgets('should add custom category when add button is tapped',
        (tester) async {
      List<String>? changedCategories;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (categories) {
                  changedCategories = categories;
                },
              ),
            ),
          ),
        ),
      );

      // Enter custom category
      await tester.enterText(find.byType(TextField), 'Another Category');

      // Tap add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changedCategories, isNotNull);
      expect(changedCategories, contains('Another Category'));
    });

    testWidgets('should not add empty custom category', (tester) async {
      List<String>? changedCategories;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (categories) {
                  changedCategories = categories;
                },
              ),
            ),
          ),
        ),
      );

      // Try to add empty category
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Should not have called onChanged
      expect(changedCategories, isNull);
    });

    testWidgets('should not add duplicate custom category', (tester) async {
      List<String>? changedCategories;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const ['Existing'],
                onChanged: (categories) {
                  changedCategories = categories;
                },
              ),
            ),
          ),
        ),
      );

      // Try to add duplicate category
      await tester.enterText(find.byType(TextField), 'Existing');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Should not have called onChanged
      expect(changedCategories, isNull);
    });

    testWidgets('should display custom categories from selection',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const ['CustomOne', 'CustomTwo'],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Custom categories should be displayed
      expect(find.text('CustomOne'), findsOneWidget);
      expect(find.text('CustomTwo'), findsOneWidget);
    });

    testWidgets('should clear text field after adding custom category',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CategorySelector(
                selectedCategories: const [],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);

      // Enter custom category
      await tester.enterText(textField, 'My Category');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Text field should be cleared
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller?.text, isEmpty);
    });
  });

  group('defaultCategories', () {
    test('should have expected categories', () {
      expect(defaultCategories, containsAll([
        'Breakfast',
        'Lunch',
        'Dinner',
        'Dessert',
        'Snack',
      ]));
    });

    test('should have 10 default categories', () {
      expect(defaultCategories.length, 10);
    });
  });
}
