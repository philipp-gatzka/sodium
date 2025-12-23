import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/search_bar.dart';

void main() {
  group('RecipeSearchBar', () {
    group('Initial state', () {
      testWidgets('should display TextField', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should display search icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should display hint text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Search recipes...'), findsOneWidget);
      });

      testWidgets('should not display clear button when empty', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.clear), findsNothing);
      });
    });

    group('Text input', () {
      testWidgets('should accept text input', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'pasta');
        await tester.pump();

        expect(find.text('pasta'), findsOneWidget);
      });

      testWidgets('should show clear button when text is entered',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.clear), findsNothing);

        await tester.enterText(find.byType(TextField), 'pasta');
        await tester.pump();

        expect(find.byIcon(Icons.clear), findsOneWidget);
      });
    });

    group('Clear button', () {
      testWidgets('should clear text when clear button is tapped',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'pasta');
        await tester.pump();

        expect(find.text('pasta'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(find.text('pasta'), findsNothing);
      });

      testWidgets('should hide clear button after clearing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'pasta');
        await tester.pump();

        expect(find.byIcon(Icons.clear), findsOneWidget);

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(find.byIcon(Icons.clear), findsNothing);
      });

      testWidgets('should call onSearch with empty string when cleared',
          (tester) async {
        String? lastQuery;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (query) => lastQuery = query,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'pasta');
        await tester.pump();

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(lastQuery, '');
      });
    });

    group('Debounce', () {
      testWidgets('should debounce onSearch calls', (tester) async {
        final searchCalls = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (query) => searchCalls.add(query),
                debounceDuration: 300,
              ),
            ),
          ),
        );

        // Type rapidly
        await tester.enterText(find.byType(TextField), 'p');
        await tester.pump(const Duration(milliseconds: 100));
        await tester.enterText(find.byType(TextField), 'pa');
        await tester.pump(const Duration(milliseconds: 100));
        await tester.enterText(find.byType(TextField), 'pas');
        await tester.pump(const Duration(milliseconds: 100));
        await tester.enterText(find.byType(TextField), 'past');
        await tester.pump(const Duration(milliseconds: 100));
        await tester.enterText(find.byType(TextField), 'pasta');
        await tester.pump();

        // Before debounce completes, no calls should have been made
        expect(searchCalls, isEmpty);

        // Wait for debounce to complete
        await tester.pump(const Duration(milliseconds: 300));

        // Only the final value should be sent
        expect(searchCalls, ['pasta']);
      });

      testWidgets('should call onSearch after debounce delay', (tester) async {
        String? lastQuery;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (query) => lastQuery = query,
                debounceDuration: 300,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'chicken');
        await tester.pump();

        // Not yet called
        expect(lastQuery, isNull);

        // Wait for debounce
        await tester.pump(const Duration(milliseconds: 300));

        expect(lastQuery, 'chicken');
      });

      testWidgets('should cancel previous debounce on new input',
          (tester) async {
        final searchCalls = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (query) => searchCalls.add(query),
                debounceDuration: 300,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'first');
        await tester.pump(const Duration(milliseconds: 200));

        // Enter new text before debounce completes
        await tester.enterText(find.byType(TextField), 'second');
        await tester.pump(const Duration(milliseconds: 300));

        // Only 'second' should be called, 'first' was cancelled
        expect(searchCalls, ['second']);
      });
    });

    group('Layout', () {
      testWidgets('should have OutlineInputBorder', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;
        expect(decoration.border, isA<OutlineInputBorder>());
      });

      testWidgets('clear button should have tooltip', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeSearchBar(
                onSearch: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        final iconButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.clear),
        );
        expect(iconButton.tooltip, 'Clear search');
      });
    });
  });
}
