import 'package:flutter/material.dart';

/// Predefined categories for recipes.
const List<String> defaultCategories = [
  'Breakfast',
  'Lunch',
  'Dinner',
  'Dessert',
  'Snack',
  'Appetizer',
  'Beverage',
  'Side Dish',
  'Soup',
  'Salad',
];

/// A widget for selecting multiple categories for a recipe.
///
/// Displays predefined category chips that can be toggled on/off.
/// Also allows adding custom categories via a text field.
class CategorySelector extends StatefulWidget {
  /// The initially selected categories.
  final List<String> selectedCategories;

  /// Callback when the selected categories change.
  final ValueChanged<List<String>> onChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategories,
    required this.onChanged,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<String> _selected;
  final _customCategoryController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedCategories);
  }

  @override
  void didUpdateWidget(CategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategories != widget.selectedCategories) {
      _selected = List.from(widget.selectedCategories);
    }
  }

  @override
  void dispose() {
    _customCategoryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selected.contains(category)) {
        _selected.remove(category);
      } else {
        _selected.add(category);
      }
    });
    widget.onChanged(List.from(_selected));
  }

  void _addCustomCategory() {
    final custom = _customCategoryController.text.trim();
    if (custom.isNotEmpty && !_selected.contains(custom)) {
      setState(() {
        _selected.add(custom);
      });
      widget.onChanged(List.from(_selected));
      _customCategoryController.clear();
    }
    _focusNode.unfocus();
  }

  /// Get all categories to display (predefined + any custom ones selected).
  List<String> get _allCategories {
    final all = <String>{...defaultCategories};
    for (final cat in _selected) {
      all.add(cat);
    }
    return all.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Select categories for this recipe (optional)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allCategories.map((category) {
            final isSelected = _selected.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => _toggleCategory(category),
              checkmarkColor: theme.colorScheme.onPrimaryContainer,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customCategoryController,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  labelText: 'Add custom category',
                  hintText: 'Type a category name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addCustomCategory(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.add),
              onPressed: _addCustomCategory,
              tooltip: 'Add category',
            ),
          ],
        ),
      ],
    );
  }
}
