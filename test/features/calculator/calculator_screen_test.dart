import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winemaker/features/calculator/presentation/calculator_screen.dart';
import 'package:winemaker/features/calculator/presentation/ingredients_result_card.dart';
import 'package:winemaker/l10n/app_localizations.dart';

Future<void> _pumpCalculator(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
    locale: Locale('en'),
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [Locale('en')],
    home: CalculatorScreen(),
  ));
  await tester.pumpAndSettle();
}

/// Types into the value box of the slider field carrying [label].
Future<void> _enter(
  WidgetTester tester,
  String label,
  String value,
) async {
  final row = find.ancestor(of: find.text(label), matching: find.byType(Row));
  await tester.enterText(
    find.descendant(of: row.first, matching: find.byType(TextField)),
    value,
  );
  await tester.pumpAndSettle();
}

Finder _sliderFor(String label) {
  final column =
      find.ancestor(of: find.text(label), matching: find.byType(Column)).first;
  return find.descendant(of: column, matching: find.byType(Slider));
}

void main() {
  testWidgets('sliders cover the realistic range', (tester) async {
    await _pumpCalculator(tester);

    final volume = tester.widget<Slider>(_sliderFor('Collected volume'));
    expect(volume.min, equals(5));
    expect(volume.max, equals(50));

    final sweetness = tester.widget<Slider>(_sliderFor('Desired sweetness'));
    expect(sweetness.min, equals(0));
    expect(sweetness.max, equals(80));
  });

  testWidgets('sweetness slider names the style it is in', (tester) async {
    await _pumpCalculator(tester);

    await _enter(tester, 'Desired sweetness', '5');
    expect(find.text('Dry'), findsOneWidget);

    await _enter(tester, 'Desired sweetness', '40');
    expect(find.text('Semi-sweet'), findsOneWidget);
  });

  testWidgets('typing outside the realistic range is allowed but flagged',
      (tester) async {
    await _pumpCalculator(tester);

    await _enter(tester, 'Desired alcohol', '30');

    expect(find.text('Outside the typical range'), findsOneWidget);
    final alcohol = tester.widget<Slider>(_sliderFor('Desired alcohol'));
    expect(alcohol.value, equals(alcohol.max));
  });

  testWidgets('measured must narrows the desired acidity slider',
      (tester) async {
    await _pumpCalculator(tester);

    await _enter(tester, 'Collected volume', '10');
    await _enter(tester, 'Sugar', '20');
    await _enter(tester, 'Acidity', '6');
    await _enter(tester, 'Desired alcohol', '12');

    final acidity = tester.widget<Slider>(_sliderFor('Desired acidity'));
    expect(acidity.max, lessThan(6));
  });

  testWidgets('an impossible acidity is pulled back and explained',
      (tester) async {
    await _pumpCalculator(tester);

    await _enter(tester, 'Collected volume', '10');
    await _enter(tester, 'Sugar', '20');
    await _enter(tester, 'Acidity', '6');
    await _enter(tester, 'Desired alcohol', '12');
    await _enter(tester, 'Desired acidity', '12');

    expect(find.textContaining('Acidity lowered to'), findsOneWidget);
  });

  testWidgets('calculates from values within the limits', (tester) async {
    await _pumpCalculator(tester);

    await _enter(tester, 'Collected volume', '10');
    await _enter(tester, 'Sugar', '20');
    await _enter(tester, 'Acidity', '10');
    await _enter(tester, 'Desired alcohol', '12');
    await _enter(tester, 'Desired sweetness', '20');
    await _enter(tester, 'Desired acidity', '6');

    final button = find.text('Calculate ingredients');
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    final shown = tester
        .widgetList<Text>(find.descendant(
          of: find.byType(IngredientsResultCard),
          matching: find.byType(Text),
        ))
        .map((text) => text.data)
        .whereType<String>();

    expect(shown.any((value) => value.endsWith('kg')), isTrue);
    expect(shown.where((value) => value.startsWith('-')), isEmpty);
  });
}
