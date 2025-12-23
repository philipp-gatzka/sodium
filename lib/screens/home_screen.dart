import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe_provider.dart';
import '../utils/input_validator.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/sort_bottom_sheet.dart';
import 'recipe_detail_screen.dart';
import 'recipe_edit_screen.dart';

/// Provider to track the current search query.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// The main home screen displaying the list of recipes.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final currentSortOption = ref.watch(sortOptionProvider);

    // Determine which provider to use based on filters
    final AsyncValue<List> recipesAsync;
    if (showFavoritesOnly && searchQuery.isEmpty) {
      recipesAsync = ref.watch(favoriteRecipesProvider);
    } else if (searchQuery.isNotEmpty) {
      recipesAsync = ref.watch(recipeSearchProvider(searchQuery));
    } else if (selectedCategory != null) {
      recipesAsync = ref.watch(recipesByCategoryProvider(selectedCategory));
    } else {
      // Use sorted recipes provider for the main list
      recipesAsync = ref.watch(sortedRecipesProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () async {
              final selected = await SortBottomSheet.show(
                context: context,
                currentOption: currentSortOption,
              );
              if (selected != null) {
                ref.read(sortOptionProvider.notifier).state = selected;
              }
            },
            tooltip: 'Sort recipes',
          ),
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: showFavoritesOnly
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
            onPressed: () {
              ref.read(showFavoritesOnlyProvider.notifier).state =
                  !showFavoritesOnly;
            },
            tooltip:
                showFavoritesOnly ? 'Show all recipes' : 'Show favorites only',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const RecipeEditScreen(),
            ),
          );
          // Refresh the list after returning
          ref.invalidate(recipesProvider);
          ref.invalidate(sortedRecipesProvider);
          ref.invalidate(favoriteRecipesProvider);
          ref.invalidate(allCategoriesProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: RecipeSearchBar(
              onSearch: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
                // Clear category filter when searching
                if (query.isNotEmpty) {
                  ref.read(selectedCategoryProvider.notifier).state = null;
                }
              },
            ),
          ),
          // Show category filter chips when not searching and not showing favorites only
          if (searchQuery.isEmpty && !showFavoritesOnly)
            categoriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (categories) => categories.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CategoryFilterChips(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) {
                          ref.read(selectedCategoryProvider.notifier).state =
                              category;
                        },
                      ),
                    ),
            ),
          Expanded(
            child: recipesAsync.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => Center(
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
                      showFavoritesOnly
                          ? ErrorMessages.loadFavoritesFailed
                          : searchQuery.isNotEmpty
                              ? ErrorMessages.searchFailed
                              : ErrorMessages.loadRecipesFailed,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (showFavoritesOnly) {
                          ref.invalidate(favoriteRecipesProvider);
                        } else if (searchQuery.isNotEmpty) {
                          ref.invalidate(recipeSearchProvider(searchQuery));
                        } else {
                          ref.invalidate(sortedRecipesProvider);
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (recipes) {
                if (recipes.isEmpty) {
                  if (searchQuery.isNotEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off,
                      primaryMessage: 'No recipes found',
                      secondaryMessage: 'Try a different search term',
                    );
                  }
                  if (showFavoritesOnly) {
                    return const EmptyState(
                      icon: Icons.favorite_border,
                      primaryMessage: 'No favorites yet',
                      secondaryMessage:
                          'Tap the heart icon on a recipe to add it to favorites',
                    );
                  }
                  if (selectedCategory != null) {
                    return EmptyState(
                      icon: Icons.category_outlined,
                      primaryMessage: 'No recipes in this category',
                      secondaryMessage:
                          'Add recipes to "$selectedCategory" or select a different category',
                    );
                  }
                  return const EmptyState(
                    icon: Icons.restaurant_menu,
                    primaryMessage: 'No recipes yet',
                    secondaryMessage: 'Tap + to add your first recipe',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RecipeCard(
                        recipe: recipe,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(recipeId: recipe.id),
                            ),
                          );
                          // Refresh the list after returning (recipe might have been deleted or favorited)
                          ref.invalidate(recipesProvider);
                          ref.invalidate(sortedRecipesProvider);
                          ref.invalidate(favoriteRecipesProvider);
                          ref.invalidate(allCategoriesProvider);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
