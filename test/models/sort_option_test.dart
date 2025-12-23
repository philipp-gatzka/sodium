import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/models/sort_option.dart';

void main() {
  group('RecipeSortOption', () {
    test('should have 6 sort options', () {
      expect(RecipeSortOption.values.length, 6);
    });

    test('should contain all expected values', () {
      expect(
        RecipeSortOption.values,
        containsAll([
          RecipeSortOption.newestFirst,
          RecipeSortOption.oldestFirst,
          RecipeSortOption.titleAZ,
          RecipeSortOption.titleZA,
          RecipeSortOption.quickestFirst,
          RecipeSortOption.favoritesFirst,
        ]),
      );
    });
  });

  group('RecipeSortOptionExtension', () {
    test('displayName should return correct strings', () {
      expect(RecipeSortOption.newestFirst.displayName, 'Newest first');
      expect(RecipeSortOption.oldestFirst.displayName, 'Oldest first');
      expect(RecipeSortOption.titleAZ.displayName, 'Title (A-Z)');
      expect(RecipeSortOption.titleZA.displayName, 'Title (Z-A)');
      expect(RecipeSortOption.quickestFirst.displayName, 'Quickest first');
      expect(RecipeSortOption.favoritesFirst.displayName, 'Favorites first');
    });

    test('iconName should return non-empty strings', () {
      for (final option in RecipeSortOption.values) {
        expect(option.iconName, isNotEmpty);
      }
    });
  });
}
