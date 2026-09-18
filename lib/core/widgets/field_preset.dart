import 'package:flutter/material.dart';

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

/// Opens a sheet of [presets] and returns the one the user picked.
Future<FieldPreset?> showPresetSheet(
  BuildContext context, {
  required String title,
  required List<FieldPreset> presets,
}) {
  return showModalBottomSheet<FieldPreset>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _PresetSheet(title: title, presets: presets),
  );
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
