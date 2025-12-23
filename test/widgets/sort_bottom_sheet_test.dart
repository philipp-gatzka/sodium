import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/sort_option.dart';
import 'package:sodium/widgets/sort_bottom_sheet.dart';

void main() {
  group('SortBottomSheet', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SortBottomSheet(
              selectedOption: RecipeSortOption.newestFirst,
              onOptionSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Sort by'), findsOneWidget);
    });

    testWidgets('should display all sort options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SortBottomSheet(
              selectedOption: RecipeSortOption.newestFirst,
              onOptionSelected: (_) {},
            ),
          ),
        ),
      );

      for (final option in RecipeSortOption.values) {
        expect(find.text(option.displayName), findsOneWidget);
      }
    });

    testWidgets('should show check mark for selected option', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SortBottomSheet(
              selectedOption: RecipeSortOption.titleAZ,
              onOptionSelected: (_) {},
            ),
          ),
        ),
      );

      // Find the check icon
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should call onOptionSelected when option is tapped',
        (tester) async {
      RecipeSortOption? selectedOption;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SortBottomSheet(
              selectedOption: RecipeSortOption.newestFirst,
              onOptionSelected: (option) {
                selectedOption = option;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Title (A-Z)'));
      await tester.pump();

      expect(selectedOption, RecipeSortOption.titleAZ);
    });

    testWidgets('should display icons for all options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SortBottomSheet(
              selectedOption: RecipeSortOption.newestFirst,
              onOptionSelected: (_) {},
            ),
          ),
        ),
      );

      // Check for icons
      expect(find.byIcon(Icons.schedule), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.sort_by_alpha), findsNWidgets(2));
      expect(find.byIcon(Icons.timer), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('show method should return selected option', (tester) async {
      // Set a larger screen size to avoid overflow in bottom sheet
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      RecipeSortOption? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await SortBottomSheet.show(
                    context: context,
                    currentOption: RecipeSortOption.newestFirst,
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Tap on an option
      await tester.tap(find.text('Oldest first'));
      await tester.pumpAndSettle();

      expect(result, RecipeSortOption.oldestFirst);
    });
  });
}
