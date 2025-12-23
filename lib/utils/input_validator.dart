/// Validation limits for recipe fields.
class RecipeLimits {
  static const int maxTitleLength = 200;
  static const int maxDescriptionLength = 2000;
  static const int maxIngredientsTotalLength = 5000;
  static const int maxInstructionsTotalLength = 10000;
  static const int maxRecipeCount = 1000;
  static const int minIngredients = 1;
  static const int minInstructions = 1;

  const RecipeLimits._();
}

/// Result of a validation operation.
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.valid()
      : isValid = true,
        errorMessage = null;

  const ValidationResult.invalid(this.errorMessage) : isValid = false;

  @override
  String toString() => isValid ? 'Valid' : 'Invalid: $errorMessage';
}

/// Utility class for validating recipe input.
class InputValidator {
  const InputValidator._();

  /// Validates the recipe title.
  static ValidationResult validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return const ValidationResult.invalid('Title is required');
    }

    final trimmed = title.trim();
    if (trimmed.length > RecipeLimits.maxTitleLength) {
      return const ValidationResult.invalid(
        'Title must be ${RecipeLimits.maxTitleLength} characters or less',
      );
    }

    return const ValidationResult.valid();
  }

  /// Validates the recipe description.
  static ValidationResult validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return const ValidationResult.valid(); // Optional field
    }

    if (description.length > RecipeLimits.maxDescriptionLength) {
      return const ValidationResult.invalid(
        'Description must be ${RecipeLimits.maxDescriptionLength} characters or less',
      );
    }

    return const ValidationResult.valid();
  }

  /// Validates the ingredients list.
  static ValidationResult validateIngredients(List<String>? ingredients) {
    if (ingredients == null || ingredients.isEmpty) {
      return const ValidationResult.invalid(
          'At least one ingredient is required');
    }

    // Filter out empty ingredients
    final nonEmptyIngredients =
        ingredients.where((i) => i.trim().isNotEmpty).toList();

    if (nonEmptyIngredients.isEmpty) {
      return const ValidationResult.invalid(
          'At least one ingredient is required');
    }

    final totalLength =
        nonEmptyIngredients.fold<int>(0, (sum, i) => sum + i.length);
    if (totalLength > RecipeLimits.maxIngredientsTotalLength) {
      return const ValidationResult.invalid(
        'Total ingredients text must be ${RecipeLimits.maxIngredientsTotalLength} characters or less',
      );
    }

    return const ValidationResult.valid();
  }

  /// Validates the instructions list.
  static ValidationResult validateInstructions(List<String>? instructions) {
    if (instructions == null || instructions.isEmpty) {
      return const ValidationResult.invalid(
          'At least one instruction is required');
    }

    // Filter out empty instructions
    final nonEmptyInstructions =
        instructions.where((i) => i.trim().isNotEmpty).toList();

    if (nonEmptyInstructions.isEmpty) {
      return const ValidationResult.invalid(
          'At least one instruction is required');
    }

    final totalLength =
        nonEmptyInstructions.fold<int>(0, (sum, i) => sum + i.length);
    if (totalLength > RecipeLimits.maxInstructionsTotalLength) {
      return const ValidationResult.invalid(
        'Total instructions text must be ${RecipeLimits.maxInstructionsTotalLength} characters or less',
      );
    }

    return const ValidationResult.valid();
  }

  /// Validates prep time in minutes.
  static ValidationResult validatePrepTime(int? minutes) {
    if (minutes == null) {
      return const ValidationResult.valid(); // Optional field
    }

    if (minutes < 0) {
      return const ValidationResult.invalid('Prep time cannot be negative');
    }

    if (minutes > 10080) {
      // 7 days in minutes
      return const ValidationResult.invalid('Prep time seems too long');
    }

    return const ValidationResult.valid();
  }

  /// Validates cook time in minutes.
  static ValidationResult validateCookTime(int? minutes) {
    if (minutes == null) {
      return const ValidationResult.valid(); // Optional field
    }

    if (minutes < 0) {
      return const ValidationResult.invalid('Cook time cannot be negative');
    }

    if (minutes > 10080) {
      // 7 days in minutes
      return const ValidationResult.invalid('Cook time seems too long');
    }

    return const ValidationResult.valid();
  }

  /// Validates servings count.
  static ValidationResult validateServings(int? servings) {
    if (servings == null) {
      return const ValidationResult.valid(); // Optional field
    }

    if (servings < 1) {
      return const ValidationResult.invalid('Servings must be at least 1');
    }

    if (servings > 1000) {
      return const ValidationResult.invalid('Servings seems too high');
    }

    return const ValidationResult.valid();
  }

  /// Validates category name.
  static ValidationResult validateCategory(String? category) {
    if (category == null || category.trim().isEmpty) {
      return const ValidationResult.invalid('Category cannot be empty');
    }

    if (category.trim().length > 50) {
      return const ValidationResult.invalid(
        'Category must be 50 characters or less',
      );
    }

    return const ValidationResult.valid();
  }

  /// Checks if the recipe count is at or over the limit.
  static bool isAtRecipeLimit(int currentCount) {
    return currentCount >= RecipeLimits.maxRecipeCount;
  }

  /// Returns the remaining characters for a title.
  static int titleRemainingChars(String? title) {
    final length = title?.length ?? 0;
    return RecipeLimits.maxTitleLength - length;
  }

  /// Returns the remaining characters for a description.
  static int descriptionRemainingChars(String? description) {
    final length = description?.length ?? 0;
    return RecipeLimits.maxDescriptionLength - length;
  }
}

/// User-friendly error messages for common operations.
class ErrorMessages {
  static const String loadRecipesFailed =
      'Failed to load recipes. Please try again.';
  static const String loadRecipeFailed =
      'Failed to load recipe. Please try again.';
  static const String loadFavoritesFailed =
      'Failed to load favorites. Please try again.';
  static const String saveRecipeFailed =
      'Unable to save recipe. Please check your input and try again.';
  static const String deleteRecipeFailed =
      'Failed to delete recipe. Please try again.';
  static const String searchFailed = 'Search failed. Please try again.';
  static const String recipeNotFound =
      'Recipe not found. It may have been deleted.';
  static const String recipeLimitReached =
      'You have reached the maximum number of recipes (${RecipeLimits.maxRecipeCount}). '
      'Please delete some recipes before adding new ones.';
  static const String unexpectedError =
      'Something went wrong. Please try again later.';

  const ErrorMessages._();

  /// Converts any error to a user-friendly message.
  static String fromError(Object error) {
    // Log the actual error for debugging (in production, use proper logging)
    // print('Error: $error');

    // Return generic user-friendly message
    return unexpectedError;
  }
}
