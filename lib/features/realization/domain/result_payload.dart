import 'package:winemaker/features/realization/domain/task_state.dart';

/// Per-occurrence data for a `result` task.
///
/// Free text the user writes once the wine is done, kept for later inspection:
/// what the results were and any mistakes worth remembering next time.
class ResultPayload extends TaskPayload {
  const ResultPayload({required this.results, required this.mistakes});

  factory ResultPayload.fromJson(Map<String, dynamic> json) => ResultPayload(
        results: json['results'] as String? ?? '',
        mistakes: json['mistakes'] as String? ?? '',
      );

  final String results;
  final String mistakes;

  @override
  Map<String, dynamic> toJson() => {
        'results': results,
        'mistakes': mistakes,
      };
}
