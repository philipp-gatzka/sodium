import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/category_filter_chips.dart';

void main() {
  group('CategoryFilterChips', () {
    testWidgets('should not show anything when categories is empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const [],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(FilterChip), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should display All chip first', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch'],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('should display all category chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch', 'Dinner'],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
    });

    testWidgets('should show All chip as selected when selectedCategory is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch'],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      final allChip = find.widgetWithText(FilterChip, 'All');
      final allChipWidget = tester.widget<FilterChip>(allChip);
      expect(allChipWidget.selected, isTrue);

      final breakfastChip = find.widgetWithText(FilterChip, 'Breakfast');
      final breakfastChipWidget = tester.widget<FilterChip>(breakfastChip);
      expect(breakfastChipWidget.selected, isFalse);
    });

    testWidgets('should show category chip as selected when it matches',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch'],
              selectedCategory: 'Breakfast',
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      final allChip = find.widgetWithText(FilterChip, 'All');
      final allChipWidget = tester.widget<FilterChip>(allChip);
      expect(allChipWidget.selected, isFalse);

      final breakfastChip = find.widgetWithText(FilterChip, 'Breakfast');
      final breakfastChipWidget = tester.widget<FilterChip>(breakfastChip);
      expect(breakfastChipWidget.selected, isTrue);

      final lunchChip = find.widgetWithText(FilterChip, 'Lunch');
      final lunchChipWidget = tester.widget<FilterChip>(lunchChip);
      expect(lunchChipWidget.selected, isFalse);
    });

    testWidgets('should call onCategorySelected with null when All is tapped',
        (tester) async {
      String? selectedCategory = 'Breakfast';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch'],
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(FilterChip, 'All'));
      await tester.pump();

      expect(selectedCategory, isNull);
    });

    testWidgets(
        'should call onCategorySelected with category when category is tapped',
        (tester) async {
      String? selectedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch'],
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                selectedCategory = category;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(FilterChip, 'Lunch'));
      await tester.pump();

      expect(selectedCategory, 'Lunch');
    });

    testWidgets('should be horizontally scrollable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const [
                'Breakfast',
                'Lunch',
                'Dinner',
                'Dessert',
                'Snack',
                'Appetizer',
                'Beverage',
              ],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      // Should have a ListView for horizontal scrolling
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should have correct item count including All chip',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryFilterChips(
              categories: const ['Breakfast', 'Lunch'],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      // 3 chips: All + Breakfast + Lunch
      expect(find.byType(FilterChip), findsNWidgets(3));
    });
  });
}
