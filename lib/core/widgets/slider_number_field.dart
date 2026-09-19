import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:winemaker/core/utils/user_input_utils.dart';
import 'package:winemaker/core/widgets/field_preset.dart';
import 'package:winemaker/features/calculator/domain/field_ranges.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Numeric form field driven by a slider, with a small box for typing an
/// exact value.
///
/// The slider covers [range], the span that is realistic to achieve with
/// fruit. Typing a value outside it is allowed: the thumb pins at the end and
/// a note points it out.
///
/// [hardMin] and [hardMax] are physical limits derived from the measured must.
/// A value beyond them cannot be made at all, so it is pulled back and
/// [limitMessage] explains why.
class SliderNumberField extends StatefulWidget {
  const SliderNumberField({
    super.key,
    required this.name,
    required this.label,
    required this.range,
    this.suffix,
    this.initialValue,
    this.enabled = true,
    this.hardMin,
    this.hardMax,
    this.limitMessage,
    this.presets,
    this.caption,
  });

  final String name;
  final String label;
  final FieldRange range;
  final String? suffix;
  final String? initialValue;
  final bool enabled;
  final double? hardMin;
  final double? hardMax;

  /// Explains a value that had to be pulled back to [hardMin] or [hardMax].
  final String Function(String value)? limitMessage;

  final List<FieldPreset>? presets;

  /// Describes the current value, e.g. the sweetness style it falls into.
  final String Function(double value)? caption;

  @override
  State<SliderNumberField> createState() => _SliderNumberFieldState();
}

class _SliderNumberFieldState extends State<SliderNumberField> {
  final _controller = TextEditingController();
  bool _adjusting = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void didUpdateWidget(SliderNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Physical limits rounded to the precision the field displays, always
  /// towards the allowed side so a shown value never breaks its own limit.
  double? get _hardMin {
    final raw = widget.hardMin;
    return raw == null ? null : (raw * 10).ceil() / 10;
  }

  double? get _hardMax {
    final raw = widget.hardMax;
    return raw == null ? null : (raw * 10).floor() / 10;
  }

  /// Slider bounds: the realistic range narrowed by the physical limits and
  /// snapped onto the step grid, kept at least one step wide.
  double get _min {
    final hardMin = _hardMin;
    if (hardMin == null) return widget.range.min;
    final snapped = _snap(hardMin, up: true);
    final headroom = widget.range.max - widget.range.step;
    return math.max(widget.range.min, math.min(snapped, headroom));
  }

  double get _max {
    final hardMax = _hardMax;
    if (hardMax == null) return widget.range.max;
    final snapped = _snap(hardMax, up: false);
    final floor = _min + widget.range.step;
    return math.min(widget.range.max, math.max(snapped, floor));
  }

  double _snap(double value, {required bool up}) {
    final steps = (value - widget.range.min) / widget.range.step;
    final whole = up ? steps.ceil() : steps.floor();
    return widget.range.min + whole * widget.range.step;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      validator: numberValidator(l10n),
      builder: (field) => _buildField(context, l10n, field),
    );
  }

  Widget _buildField(
    BuildContext context,
    AppLocalizations l10n,
    FormFieldState<String> field,
  ) {
    final theme = Theme.of(context);
    final value = tryParseDoubleInput(field.value);
    // Never rewrite a value the user cannot change: a completed task shows
    // what was actually recorded, limits or not.
    if (value != null && widget.enabled) _pullIntoLimits(field, value);
    final caption = _captionFor(l10n, theme, field, value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(widget.label, style: theme.textTheme.bodyLarge),
            ),
            if (widget.presets != null && widget.enabled)
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: l10n.suggestedValues,
                onPressed: () => _pickPreset(context, field),
              ),
            SizedBox(width: 84, child: _buildValueBox(field)),
          ],
        ),
        _buildSlider(field, value),
        if (widget.range.ticks.isNotEmpty)
          _TickMarks(
            ticks: widget.range.ticks,
            min: _min,
            max: _max,
            color: theme.colorScheme.outlineVariant,
          ),
        if (caption != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: caption,
          ),
      ],
    );
  }

  Widget _buildValueBox(FormFieldState<String> field) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      textAlign: TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      decoration: InputDecoration(isDense: true, suffixText: widget.suffix),
      onChanged: field.didChange,
    );
  }

  Widget _buildSlider(FormFieldState<String> field, double? value) {
    final divisions = math.max(1, ((_max - _min) / widget.range.step).round());
    return Slider(
      value: (value ?? _min).clamp(_min, _max),
      min: _min,
      max: _max,
      divisions: divisions,
      label: _format((value ?? _min).clamp(_min, _max)),
      onChanged:
          widget.enabled ? (picked) => _setValue(field, _format(picked)) : null,
    );
  }

  Widget? _captionFor(
    AppLocalizations l10n,
    ThemeData theme,
    FormFieldState<String> field,
    double? value,
  ) {
    final error = field.errorText;
    if (error != null) {
      return Text(
        error,
        style:
            theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
      );
    }
    if (value == null) return null;
    final text = widget.range.contains(value)
        ? widget.caption?.call(value)
        : l10n.outsideTypicalRange;
    if (text == null) return null;
    return Text(
      text,
      style: theme.textTheme.bodySmall
          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Future<void> _pickPreset(
    BuildContext context,
    FormFieldState<String> field,
  ) async {
    final presets = widget.presets;
    if (presets == null) return;
    final picked = await showPresetSheet(
      context,
      title: widget.label,
      presets: presets,
    );
    if (picked != null) _setValue(field, picked.value);
  }

  void _setValue(FormFieldState<String> field, String value) {
    field.didChange(value);
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  /// Pulls a physically impossible value back onto the nearest limit, once per
  /// change, telling the user what moved and why.
  void _pullIntoLimits(FormFieldState<String> field, double value) {
    final hardMin = _hardMin;
    final hardMax = _hardMax;
    var limited = value;
    if (hardMin != null && limited < hardMin) limited = hardMin;
    if (hardMax != null && limited > hardMax) limited = hardMax;
    if (limited == value || _adjusting) return;
    _adjusting = true;
    final text = _format(limited);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _adjusting = false;
      _setValue(field, text);
      final message = widget.limitMessage?.call(text);
      if (message == null) return;
      // Replace rather than queue: typing a measurement can move a limit on
      // every keystroke, and only the latest message is worth reading.
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }
}

String _format(double value) {
  final rounded = (value * 10).round() / 10;
  return rounded == rounded.roundToDouble()
      ? rounded.toStringAsFixed(0)
      : rounded.toString();
}

/// Thin marks under a slider track at notable positions.
class _TickMarks extends StatelessWidget {
  const _TickMarks({
    required this.ticks,
    required this.min,
    required this.max,
    required this.color,
  });

  final List<double> ticks;
  final double min;
  final double max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final visible = ticks.where((tick) => tick > min && tick < max);
    if (visible.isEmpty) return const SizedBox.shrink();
    return Padding(
      // Matches the thumb radius so the marks line up with the track.
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 6,
        child: CustomPaint(
          painter: _TickPainter(
            fractions: [
              for (final tick in visible) (tick - min) / (max - min),
            ],
            color: color,
          ),
        ),
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  const _TickPainter({required this.fractions, required this.color});

  final List<double> fractions;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final fraction in fractions) {
      final x = fraction * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_TickPainter old) =>
      old.color != color || !listEquals(old.fractions, fractions);
}
