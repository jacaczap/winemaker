import 'package:flutter/material.dart';

/// Action shown on a completed task opened read-only.
///
/// Popping [TaskScreenResult.redo] lets the realization view jump back to this
/// task, discarding the data of all later tasks (after confirmation).
class RedoFromHereButton extends StatelessWidget {
  const RedoFromHereButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: const Icon(Icons.restart_alt),
      label: const Text('Redo from here'),
    );
  }
}
