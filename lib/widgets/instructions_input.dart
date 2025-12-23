import 'package:flutter/material.dart';

/// A dynamic input widget for managing a list of recipe instructions.
///
/// Allows users to add, remove, and edit instruction steps.
/// Steps are automatically numbered (1, 2, 3...).
/// At least one instruction field is always visible.
class InstructionsInput extends StatefulWidget {
  /// Initial list of instructions to populate the fields.
  final List<String> initialInstructions;

  /// Callback fired whenever the instructions list changes.
  final ValueChanged<List<String>> onChange;

  const InstructionsInput({
    super.key,
    this.initialInstructions = const [],
    required this.onChange,
  });

  @override
  State<InstructionsInput> createState() => _InstructionsInputState();
}

class _InstructionsInputState extends State<InstructionsInput> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize with existing instructions or one empty field
    if (widget.initialInstructions.isEmpty) {
      _controllers.add(TextEditingController());
    } else {
      for (final instruction in widget.initialInstructions) {
        _controllers.add(TextEditingController(text: instruction));
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    final instructions = _controllers
        .map((c) => c.text)
        .where((text) => text.isNotEmpty)
        .toList();
    widget.onChange(instructions);
  }

  void _addStep() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    _notifyChange();
  }

  void _removeStep(int index) {
    // Don't allow removing the last instruction
    if (_controllers.length <= 1) return;

    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Instructions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...List.generate(_controllers.length, (index) {
          final stepNumber = index + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8, top: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      hintText: 'Describe this step...',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      suffixIcon: _controllers.length > 1
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _removeStep(index),
                              tooltip: 'Remove step',
                            )
                          : null,
                    ),
                    onChanged: (_) => _notifyChange(),
                    maxLines: 3,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addStep,
          icon: const Icon(Icons.add),
          label: const Text('Add Step'),
        ),
      ],
    );
  }
}
