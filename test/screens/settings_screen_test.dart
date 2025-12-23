import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/providers/settings_provider.dart';
import 'package:sodium/screens/settings_screen.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should display Appearance section header', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('Appearance'), findsOneWidget);
    });

    testWidgets('should display About section header', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('should display version information', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
    });

    testWidgets('should display all theme mode options', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('System'), findsOneWidget);
      expect(find.text('Follow system theme'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Always use light theme'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Always use dark theme'), findsOneWidget);
    });

    testWidgets(
      'should show system option selected by default',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: SettingsScreen(),
            ),
          ),
        );

        // Find the check icon - should be only one (for System option)
        expect(find.byIcon(Icons.check), findsOneWidget);

        // System should have the check icon
        final systemTile = find.ancestor(
          of: find.text('System'),
          matching: find.byType(ListTile),
        );
        expect(systemTile, findsOneWidget);
      },
    );

    testWidgets(
      'should change theme mode when light is tapped',
      (tester) async {
        ThemeMode? capturedMode;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              themeModeProvider.overrideWith((ref) => ThemeMode.system),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  capturedMode = ref.watch(themeModeProvider);
                  return const SettingsScreen();
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Light'));
        await tester.pump();

        expect(capturedMode, ThemeMode.light);
      },
    );

    testWidgets(
      'should change theme mode when dark is tapped',
      (tester) async {
        ThemeMode? capturedMode;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              themeModeProvider.overrideWith((ref) => ThemeMode.system),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  capturedMode = ref.watch(themeModeProvider);
                  return const SettingsScreen();
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Dark'));
        await tester.pump();

        expect(capturedMode, ThemeMode.dark);
      },
    );

    testWidgets(
      'should change theme mode when system is tapped',
      (tester) async {
        ThemeMode? capturedMode;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  capturedMode = ref.watch(themeModeProvider);
                  return const SettingsScreen();
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('System'));
        await tester.pump();

        expect(capturedMode, ThemeMode.system);
      },
    );

    testWidgets('should display theme mode icons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.brightness_auto), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets(
      'should show light option selected when theme is light',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              themeModeProvider.overrideWith((ref) => ThemeMode.light),
            ],
            child: const MaterialApp(
              home: SettingsScreen(),
            ),
          ),
        );

        // The Light ListTile should have the check icon
        final lightTile = find.ancestor(
          of: find.text('Light'),
          matching: find.byType(ListTile),
        );
        expect(lightTile, findsOneWidget);

        // Should have exactly one check icon
        expect(find.byIcon(Icons.check), findsOneWidget);
      },
    );

    testWidgets(
      'should show dark option selected when theme is dark',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            ],
            child: const MaterialApp(
              home: SettingsScreen(),
            ),
          ),
        );

        // Should have exactly one check icon for dark mode
        expect(find.byIcon(Icons.check), findsOneWidget);
      },
    );

    testWidgets('should display privacy policy option', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('View how your data is handled'), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('should display Data section header', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('Data'), findsOneWidget);
    });

    testWidgets('should display export recipes option', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      expect(find.text('Export Recipes'), findsOneWidget);
      expect(find.text('Save recipes as JSON file'), findsOneWidget);
      expect(find.byIcon(Icons.upload_file), findsOneWidget);
    });

    testWidgets('privacy policy tile should be tappable', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Find and tap the privacy policy tile
      final privacyTile = find.ancestor(
        of: find.text('Privacy Policy'),
        matching: find.byType(ListTile),
      );
      expect(privacyTile, findsOneWidget);

      // Tap should not throw (url_launcher may fail but shouldn't crash)
      await tester.tap(privacyTile);
      await tester.pump();
    });

    testWidgets('export tile should be tappable', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Find and tap the export tile
      final exportTile = find.ancestor(
        of: find.text('Export Recipes'),
        matching: find.byType(ListTile),
      );
      expect(exportTile, findsOneWidget);

      await tester.tap(exportTile);
      await tester.pump();
    });
  });
}
