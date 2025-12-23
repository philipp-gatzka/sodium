import 'package:flutter/material.dart';

/// A horizontally scrollable row of filter chips for categories.
///
/// Shows an "All" chip followed by category chips.
/// Selecting a category filters the recipe list.
class CategoryFilterChips extends StatelessWidget {
  /// List of available categories to display as chips.
  final List<String> categories;

  /// Currently selected category, or null for "All".
  final String? selectedCategory;

  /// Callback when a category is selected.
  /// Passes null when "All" is selected.
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" chip
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            final isSelected = selectedCategory == null;
            return FilterChip(
              label: const Text('All'),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(null),
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategory == category;

          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
          );
        },
      ),
    );
  }
}
