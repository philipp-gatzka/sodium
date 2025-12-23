import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/utils/input_validator.dart';

void main() {
  group('RecipeLimits', () {
    test('should have expected max title length', () {
      expect(RecipeLimits.maxTitleLength, 200);
    });

    test('should have expected max description length', () {
      expect(RecipeLimits.maxDescriptionLength, 2000);
    });

    test('should have expected max ingredients total length', () {
      expect(RecipeLimits.maxIngredientsTotalLength, 5000);
    });

    test('should have expected max instructions total length', () {
      expect(RecipeLimits.maxInstructionsTotalLength, 10000);
    });

    test('should have expected max recipe count', () {
      expect(RecipeLimits.maxRecipeCount, 1000);
    });
  });

  group('ValidationResult', () {
    test('valid result should have isValid true and null errorMessage', () {
      const result = ValidationResult.valid();

      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('invalid result should have isValid false and error message', () {
      const result = ValidationResult.invalid('Test error');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Test error');
    });

    test('toString should return Valid for valid result', () {
      const result = ValidationResult.valid();

      expect(result.toString(), 'Valid');
    });

    test('toString should return Invalid with message for invalid result', () {
      const result = ValidationResult.invalid('Test error');

      expect(result.toString(), 'Invalid: Test error');
    });
  });

  group('InputValidator.validateTitle', () {
    test('should return invalid for null title', () {
      final result = InputValidator.validateTitle(null);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Title is required');
    });

    test('should return invalid for empty title', () {
      final result = InputValidator.validateTitle('');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Title is required');
    });

    test('should return invalid for whitespace-only title', () {
      final result = InputValidator.validateTitle('   ');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Title is required');
    });

    test('should return valid for normal title', () {
      final result = InputValidator.validateTitle('Chocolate Cake');

      expect(result.isValid, isTrue);
    });

    test('should return valid for title at max length', () {
      final title = 'A' * RecipeLimits.maxTitleLength;
      final result = InputValidator.validateTitle(title);

      expect(result.isValid, isTrue);
    });

    test('should return invalid for title exceeding max length', () {
      final title = 'A' * (RecipeLimits.maxTitleLength + 1);
      final result = InputValidator.validateTitle(title);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('200 characters or less'));
    });

    test('should trim whitespace when checking length', () {
      const title = '   A   ';
      final result = InputValidator.validateTitle(title);

      expect(result.isValid, isTrue);
    });
  });

  group('InputValidator.validateDescription', () {
    test('should return valid for null description', () {
      final result = InputValidator.validateDescription(null);

      expect(result.isValid, isTrue);
    });

    test('should return valid for empty description', () {
      final result = InputValidator.validateDescription('');

      expect(result.isValid, isTrue);
    });

    test('should return valid for normal description', () {
      final result = InputValidator.validateDescription('A delicious recipe.');

      expect(result.isValid, isTrue);
    });

    test('should return valid for description at max length', () {
      final description = 'A' * RecipeLimits.maxDescriptionLength;
      final result = InputValidator.validateDescription(description);

      expect(result.isValid, isTrue);
    });

    test('should return invalid for description exceeding max length', () {
      final description = 'A' * (RecipeLimits.maxDescriptionLength + 1);
      final result = InputValidator.validateDescription(description);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('2000 characters or less'));
    });
  });

  group('InputValidator.validateIngredients', () {
    test('should return invalid for null ingredients', () {
      final result = InputValidator.validateIngredients(null);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'At least one ingredient is required');
    });

    test('should return invalid for empty ingredients list', () {
      final result = InputValidator.validateIngredients([]);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'At least one ingredient is required');
    });

    test('should return invalid when all ingredients are empty strings', () {
      final result = InputValidator.validateIngredients(['', '   ', '']);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'At least one ingredient is required');
    });

    test('should return valid for single ingredient', () {
      final result = InputValidator.validateIngredients(['1 cup flour']);

      expect(result.isValid, isTrue);
    });

    test('should return valid for multiple ingredients', () {
      final result = InputValidator.validateIngredients([
        '1 cup flour',
        '2 eggs',
        '1/2 cup sugar',
      ]);

      expect(result.isValid, isTrue);
    });

    test('should filter out empty ingredients when calculating length', () {
      final result = InputValidator.validateIngredients([
        '1 cup flour',
        '',
        '2 eggs',
      ]);

      expect(result.isValid, isTrue);
    });

    test('should return invalid when total length exceeds limit', () {
      // Create ingredients that exceed 5000 chars total
      final longIngredient = 'A' * 2000;
      final result = InputValidator.validateIngredients([
        longIngredient,
        longIngredient,
        longIngredient,
      ]);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('5000 characters or less'));
    });
  });

  group('InputValidator.validateInstructions', () {
    test('should return invalid for null instructions', () {
      final result = InputValidator.validateInstructions(null);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'At least one instruction is required');
    });

    test('should return invalid for empty instructions list', () {
      final result = InputValidator.validateInstructions([]);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'At least one instruction is required');
    });

    test('should return invalid when all instructions are empty strings', () {
      final result = InputValidator.validateInstructions(['', '   ']);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'At least one instruction is required');
    });

    test('should return valid for single instruction', () {
      final result =
          InputValidator.validateInstructions(['Mix all ingredients']);

      expect(result.isValid, isTrue);
    });

    test('should return valid for multiple instructions', () {
      final result = InputValidator.validateInstructions([
        'Preheat oven to 350°F',
        'Mix dry ingredients',
        'Bake for 30 minutes',
      ]);

      expect(result.isValid, isTrue);
    });

    test('should return invalid when total length exceeds limit', () {
      // Create instructions that exceed 10000 chars total
      final longInstruction = 'A' * 4000;
      final result = InputValidator.validateInstructions([
        longInstruction,
        longInstruction,
        longInstruction,
      ]);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('10000 characters or less'));
    });
  });

  group('InputValidator.validatePrepTime', () {
    test('should return valid for null prep time', () {
      final result = InputValidator.validatePrepTime(null);

      expect(result.isValid, isTrue);
    });

    test('should return valid for zero prep time', () {
      final result = InputValidator.validatePrepTime(0);

      expect(result.isValid, isTrue);
    });

    test('should return valid for normal prep time', () {
      final result = InputValidator.validatePrepTime(30);

      expect(result.isValid, isTrue);
    });

    test('should return invalid for negative prep time', () {
      final result = InputValidator.validatePrepTime(-1);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Prep time cannot be negative');
    });

    test('should return invalid for excessively long prep time', () {
      final result = InputValidator.validatePrepTime(20000);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Prep time seems too long');
    });
  });

  group('InputValidator.validateCookTime', () {
    test('should return valid for null cook time', () {
      final result = InputValidator.validateCookTime(null);

      expect(result.isValid, isTrue);
    });

    test('should return valid for zero cook time', () {
      final result = InputValidator.validateCookTime(0);

      expect(result.isValid, isTrue);
    });

    test('should return valid for normal cook time', () {
      final result = InputValidator.validateCookTime(45);

      expect(result.isValid, isTrue);
    });

    test('should return invalid for negative cook time', () {
      final result = InputValidator.validateCookTime(-5);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Cook time cannot be negative');
    });

    test('should return invalid for excessively long cook time', () {
      final result = InputValidator.validateCookTime(15000);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Cook time seems too long');
    });
  });

  group('InputValidator.validateServings', () {
    test('should return valid for null servings', () {
      final result = InputValidator.validateServings(null);

      expect(result.isValid, isTrue);
    });

    test('should return valid for single serving', () {
      final result = InputValidator.validateServings(1);

      expect(result.isValid, isTrue);
    });

    test('should return valid for normal servings', () {
      final result = InputValidator.validateServings(4);

      expect(result.isValid, isTrue);
    });

    test('should return invalid for zero servings', () {
      final result = InputValidator.validateServings(0);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Servings must be at least 1');
    });

    test('should return invalid for negative servings', () {
      final result = InputValidator.validateServings(-1);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Servings must be at least 1');
    });

    test('should return invalid for excessively high servings', () {
      final result = InputValidator.validateServings(1500);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Servings seems too high');
    });
  });

  group('InputValidator.validateCategory', () {
    test('should return invalid for null category', () {
      final result = InputValidator.validateCategory(null);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Category cannot be empty');
    });

    test('should return invalid for empty category', () {
      final result = InputValidator.validateCategory('');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Category cannot be empty');
    });

    test('should return invalid for whitespace-only category', () {
      final result = InputValidator.validateCategory('   ');

      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'Category cannot be empty');
    });

    test('should return valid for normal category', () {
      final result = InputValidator.validateCategory('Dessert');

      expect(result.isValid, isTrue);
    });

    test('should return invalid for category exceeding 50 chars', () {
      final result = InputValidator.validateCategory('A' * 51);

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('50 characters or less'));
    });
  });

  group('InputValidator.isAtRecipeLimit', () {
    test('should return false when under limit', () {
      expect(InputValidator.isAtRecipeLimit(0), isFalse);
      expect(InputValidator.isAtRecipeLimit(500), isFalse);
      expect(InputValidator.isAtRecipeLimit(999), isFalse);
    });

    test('should return true when at limit', () {
      expect(InputValidator.isAtRecipeLimit(1000), isTrue);
    });

    test('should return true when over limit', () {
      expect(InputValidator.isAtRecipeLimit(1001), isTrue);
    });
  });

  group('InputValidator.titleRemainingChars', () {
    test('should return max length for null title', () {
      expect(
        InputValidator.titleRemainingChars(null),
        RecipeLimits.maxTitleLength,
      );
    });

    test('should return max length for empty title', () {
      expect(
        InputValidator.titleRemainingChars(''),
        RecipeLimits.maxTitleLength,
      );
    });

    test('should return correct remaining chars', () {
      expect(
        InputValidator.titleRemainingChars('Hello'),
        RecipeLimits.maxTitleLength - 5,
      );
    });

    test('should return negative when over limit', () {
      final title = 'A' * 210;
      expect(
        InputValidator.titleRemainingChars(title),
        -10,
      );
    });
  });

  group('InputValidator.descriptionRemainingChars', () {
    test('should return max length for null description', () {
      expect(
        InputValidator.descriptionRemainingChars(null),
        RecipeLimits.maxDescriptionLength,
      );
    });

    test('should return correct remaining chars', () {
      expect(
        InputValidator.descriptionRemainingChars('Test'),
        RecipeLimits.maxDescriptionLength - 4,
      );
    });
  });

  group('ErrorMessages', () {
    test('should have loadRecipesFailed message', () {
      expect(ErrorMessages.loadRecipesFailed, isNotEmpty);
    });

    test('should have loadRecipeFailed message', () {
      expect(ErrorMessages.loadRecipeFailed, isNotEmpty);
    });

    test('should have saveRecipeFailed message', () {
      expect(ErrorMessages.saveRecipeFailed, isNotEmpty);
    });

    test('should have deleteRecipeFailed message', () {
      expect(ErrorMessages.deleteRecipeFailed, isNotEmpty);
    });

    test('should have searchFailed message', () {
      expect(ErrorMessages.searchFailed, isNotEmpty);
    });

    test('should have recipeNotFound message', () {
      expect(ErrorMessages.recipeNotFound, isNotEmpty);
    });

    test('should have recipeLimitReached message', () {
      expect(ErrorMessages.recipeLimitReached, isNotEmpty);
    });

    test('should have unexpectedError message', () {
      expect(ErrorMessages.unexpectedError, isNotEmpty);
    });

    test('fromError should return unexpectedError', () {
      expect(
        ErrorMessages.fromError(Exception('test')),
        ErrorMessages.unexpectedError,
      );
    });
  });
}
