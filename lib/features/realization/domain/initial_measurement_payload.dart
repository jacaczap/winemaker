import 'package:winemaker/core/models/sugar.dart';
import 'package:winemaker/features/realization/domain/task_state.dart';

/// Per-occurrence data for an `initialMeasurement` task.
///
/// Holds the must sweetness taken before fermentation starts. This is the one
/// measurement that cannot be retaken later: once alcohol is present, a
/// hydrometer or refractometer no longer reads sugar correctly. The
/// `calculations` task reads it back instead of asking for it again.
class InitialMeasurementPayload extends TaskPayload {
  const InitialMeasurementPayload({required this.sweetness});

  factory InitialMeasurementPayload.fromJson(Map<String, dynamic> json) =>
      InitialMeasurementPayload(
        sweetness: Blg((json['mustSugar'] as num).toDouble()),
      );

  final Blg sweetness;

  @override
  Map<String, dynamic> toJson() => {'mustSugar': sweetness.value};
}
