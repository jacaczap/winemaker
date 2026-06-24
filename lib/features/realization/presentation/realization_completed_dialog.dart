import 'package:flutter/material.dart';

/// Shows a dialog confirming the realization is finished.
///
/// Returns `true` if the user chose to go back to the realizations list,
/// `false` (or `null`) if they chose to stay on the realization screen.
Future<bool> showRealizationCompletedDialog(BuildContext context) async {
  final goToList = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Realization completed'),
      content: const Text(
        'You have completed every task in this realization.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Stay here'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Back to list'),
        ),
      ],
    ),
  );
  return goToList ?? false;
}
