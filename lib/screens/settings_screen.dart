import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

/// Screen for managing app settings.
///
/// Allows users to change theme mode (light, dark, system).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Appearance'),
          _ThemeModeSelector(
            currentMode: themeMode,
            onModeSelected: (mode) {
              ref.read(themeModeProvider.notifier).state = mode;
            },
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}

/// Section header widget for settings groups.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// Widget for selecting theme mode.
class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onModeSelected;

  const _ThemeModeSelector({
    required this.currentMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ThemeModeOption(
          icon: Icons.brightness_auto,
          title: 'System',
          subtitle: 'Follow system theme',
          isSelected: currentMode == ThemeMode.system,
          onTap: () => onModeSelected(ThemeMode.system),
        ),
        _ThemeModeOption(
          icon: Icons.light_mode,
          title: 'Light',
          subtitle: 'Always use light theme',
          isSelected: currentMode == ThemeMode.light,
          onTap: () => onModeSelected(ThemeMode.light),
        ),
        _ThemeModeOption(
          icon: Icons.dark_mode,
          title: 'Dark',
          subtitle: 'Always use dark theme',
          isSelected: currentMode == ThemeMode.dark,
          onTap: () => onModeSelected(ThemeMode.dark),
        ),
      ],
    );
  }
}

/// Individual theme mode option tile.
class _ThemeModeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
