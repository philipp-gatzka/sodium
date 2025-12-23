import 'package:flutter/material.dart';

/// A widget that displays an empty state with an icon and message.
///
/// Used when there is no content to display, such as when
/// the recipe list is empty.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String primaryMessage;
  final String? secondaryMessage;

  const EmptyState({
    super.key,
    required this.icon,
    required this.primaryMessage,
    this.secondaryMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              primaryMessage,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (secondaryMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                secondaryMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
