import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/l10n/app_localizations.dart';

FormBuilderTextField buildNumberField({
  required AppLocalizations l10n,
  required String name,
  required String label,
  String? suffix,
  String? initialValue,
  bool autofocus = false,
  bool enabled = true,
  bool optional = false,
}) {
  return FormBuilderTextField(
    name: name,
    initialValue: initialValue,
    autofocus: autofocus,
    enabled: enabled,
    decoration: InputDecoration(labelText: label, suffixText: suffix),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
    ],
    validator: optional ? optionalNumberValidator(l10n) : numberValidator(l10n),
  );
}
