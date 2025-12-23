import 'package:flutter/material.dart';

import '../models/sort_option.dart';

/// A bottom sheet widget for selecting recipe sort options.
class SortBottomSheet extends StatelessWidget {
  /// The currently selected sort option.
  final RecipeSortOption selectedOption;

  /// Callback when a sort option is selected.
  final ValueChanged<RecipeSortOption> onOptionSelected;

  const SortBottomSheet({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  /// Shows the sort bottom sheet and returns the selected option.
  static Future<RecipeSortOption?> show({
    required BuildContext context,
    required RecipeSortOption currentOption,
  }) {
    return showModalBottomSheet<RecipeSortOption>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SortBottomSheet(
        selectedOption: currentOption,
        onOptionSelected: (option) => Navigator.of(context).pop(option),
      ),
    );
  }

  IconData _getIconForOption(RecipeSortOption option) {
    switch (option) {
      case RecipeSortOption.newestFirst:
        return Icons.schedule;
      case RecipeSortOption.oldestFirst:
        return Icons.history;
      case RecipeSortOption.titleAZ:
        return Icons.sort_by_alpha;
      case RecipeSortOption.titleZA:
        return Icons.sort_by_alpha;
      case RecipeSortOption.quickestFirst:
        return Icons.timer;
      case RecipeSortOption.favoritesFirst:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Sort by',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          ...RecipeSortOption.values.map((option) {
            final isSelected = option == selectedOption;
            return ListTile(
              leading: Icon(
                _getIconForOption(option),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text(
                option.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => onOptionSelected(option),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
