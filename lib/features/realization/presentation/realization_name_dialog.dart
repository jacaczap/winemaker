import 'package:flutter/material.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Shows a dialog to name a realization, when creating it or later.
///
/// [currentName] is the text the field starts with. Returns the trimmed name,
/// falling back to [currentName] if the user cleared it, or `null` if the user
/// cancelled.
Future<String?> showRealizationNameDialog(
  BuildContext context, {
  required String currentName,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _RealizationNameDialog(currentName: currentName),
  );
}

class _RealizationNameDialog extends StatefulWidget {
  const _RealizationNameDialog({required this.currentName});

  final String currentName;

  @override
  State<_RealizationNameDialog> createState() => _RealizationNameDialogState();
}

class _RealizationNameDialogState extends State<_RealizationNameDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.currentName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    Navigator.of(context).pop(name.isEmpty ? widget.currentName.trim() : name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.realizationNameTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(labelText: l10n.nameLabel),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
