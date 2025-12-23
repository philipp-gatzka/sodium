import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('should display icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'Test message',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });

    testWidgets('should display primary message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'No recipes yet',
            ),
          ),
        ),
      );

      expect(find.text('No recipes yet'), findsOneWidget);
    });

    testWidgets('should display secondary message when provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'No recipes yet',
              secondaryMessage: 'Tap + to add your first recipe',
            ),
          ),
        ),
      );

      expect(find.text('Tap + to add your first recipe'), findsOneWidget);
    });

    testWidgets('should not display secondary message when not provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'No recipes yet',
            ),
          ),
        ),
      );

      expect(find.text('Tap + to add your first recipe'), findsNothing);
    });

    testWidgets('content should be vertically centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'Test message',
            ),
          ),
        ),
      );

      // Find the Column inside EmptyState and verify it has mainAxisAlignment center
      final column = tester.widget<Column>(
        find.descendant(
            of: find.byType(EmptyState), matching: find.byType(Column)),
      );
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should have Column for layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'Test message',
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('icon should have correct size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_menu,
              primaryMessage: 'Test message',
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.restaurant_menu));
      expect(icon.size, equals(64));
    });
  });
}
