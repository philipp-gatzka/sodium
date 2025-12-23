import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
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
    final recipesAsync = searchQuery.isEmpty
        ? ref.watch(recipesProvider)
        : ref.watch(recipeSearchProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
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
              },
            ),
          ),
          Expanded(
            child: recipesAsync.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
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
                          // Refresh the list after returning (recipe might have been deleted)
                          ref.invalidate(recipesProvider);
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
