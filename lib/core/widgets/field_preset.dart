import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// A suggested value for a numeric form field.
class FieldPreset {
  const FieldPreset({
    required this.label,
    required this.value,
    this.description,
  });

  /// Short name shown to the user (e.g. a wine style or fruit).
  final String label;

  /// Value patched into the field when selected.
  final String value;

  /// Optional context such as the reference range or source.
  final String? description;
}

/// Icon button placed on a form field that opens a sheet of [FieldPreset]s.
///
/// Selecting one patches the named field in the enclosing `FormBuilder`; the
/// user can still type any value afterwards.
class PresetButton extends StatelessWidget {
  const PresetButton({
    super.key,
    required this.fieldName,
    required this.presets,
    required this.title,
  });

  final String fieldName;
  final List<FieldPreset> presets;
  final String title;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune),
      tooltip: AppLocalizations.of(context).suggestedValues,
      onPressed: () => _openSheet(context),
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final formState = FormBuilder.of(context);
    final selected = await showModalBottomSheet<FieldPreset>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _PresetSheet(title: title, presets: presets),
    );
    if (selected != null) {
      formState?.patchValue({fieldName: selected.value});
    }
  }
}

class _PresetSheet extends StatelessWidget {
  const _PresetSheet({required this.title, required this.presets});

  final String title;
  final List<FieldPreset> presets;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: presets.length,
                itemBuilder: (context, index) {
                  final preset = presets[index];
                  return ListTile(
                    title: Text(preset.label),
                    subtitle: preset.description == null
                        ? null
                        : Text(preset.description!),
                    trailing: Text(
                      preset.value,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => Navigator.of(context).pop(preset),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
