import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for creating or editing a recipe.
///
/// When [recipeId] is null, the screen is in create mode.
/// When [recipeId] is provided, the screen is in edit mode.
class RecipeEditScreen extends ConsumerStatefulWidget {
  final int? recipeId;

  const RecipeEditScreen({
    super.key,
    this.recipeId,
  });

  @override
  ConsumerState<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends ConsumerState<RecipeEditScreen> {
  bool get isEditMode => widget.recipeId != null;

  void _onSave() {
    // TODO: Implement save functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Recipe' : 'New Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onSave,
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: Add form fields
            Center(
              child: Text('Recipe form will go here'),
            ),
          ],
        ),
      ),
    );
  }
}
