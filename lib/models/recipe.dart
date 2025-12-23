import 'package:isar/isar.dart';

part 'recipe.g.dart';

/// Difficulty levels for recipes.
enum RecipeDifficulty {
  easy,
  medium,
  hard,
}

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  late String title;

  /// Optional description or summary of the recipe.
  String? description;

  late List<String> ingredients;

  late List<String> instructions;

  /// Preparation time in minutes.
  int? prepTimeMinutes;

  /// Cooking time in minutes.
  int? cookTimeMinutes;

  /// Number of servings this recipe yields.
  int? servings;

  /// Recipe difficulty level (null = unspecified, 0 = easy, 1 = medium, 2 = hard).
  /// Stored as byte in Isar (0-3 where 0 = unspecified).
  @Index()
  byte difficultyValue = 0;

  /// Get difficulty as enum (null if unspecified).
  @ignore
  RecipeDifficulty? get difficulty {
    if (difficultyValue == 0) return null;
    return RecipeDifficulty.values[difficultyValue - 1];
  }

  /// Set difficulty from enum.
  set difficulty(RecipeDifficulty? value) {
    difficultyValue = value == null ? 0 : value.index + 1;
  }

  /// Whether this recipe is marked as a favorite.
  @Index()
  bool isFavorite = false;

  /// Categories/tags for organizing recipes.
  @Index(type: IndexType.value, caseSensitive: false)
  List<String> categories = [];

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns the total time (prep + cook) in minutes.
  int? get totalTimeMinutes {
    if (prepTimeMinutes == null && cookTimeMinutes == null) return null;
    return (prepTimeMinutes ?? 0) + (cookTimeMinutes ?? 0);
  }

  /// Returns a formatted string for the total time.
  String? get formattedTotalTime {
    final total = totalTimeMinutes;
    if (total == null) return null;
    if (total < 60) return '$total min';
    final hours = total ~/ 60;
    final mins = total % 60;
    if (mins == 0) return '$hours hr';
    return '$hours hr $mins min';
  }

  /// Returns the difficulty as a display string.
  String? get difficultyDisplay {
    if (difficulty == null) return null;
    switch (difficulty!) {
      case RecipeDifficulty.easy:
        return 'Easy';
      case RecipeDifficulty.medium:
        return 'Medium';
      case RecipeDifficulty.hard:
        return 'Hard';
    }
  }
}
