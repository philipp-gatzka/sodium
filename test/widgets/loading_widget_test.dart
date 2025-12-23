import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/loading_widget.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('should display CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should be centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      // LoadingWidget wraps content in a Center widget
      expect(
        find.descendant(
            of: find.byType(LoadingWidget), matching: find.byType(Center)),
        findsOneWidget,
      );
    });

    testWidgets('should display message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: 'Loading recipes...'),
          ),
        ),
      );

      expect(find.text('Loading recipes...'), findsOneWidget);
    });

    testWidgets('should not display message when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      // No text widgets other than from the spinner
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should have Column for layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(
        find.descendant(
            of: find.byType(LoadingWidget), matching: find.byType(Column)),
        findsOneWidget,
      );
    });

    testWidgets('content should be vertically centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      final column = tester.widget<Column>(
        find.descendant(
            of: find.byType(LoadingWidget), matching: find.byType(Column)),
      );
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });
  });
}
