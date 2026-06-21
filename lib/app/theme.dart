import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// Centralized Material 3 theming for the Winemaker app.
///
/// Provides matching light and dark themes built from
/// [FlexScheme.redWine] together with the typography tokens used
/// across screens. UI code should read styles through
/// `Theme.of(context).textTheme` / `colorScheme` instead of hardcoding
/// values so that both themes and dynamic text scaling stay consistent.
class AppTheme {
  AppTheme._();

  static const String appTitle = 'Winemaker';

  static const FlexScheme _scheme = FlexScheme.redWine;

  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    defaultRadius: 12,
    inputDecoratorRadius: 12,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    elevatedButtonRadius: 12,
    filledButtonRadius: 12,
    outlinedButtonRadius: 12,
    cardRadius: 16,
    bottomSheetRadius: 20,
  );

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11),
  );

  static ThemeData light() => FlexThemeData.light(
    scheme: _scheme,
    subThemesData: _subThemes,
    textTheme: _textTheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData dark() => FlexThemeData.dark(
    scheme: _scheme,
    subThemesData: _subThemes,
    textTheme: _textTheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
