import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/widgets/instructions_input.dart';

void main() {
  group('InstructionsInput', () {
    group('Initial state', () {
      testWidgets('should display one empty text field by default',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should display "Instructions" label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Instructions'), findsOneWidget);
      });

      testWidgets('should display hint text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Describe this step...'), findsOneWidget);
      });

      testWidgets('should display Add Step button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('Add Step'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('should display step number 1', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('should not show remove button when only one field',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNothing);
      });
    });

    group('Initial instructions', () {
      testWidgets('should populate fields with initial instructions',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const [
                  'Preheat oven',
                  'Mix ingredients',
                  'Bake for 30 minutes'
                ],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.text('Preheat oven'), findsOneWidget);
        expect(find.text('Mix ingredients'), findsOneWidget);
        expect(find.text('Bake for 30 minutes'), findsOneWidget);
      });

      testWidgets('should display correct step numbers', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['Step 1', 'Step 2', 'Step 3'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets(
          'should show remove buttons when multiple initial instructions',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['Step 1', 'Step 2'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNWidgets(2));
      });
    });

    group('Adding steps', () {
      testWidgets('should add new text field when Add button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsOneWidget);

        await tester.tap(find.text('Add Step'));
        await tester.pump();

        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('should display correct step numbers after adding',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Step'));
        await tester.pump();
        await tester.tap(find.text('Add Step'));
        await tester.pump();

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('should show remove buttons after adding second field',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNothing);

        await tester.tap(find.text('Add Step'));
        await tester.pump();

        expect(find.byIcon(Icons.close), findsNWidgets(2));
      });

      testWidgets('should call onChange when adding step', (tester) async {
        var callCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) => callCount++,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Step'));
        await tester.pump();

        expect(callCount, 1);
      });
    });

    group('Removing steps', () {
      testWidgets('should remove text field when X button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['Step 1', 'Step 2'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsNWidgets(2));

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should renumber steps after removing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['First', 'Second', 'Third'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        // Remove the first step
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();

        // Should now have steps numbered 1 and 2
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsNothing);
      });

      testWidgets('should hide remove buttons when down to one field',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['Step 1', 'Step 2'],
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

      testWidgets('should call onChange when removing step', (tester) async {
        List<String> lastInstructions = [];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['Step 1', 'Step 2'],
                onChange: (instructions) => lastInstructions = instructions,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pump();

        expect(lastInstructions, ['Step 2']);
      });

      testWidgets('should remove correct step', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const ['First', 'Second', 'Third'],
                onChange: (_) {},
              ),
            ),
          ),
        );

        // Remove the second step
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
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(
            find.byType(TextFormField), 'Preheat oven to 350°F');
        await tester.pump();

        expect(find.text('Preheat oven to 350°F'), findsOneWidget);
      });

      testWidgets('should call onChange when text is entered', (tester) async {
        List<String> lastInstructions = [];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (instructions) => lastInstructions = instructions,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'Mix the batter');
        await tester.pump();

        expect(lastInstructions, ['Mix the batter']);
      });

      testWidgets('should filter out empty instructions in onChange',
          (tester) async {
        List<String> lastInstructions = [];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (instructions) => lastInstructions = instructions,
              ),
            ),
          ),
        );

        // Add another step (now we have 2)
        await tester.tap(find.text('Add Step'));
        await tester.pump();

        // Enter text only in first field
        await tester.enterText(find.byType(TextFormField).first, 'Step one');
        await tester.pump();

        // onChange should only contain 'Step one', not the empty second field
        expect(lastInstructions, ['Step one']);
      });
    });

    group('Multi-line support', () {
      testWidgets('should support multi-line text entry', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        // Enter multi-line text
        await tester.enterText(
          find.byType(TextFormField),
          'Line 1\nLine 2\nLine 3',
        );
        await tester.pump();

        expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
      });

      testWidgets('should expand for longer text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                initialInstructions: const [
                  'This is a longer instruction that might need more space to display properly in the text field'
                ],
                onChange: (_) {},
              ),
            ),
          ),
        );

        // Text should be visible
        expect(
          find.textContaining('This is a longer instruction'),
          findsOneWidget,
        );
      });
    });

    group('Layout', () {
      testWidgets('should have Column as root widget', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(InstructionsInput),
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
              body: InstructionsInput(
                onChange: (_) => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Step'));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('should display step number in circle', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InstructionsInput(
                onChange: (_) {},
              ),
            ),
          ),
        );

        // Find the Container with BoxDecoration (circle)
        final container = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration != null) {
            final decoration = widget.decoration as BoxDecoration?;
            return decoration?.shape == BoxShape.circle;
          }
          return false;
        });

        expect(container, findsOneWidget);
      });
    });
  });
}
