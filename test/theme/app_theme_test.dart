import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.lightTheme;
    });

    group('General configuration', () {
      test('should return a valid ThemeData', () {
        expect(theme, isA<ThemeData>());
      });

      test('should use Material 3', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('should have a light brightness color scheme', () {
        expect(theme.colorScheme.brightness, Brightness.light);
      });

      test('should have primary color based on orange seed', () {
        // The primary color should be derived from the orange seed
        expect(theme.colorScheme.primary, isNotNull);
      });
    });

    group('ColorScheme', () {
      test('should have all required colors', () {
        final colorScheme = theme.colorScheme;

        expect(colorScheme.primary, isNotNull);
        expect(colorScheme.onPrimary, isNotNull);
        expect(colorScheme.secondary, isNotNull);
        expect(colorScheme.onSecondary, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.onSurface, isNotNull);
        expect(colorScheme.error, isNotNull);
        expect(colorScheme.onError, isNotNull);
      });

      test('should have accessible contrast ratios', () {
        final colorScheme = theme.colorScheme;

        // Primary text on primary background should have good contrast
        // (basic check - colors should be different)
        expect(colorScheme.primary, isNot(equals(colorScheme.onPrimary)));
        expect(colorScheme.surface, isNot(equals(colorScheme.onSurface)));
        expect(colorScheme.error, isNot(equals(colorScheme.onError)));
      });
    });

    group('AppBar theme', () {
      test('should have centered title', () {
        expect(theme.appBarTheme.centerTitle, isTrue);
      });

      test('should have zero elevation', () {
        expect(theme.appBarTheme.elevation, 0);
      });

      test('should have scrolled under elevation', () {
        expect(theme.appBarTheme.scrolledUnderElevation, 1);
      });

      test('should have surface background color', () {
        expect(theme.appBarTheme.backgroundColor, theme.colorScheme.surface);
      });

      test('should have onSurface foreground color', () {
        expect(theme.appBarTheme.foregroundColor, theme.colorScheme.onSurface);
      });

      test('should have title text style', () {
        expect(theme.appBarTheme.titleTextStyle, isNotNull);
        expect(theme.appBarTheme.titleTextStyle!.fontSize, 20);
        expect(theme.appBarTheme.titleTextStyle!.fontWeight, FontWeight.w600);
      });
    });

    group('Card theme', () {
      test('should have elevation', () {
        expect(theme.cardTheme.elevation, 1);
      });

      test('should have rounded corners', () {
        final shape = theme.cardTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(12));
      });

      test('should have antiAlias clip behavior', () {
        expect(theme.cardTheme.clipBehavior, Clip.antiAlias);
      });
    });

    group('FloatingActionButton theme', () {
      test('should have primary background color', () {
        expect(
          theme.floatingActionButtonTheme.backgroundColor,
          theme.colorScheme.primary,
        );
      });

      test('should have onPrimary foreground color', () {
        expect(
          theme.floatingActionButtonTheme.foregroundColor,
          theme.colorScheme.onPrimary,
        );
      });

      test('should have elevation', () {
        expect(theme.floatingActionButtonTheme.elevation, 4);
      });

      test('should have rounded shape', () {
        final shape =
            theme.floatingActionButtonTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(16));
      });
    });

    group('ElevatedButton theme', () {
      test('should have style defined', () {
        expect(theme.elevatedButtonTheme.style, isNotNull);
      });
    });

    group('TextButton theme', () {
      test('should have style defined', () {
        expect(theme.textButtonTheme.style, isNotNull);
      });
    });

    group('InputDecoration theme', () {
      test('should be filled', () {
        expect(theme.inputDecorationTheme.filled, isTrue);
      });

      test('should have fill color', () {
        expect(theme.inputDecorationTheme.fillColor, isNotNull);
      });

      test('should have border', () {
        expect(theme.inputDecorationTheme.border, isA<OutlineInputBorder>());
      });

      test('should have enabled border', () {
        expect(theme.inputDecorationTheme.enabledBorder,
            isA<OutlineInputBorder>());
      });

      test('should have focused border', () {
        expect(theme.inputDecorationTheme.focusedBorder,
            isA<OutlineInputBorder>());
      });

      test('should have error border', () {
        expect(
            theme.inputDecorationTheme.errorBorder, isA<OutlineInputBorder>());
      });

      test('should have focused error border', () {
        expect(theme.inputDecorationTheme.focusedErrorBorder,
            isA<OutlineInputBorder>());
      });

      test('should have content padding', () {
        expect(
          theme.inputDecorationTheme.contentPadding,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      });
    });

    group('Dialog theme', () {
      test('should have rounded shape', () {
        final shape = theme.dialogTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(16));
      });

      test('should have elevation', () {
        expect(theme.dialogTheme.elevation, 4);
      });
    });

    group('SnackBar theme', () {
      test('should have floating behavior', () {
        expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
      });

      test('should have rounded shape', () {
        final shape = theme.snackBarTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(8));
      });
    });

    group('ListTile theme', () {
      test('should have rounded shape', () {
        final shape = theme.listTileTheme.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(8));
      });

      test('should have content padding', () {
        expect(
          theme.listTileTheme.contentPadding,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        );
      });
    });

    group('Divider theme', () {
      test('should have outline variant color', () {
        expect(
          theme.dividerTheme.color,
          theme.colorScheme.outlineVariant,
        );
      });

      test('should have 1px thickness', () {
        expect(theme.dividerTheme.thickness, 1);
      });

      test('should have 1px space', () {
        expect(theme.dividerTheme.space, 1);
      });
    });

    group('Icon theme', () {
      test('should have onSurfaceVariant color', () {
        expect(
          theme.iconTheme.color,
          theme.colorScheme.onSurfaceVariant,
        );
      });

      test('should have 24px size', () {
        expect(theme.iconTheme.size, 24);
      });
    });
  });

  group('AppTheme widget tests', () {
    testWidgets('should apply theme to MaterialApp', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final context = tester.element(find.byType(Scaffold));
      final appliedTheme = Theme.of(context);

      expect(appliedTheme.useMaterial3, isTrue);
    });

    testWidgets('AppBar should use theme styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const SizedBox(),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isNull); // Uses theme default
    });

    testWidgets('Card should use theme styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Card(child: Text('Test')),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('FloatingActionButton should use theme styling',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('TextField should use theme input decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: TextField(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
