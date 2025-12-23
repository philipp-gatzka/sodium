import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../utils/input_validator.dart';
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
  bool _isLoading = false;
  String? _loadError;

  bool get isEditMode => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadRecipe();
    }
  }

  Future<void> _loadRecipe() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final repository = ref.read(recipeRepositoryProvider);
      final recipe = await repository.getRecipeById(widget.recipeId!);
      if (recipe != null && mounted) {
        setState(() {
          _titleController.text = recipe.title;
          _ingredients = List.from(recipe.ingredients);
          _instructions = List.from(recipe.instructions);
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _loadError = ErrorMessages.recipeNotFound;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = ErrorMessages.loadRecipeFailed;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate ingredients
    final ingredientsResult = InputValidator.validateIngredients(_ingredients);
    if (!ingredientsResult.isValid) {
      _showErrorSnackBar(ingredientsResult.errorMessage!);
      return;
    }

    // Validate instructions
    final instructionsResult =
        InputValidator.validateInstructions(_instructions);
    if (!instructionsResult.isValid) {
      _showErrorSnackBar(instructionsResult.errorMessage!);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(recipeRepositoryProvider);

      // Check recipe limit for new recipes
      if (!isEditMode) {
        final currentCount = await repository.getRecipeCount();
        if (InputValidator.isAtRecipeLimit(currentCount)) {
          _showErrorSnackBar(ErrorMessages.recipeLimitReached);
          setState(() {
            _isSaving = false;
          });
          return;
        }
      }

      final recipe = Recipe()
        ..title = _titleController.text.trim()
        ..ingredients = _ingredients.where((i) => i.trim().isNotEmpty).toList()
        ..instructions =
            _instructions.where((i) => i.trim().isNotEmpty).toList();

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
        _showErrorSnackBar(ErrorMessages.saveRecipeFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  String? _validateTitle(String? value) {
    final result = InputValidator.validateTitle(value);
    return result.isValid ? null : result.errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Recipe' : 'New Recipe'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Recipe' : 'New Recipe'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                _loadError!,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadRecipe,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
                decoration: InputDecoration(
                  labelText: 'Recipe Title',
                  hintText: 'Enter recipe name',
                  border: const OutlineInputBorder(),
                  counterText:
                      '${_titleController.text.length}/${RecipeLimits.maxTitleLength}',
                ),
                maxLength: RecipeLimits.maxTitleLength,
                validator: _validateTitle,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  // Trigger rebuild to update counter
                  setState(() {});
                },
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
