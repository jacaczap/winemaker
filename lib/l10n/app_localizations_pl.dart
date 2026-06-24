// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get delete => 'Usuń';

  @override
  String get redo => 'Powtórz';

  @override
  String get markAsDone => 'Oznacz jako zrobione';

  @override
  String get saveAndMarkDone => 'Zapisz i oznacz jako zrobione';

  @override
  String get calculateIngredients => 'Oblicz składniki';

  @override
  String get redoFromHere => 'Powtórz od tego miejsca';

  @override
  String errorWithMessage(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get ingredientSugar => 'Cukier';

  @override
  String get ingredientWater => 'Woda';

  @override
  String get ingredientYeast => 'Drożdże';

  @override
  String get ingredientNutrients => 'Pożywki';

  @override
  String get valueAdd => 'Dodaj';

  @override
  String get valueNotNeeded => 'Niepotrzebne';

  @override
  String get valueDone => 'Gotowe';

  @override
  String get validationRequired => 'Podaj wartość';

  @override
  String get validationNotANumber => 'Wartość musi być liczbą';

  @override
  String get validationNegative => 'Wartość nie może być ujemna';

  @override
  String get notificationChannelName => 'Zadania winiarskie';

  @override
  String get notificationChannelDescription =>
      'Przypomnienia o etapach wymagających czasu';

  @override
  String get suggestedValues => 'Sugerowane wartości';

  @override
  String get calculatorTitle => 'Kalkulator';

  @override
  String get desiredWine => 'Pożądane wino';

  @override
  String get mustMeasurements => 'Pomiary moszczu';

  @override
  String get ingredientsToAdd => 'Składniki do dodania';

  @override
  String get fieldDesiredAlcohol => 'Pożądany alkohol';

  @override
  String get fieldDesiredSweetness => 'Pożądana słodycz';

  @override
  String get fieldDesiredAcidity => 'Pożądana kwasowość';

  @override
  String get fieldCollectedVolume => 'Zebrana objętość';

  @override
  String get fieldMustSugar => 'Cukier';

  @override
  String get fieldMustAcidity => 'Kwasowość';

  @override
  String get recipeRedWine => 'Czerwone wino';

  @override
  String get recipesTitle => 'Przepisy';

  @override
  String recipeStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kroku',
      many: '$count kroków',
      few: '$count kroki',
      one: '$count krok',
    );
    return '$_temp0';
  }

  @override
  String recipeStepLabel(int step, String type) {
    return 'Krok $step - $type';
  }

  @override
  String get taskTypeCalculations => 'Obliczenia';

  @override
  String get taskTypeInstructions => 'Instrukcje';

  @override
  String get taskTypeAddIngredients => 'Dodawanie składników';

  @override
  String get taskTypeWait => 'Oczekiwanie';

  @override
  String get taskTypeResult => 'Wynik';

  @override
  String get taskPrepareFruitName => 'Przygotuj owoce';

  @override
  String get taskPrepareFruitDescription =>
      '- Zbierz owoce i włóż je do pojemnika do fermentacji wstępnej.\n- Rozgnieć je, aby uwolnić sok.\n- Wykonaj pomiary moszczu potrzebne w następnym kroku (objętość, słodycz, kwasowość).';

  @override
  String get taskCalculationsName => 'Obliczenia';

  @override
  String get taskAddIngredientsName => 'Dodaj składniki';

  @override
  String get taskAddIngredientsDescription =>
      'Dodaj drożdże, pożywkę dla drożdży, pierwszą porcję cukru i wodę.';

  @override
  String get taskFermentWithSkinsName => 'Fermentuj na miazdze';

  @override
  String get taskFermentWithSkinsDescription =>
      'Pozostaw moszcz do fermentacji w pojemniku ze skórkami owoców w ciepłym pomieszczeniu, zatapiając unoszący się kożuch ze skórek w cieczy raz lub dwa razy dziennie. Odciśnij, gdy burzliwa fermentacja ustanie, a kożuch przestanie się unosić (zwykle po około tygodniu).';

  @override
  String get taskMoveToCarboyName => 'Przelej do gąsiora';

  @override
  String get taskMoveToCarboyDescription =>
      '- Odciśnij miazgę i wyrzuć części stałe.\n- Przelej sok do szklanego gąsiora.\n- Trzymaj w ciepłym pomieszczeniu.';

  @override
  String get taskWaitSugarDropName => 'Poczekaj na spadek cukru';

  @override
  String get taskWaitSugarDropDescription =>
      'Poczekaj, aż poziom cukru wyraźnie spadnie, zanim dodasz kolejną porcję cukru. Orientacyjnie zakończ ten krok, gdy zmierzona słodycz spadnie do około 2-5 Blg.';

  @override
  String get taskAddRemainingSugarName => 'Dodaj pozostały cukier';

  @override
  String get taskAddRemainingSugarDescription =>
      'Dodaj pozostałą porcję cukru.';

  @override
  String get taskWaitFermentationSlowName =>
      'Poczekaj na spowolnienie fermentacji';

  @override
  String get taskWaitFermentationSlowDescription =>
      'Poczekaj, aż aktywna fermentacja wygaśnie. Zlej znad osadu, gdy rurka fermentacyjna bulgocze tylko sporadycznie, a na dnie osadzi się warstwa osadu.';

  @override
  String get taskRackWineName => 'Zlej wino znad osadu';

  @override
  String get taskRackWineDescription =>
      '- Zlej (ściągnij) wino do czystego gąsiora, pozostawiając osad na dnie.\n- Trzymaj w chłodnym pomieszczeniu.';

  @override
  String get taskMatureWineName => 'Dojrzewanie wina';

  @override
  String get taskMatureWineDescription =>
      'Pozostaw wino do dojrzewania na kilka miesięcy, zlewając znad osadu co 1-3 miesiące. Typowy całkowity czas leżakowania: lekkie czerwone 3-6 miesięcy, średnie czerwone 6-9 miesięcy, pełne czerwone 12 miesięcy lub więcej.';

  @override
  String get taskRackWineAgainName => 'Ponownie zlej wino znad osadu';

  @override
  String get taskRackWineAgainDescription =>
      '- Zlej (ściągnij) wino do czystego gąsiora, pozostawiając osad na dnie.\n- Trzymaj w chłodnym pomieszczeniu.';

  @override
  String get taskMatureWineAgainName => 'Dalsze dojrzewanie wina';

  @override
  String get taskMatureWineAgainDescription =>
      'Pozostaw wino do dojrzewania na kolejne kilka miesięcy, aż będzie klarowne i będzie miało łagodny smak.';

  @override
  String get taskBottleWineName => 'Rozlej wino do butelek';

  @override
  String get taskBottleWineDescription =>
      '- Zlej wino do butelek, pozostawiając resztki osadu na dnie.';

  @override
  String get taskResultName => 'Wynik';

  @override
  String get newRealization => 'Nowa realizacja';

  @override
  String get chooseRecipe => 'Wybierz przepis';

  @override
  String get completed => 'Ukończono';

  @override
  String stepProgress(int current, int total) {
    return 'Krok $current z $total';
  }

  @override
  String get deleteRealizationTitle => 'Usunąć realizację?';

  @override
  String get deleteRealizationMessage =>
      'Spowoduje to usunięcie realizacji i wszystkich wprowadzonych danych.';

  @override
  String get noRealizationsTitle => 'Brak realizacji';

  @override
  String get noRealizationsMessage =>
      'Naciśnij „Nowa realizacja”, aby zacząć robić wino.';

  @override
  String get recipeFallbackTitle => 'Przepis';

  @override
  String get descriptionFallbackTitle => 'Opis';

  @override
  String get rename => 'Zmień nazwę';

  @override
  String get allTasksComplete => 'Wszystkie zadania ukończone';

  @override
  String get progress => 'Postęp';

  @override
  String get semanticsRecipeProgress => 'Postęp przepisu';

  @override
  String semanticsTasksCompleted(int completed, int total) {
    return 'Ukończono $completed z $total zadań';
  }

  @override
  String get statusCompletedTapToView => 'Ukończono - dotknij, aby zobaczyć';

  @override
  String get statusTapToStart => 'Dotknij, aby rozpocząć';

  @override
  String get statusPending => 'Oczekuje';

  @override
  String get redoTitle => 'Powtórzyć od tego miejsca?';

  @override
  String redoMessage(String label) {
    return 'Wrócić do „$label” i powtórzyć od tego miejsca? Dane wprowadzone w późniejszych zadaniach zostaną usunięte.';
  }

  @override
  String get realizationCompletedTitle => 'Realizacja ukończona';

  @override
  String get realizationCompletedMessage =>
      'Ukończono wszystkie zadania w tej realizacji.';

  @override
  String get stayHere => 'Zostań tutaj';

  @override
  String get backToList => 'Wróć do listy';

  @override
  String get renameRealizationTitle => 'Zmień nazwę realizacji';

  @override
  String get nameLabel => 'Nazwa';

  @override
  String get addedThisStep => 'Dodane w tym kroku';

  @override
  String get addedSugar => 'Dodany cukier';

  @override
  String get addedWater => 'Dodana woda';

  @override
  String get yeastAdded => 'Dodano drożdże';

  @override
  String get nutrientsAdded => 'Dodano pożywki';

  @override
  String get remainingToAdd => 'Pozostało do dodania';

  @override
  String postponeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Odłóż o $days dnia',
      many: 'Odłóż o $days dni',
      few: 'Odłóż o $days dni',
      one: 'Odłóż o $days dzień',
    );
    return '$_temp0';
  }

  @override
  String get completeNow => 'Zakończ teraz';

  @override
  String get readyToContinue => 'Można kontynuować';

  @override
  String get waitingPeriodOver => 'Okres oczekiwania minął.';

  @override
  String reminderOn(String date) {
    return 'Przypomnienie $date';
  }

  @override
  String timeLeftDays(int days, int hours) {
    return 'pozostało $days d $hours h';
  }

  @override
  String timeLeftHours(int hours, int minutes) {
    return 'pozostało $hours h $minutes m';
  }

  @override
  String timeLeftMinutes(int minutes, int seconds) {
    return 'pozostało $minutes m $seconds s';
  }

  @override
  String get resultsLabel => 'Wyniki';

  @override
  String get resultsHint => 'Jak wyszło wino? Smak, klarowność, moc…';

  @override
  String get mistakesLabel => 'Błędy';

  @override
  String get mistakesHint => 'Co zrobić inaczej następnym razem?';

  @override
  String get presetDry => 'Wytrawne';

  @override
  String get presetSemiDry => 'Półwytrawne';

  @override
  String get presetSemiSweet => 'Półsłodkie';

  @override
  String get presetSweet => 'Słodkie';

  @override
  String get presetRedTableWine => 'Czerwone wino stołowe';

  @override
  String get presetWhiteTableWine => 'Białe wino stołowe';

  @override
  String get presetLightSparkling => 'Lekkie / musujące';

  @override
  String get presetLightWhite => 'Lekkie białe';

  @override
  String get presetFullWhite => 'Pełne białe';

  @override
  String get presetLightRed => 'Lekkie czerwone';

  @override
  String get presetFullRed => 'Pełne czerwone';

  @override
  String get presetTableWine => 'Wino stołowe';

  @override
  String get presetDessert => 'Deserowe';

  @override
  String get presetFortified => 'Wzmacniane';

  @override
  String get presetWhiteGrape => 'Białe winogrono';

  @override
  String get presetRedGrape => 'Czerwone winogrono';

  @override
  String get presetCoolClimateMust => 'Moszcz z chłodnego klimatu';

  @override
  String get presetApple => 'Jabłko';

  @override
  String get presetPear => 'Gruszka';

  @override
  String get presetPlum => 'Śliwka';

  @override
  String get presetSweetCherry => 'Czereśnia';

  @override
  String get presetSourCherry => 'Wiśnia';

  @override
  String get presetBlackcurrant => 'Czarna porzeczka';

  @override
  String get presetRedcurrant => 'Czerwona porzeczka';

  @override
  String get presetRaspberry => 'Malina';

  @override
  String get presetGooseberry => 'Agrest';

  @override
  String get presetStrawberry => 'Truskawka';

  @override
  String get presetGrape => 'Winogrono';

  @override
  String get presetEgJohanniter => 'np. Johanniter 7–9';

  @override
  String get presetEgRegent => 'np. Regent 6–7';
}
