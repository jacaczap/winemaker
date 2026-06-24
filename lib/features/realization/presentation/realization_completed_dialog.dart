import 'package:flutter/material.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Shows a dialog confirming the realization is finished.
///
/// Returns `true` if the user chose to go back to the realizations list,
/// `false` (or `null`) if they chose to stay on the realization screen.
Future<bool> showRealizationCompletedDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final goToList = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.realizationCompletedTitle),
      content: Text(l10n.realizationCompletedMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.stayHere),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.backToList),
        ),
      ],
    ),
  );
  return goToList ?? false;
}
