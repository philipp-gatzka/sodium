/// Available options for sorting recipes.
enum RecipeSortOption {
  /// Newest recipes first (by creation date).
  newestFirst,

  /// Oldest recipes first (by creation date).
  oldestFirst,

  /// Alphabetically A to Z by title.
  titleAZ,

  /// Alphabetically Z to A by title.
  titleZA,

  /// Quickest recipes first (by total time).
  quickestFirst,

  /// Favorite recipes first, then by date.
  favoritesFirst,
}

/// Extension to provide display names for sort options.
extension RecipeSortOptionExtension on RecipeSortOption {
  /// Returns a human-readable display name for the sort option.
  String get displayName {
    switch (this) {
      case RecipeSortOption.newestFirst:
        return 'Newest first';
      case RecipeSortOption.oldestFirst:
        return 'Oldest first';
      case RecipeSortOption.titleAZ:
        return 'Title (A-Z)';
      case RecipeSortOption.titleZA:
        return 'Title (Z-A)';
      case RecipeSortOption.quickestFirst:
        return 'Quickest first';
      case RecipeSortOption.favoritesFirst:
        return 'Favorites first';
    }
  }

  /// Returns an icon for the sort option.
  String get iconName {
    switch (this) {
      case RecipeSortOption.newestFirst:
        return 'schedule';
      case RecipeSortOption.oldestFirst:
        return 'history';
      case RecipeSortOption.titleAZ:
        return 'sort_by_alpha';
      case RecipeSortOption.titleZA:
        return 'sort_by_alpha';
      case RecipeSortOption.quickestFirst:
        return 'timer';
      case RecipeSortOption.favoritesFirst:
        return 'favorite';
    }
  }
}
