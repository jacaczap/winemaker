import 'package:flutter/material.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// What the user chose after finishing a realization.
enum RealizationCompletedAction { backToList, showSummary }

/// Shows a dialog confirming the realization is finished.
///
/// Null when the user dismissed it without choosing, which leaves them on the
/// step list.
Future<RealizationCompletedAction?> showRealizationCompletedDialog(
  BuildContext context,
) {
  final l10n = AppLocalizations.of(context);
  return showDialog<RealizationCompletedAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.realizationCompletedTitle),
      content: Text(l10n.realizationCompletedMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(RealizationCompletedAction.backToList),
          child: Text(l10n.backToList),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context)
              .pop(RealizationCompletedAction.showSummary),
          child: Text(l10n.showSummary),
        ),
      ],
    ),
  );
}
