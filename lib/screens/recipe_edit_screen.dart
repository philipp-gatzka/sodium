import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/ingredients_input.dart';
import '../widgets/instructions_input.dart';

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
  List<String> _ingredients = [];
  List<String> _instructions = [];
  bool _isSaving = false;

  bool get isEditMode => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadRecipe();
    }
  }

  Future<void> _loadRecipe() async {
    final repository = ref.read(recipeRepositoryProvider);
    final recipe = await repository.getRecipeById(widget.recipeId!);
    if (recipe != null && mounted) {
      setState(() {
        _titleController.text = recipe.title;
        _ingredients = List.from(recipe.ingredients);
        _instructions = List.from(recipe.instructions);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(recipeRepositoryProvider);

      final recipe = Recipe()
        ..title = _titleController.text.trim()
        ..ingredients = _ingredients
        ..instructions = _instructions;

      if (isEditMode) {
        recipe.id = widget.recipeId!;
        await repository.updateRecipe(recipe);
      } else {
        await repository.addRecipe(recipe);
      }

      // Invalidate the recipes provider to refresh the list
      ref.invalidate(recipesProvider);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save recipe: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
            icon: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            onPressed: _isSaving ? null : _onSave,
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
              const SizedBox(height: 24),
              IngredientsInput(
                initialIngredients: _ingredients,
                onChange: (ingredients) {
                  _ingredients = ingredients;
                },
              ),
              const SizedBox(height: 24),
              InstructionsInput(
                initialInstructions: _instructions,
                onChange: (instructions) {
                  _instructions = instructions;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
