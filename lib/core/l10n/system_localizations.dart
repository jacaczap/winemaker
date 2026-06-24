import 'dart:ui';

import 'package:winemaker/l10n/app_localizations.dart';

/// Resolves [AppLocalizations] for the current system locale without a
/// [BuildContext].
///
/// Use only outside the widget tree (e.g. notification scheduling and
/// notification-tap navigation). Falls back to English for unsupported locales.
AppLocalizations systemAppLocalizations() {
  final language = PlatformDispatcher.instance.locale.languageCode;
  final isSupported =
      AppLocalizations.supportedLocales.any((l) => l.languageCode == language);
  return lookupAppLocalizations(
    isSupported ? Locale(language) : const Locale('en'),
  );
}
