import 'package:flutter/material.dart';

import '../models/recipe.dart';

/// A card widget that displays a recipe preview.
///
/// Shows the recipe title and a preview of ingredients.
/// The entire card is tappable and triggers the [onTap] callback.
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  String _buildIngredientPreview() {
    if (recipe.ingredients.isEmpty) {
      return 'No ingredients';
    }

    final count = recipe.ingredients.length;
    if (count == 1) {
      return '1 ingredient';
    }
    return '$count ingredients';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (recipe.isFavorite)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.favorite,
                        size: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _buildIngredientPreview(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
