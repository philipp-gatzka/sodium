import 'package:flutter/material.dart';

/// A dynamic input widget for managing a list of ingredients.
///
/// Allows users to add, remove, and edit ingredients.
/// At least one ingredient field is always visible.
class IngredientsInput extends StatefulWidget {
  /// Initial list of ingredients to populate the fields.
  final List<String> initialIngredients;

  /// Callback fired whenever the ingredients list changes.
  final ValueChanged<List<String>> onChange;

  const IngredientsInput({
    super.key,
    this.initialIngredients = const [],
    required this.onChange,
  });

  @override
  State<IngredientsInput> createState() => _IngredientsInputState();
}

class _IngredientsInputState extends State<IngredientsInput> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize with existing ingredients or one empty field
    if (widget.initialIngredients.isEmpty) {
      _controllers.add(TextEditingController());
    } else {
      for (final ingredient in widget.initialIngredients) {
        _controllers.add(TextEditingController(text: ingredient));
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    final ingredients = _controllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();
    widget.onChange(ingredients);
  }

  void _addIngredient() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    _notifyChange();
  }

  void _removeIngredient(int index) {
    // Don't allow removing the last ingredient
    if (_controllers.length <= 1) return;

    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ingredients',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...List.generate(_controllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      hintText: 'e.g., 2 cups flour',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      suffixIcon: _controllers.length > 1
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _removeIngredient(index),
                              tooltip: 'Remove ingredient',
                            )
                          : null,
                    ),
                    onChanged: (_) => _notifyChange(),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addIngredient,
          icon: const Icon(Icons.add),
          label: const Text('Add Ingredient'),
        ),
      ],
    );
  }
}
