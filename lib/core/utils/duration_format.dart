import 'package:winemaker/l10n/app_localizations.dart';

/// Human-readable length of a finished period, coarse on purpose: for a
/// historical record the largest unit is what matters.
String formatElapsed(AppLocalizations l10n, Duration duration) {
  if (duration.inDays > 0) return l10n.durationDays(duration.inDays);
  if (duration.inHours > 0) return l10n.durationHours(duration.inHours);
  if (duration.inMinutes > 0) return l10n.durationMinutes(duration.inMinutes);
  return l10n.durationLessThanMinute;
}
