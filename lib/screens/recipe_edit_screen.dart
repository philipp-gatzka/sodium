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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  bool get isEditMode => widget.recipeId != null;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a recipe title';
    }
    return null;
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Title',
                  hintText: 'Enter recipe name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateTitle,
                textInputAction: TextInputAction.next,
              ),
              // TODO: Add more form fields
            ],
          ),
        ),
      ),
    );
  }
}
