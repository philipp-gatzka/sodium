import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/providers/settings_provider.dart';

void main() {
  group('themeModeProvider', () {
    test('should have system as default value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final themeMode = container.read(themeModeProvider);

      expect(themeMode, ThemeMode.system);
    });

    test('should allow setting to light mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).state = ThemeMode.light;

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('should allow setting to dark mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).state = ThemeMode.dark;

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('should allow setting back to system mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).state = ThemeMode.dark;
      container.read(themeModeProvider.notifier).state = ThemeMode.system;

      expect(container.read(themeModeProvider), ThemeMode.system);
    });
  });
}
