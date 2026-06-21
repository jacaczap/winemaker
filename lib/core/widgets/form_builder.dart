import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';

FormBuilderTextField buildNumberField({
  required String name,
  required String label,
  String? suffix,
  String? initialValue,
  bool autofocus = false,
}) {
  return FormBuilderTextField(
    name: name,
    initialValue: initialValue,
    autofocus: autofocus,
    decoration: InputDecoration(
      labelText: label,
      suffixText: suffix,
    ),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
    ],
    validator: numberValidator,
  );
}
