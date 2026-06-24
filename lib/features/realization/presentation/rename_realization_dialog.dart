import 'package:flutter/material.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Shows a dialog to rename a realization.
///
/// [currentName] is the text the field starts with (the current display name).
/// Returns the trimmed new name, or `null` if the user cancelled or left it
/// unchanged/empty.
Future<String?> showRenameRealizationDialog(
  BuildContext context, {
  required String currentName,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _RenameRealizationDialog(currentName: currentName),
  );
}

class _RenameRealizationDialog extends StatefulWidget {
  const _RenameRealizationDialog({required this.currentName});

  final String currentName;

  @override
  State<_RenameRealizationDialog> createState() =>
      _RenameRealizationDialogState();
}

class _RenameRealizationDialogState extends State<_RenameRealizationDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.currentName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty || name == widget.currentName.trim()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.renameRealizationTitle),
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
