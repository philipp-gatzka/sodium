import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

/// The main home screen displaying the list of recipes.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to recipe edit screen (create mode)
        },
        child: const Icon(Icons.add),
      ),
      body: recipesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text('No recipes yet. Add your first recipe!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    // TODO: Navigate to recipe detail screen
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
