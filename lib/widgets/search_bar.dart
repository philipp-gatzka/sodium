import 'dart:async';

import 'package:flutter/material.dart';

/// A search bar widget with debounced input.
///
/// Provides a text field with a search icon and clear button.
/// The [onSearch] callback is debounced to prevent excessive calls.
class RecipeSearchBar extends StatefulWidget {
  /// Callback fired when the search query changes (debounced).
  final ValueChanged<String> onSearch;

  /// Debounce duration in milliseconds. Defaults to 300ms.
  final int debounceDuration;

  const RecipeSearchBar({
    super.key,
    required this.onSearch,
    this.debounceDuration = 300,
  });

  @override
  State<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends State<RecipeSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      Duration(milliseconds: widget.debounceDuration),
      () {
        widget.onSearch(value);
      },
    );
  }

  void _onClear() {
    _controller.clear();
    _debounceTimer?.cancel();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onTextChanged,
      decoration: InputDecoration(
        hintText: 'Search recipes...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _onClear,
              tooltip: 'Clear search',
            );
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
