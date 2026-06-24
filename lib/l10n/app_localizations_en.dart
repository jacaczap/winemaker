// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get redo => 'Redo';

  @override
  String get markAsDone => 'Mark as done';

  @override
  String get saveAndMarkDone => 'Save & mark done';

  @override
  String get calculateIngredients => 'Calculate ingredients';

  @override
  String get redoFromHere => 'Redo from here';

  @override
  String errorWithMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get ingredientSugar => 'Sugar';

  @override
  String get ingredientWater => 'Water';

  @override
  String get ingredientYeast => 'Yeast';

  @override
  String get ingredientNutrients => 'Nutrients';

  @override
  String get valueAdd => 'Add';

  @override
  String get valueNotNeeded => 'Not needed';

  @override
  String get valueDone => 'Done';

  @override
  String get validationRequired => 'Please enter value';

  @override
  String get validationNotANumber => 'Value must be a number';

  @override
  String get validationNegative => 'Value cannot be negative';

  @override
  String get notificationChannelName => 'Wine tasks';

  @override
  String get notificationChannelDescription =>
      'Reminders for timed wine-making steps';

  @override
  String get suggestedValues => 'Suggested values';

  @override
  String get calculatorTitle => 'Calculator';

  @override
  String get desiredWine => 'Desired wine';

  @override
  String get mustMeasurements => 'Must measurements';

  @override
  String get ingredientsToAdd => 'Ingredients to add';

  @override
  String get fieldDesiredAlcohol => 'Desired alcohol';

  @override
  String get fieldDesiredSweetness => 'Desired sweetness';

  @override
  String get fieldDesiredAcidity => 'Desired acidity';

  @override
  String get fieldCollectedVolume => 'Collected volume';

  @override
  String get fieldMustSugar => 'Sugar';

  @override
  String get fieldMustAcidity => 'Acidity';

  @override
  String get recipeRedWine => 'Red Wine';

  @override
  String get recipesTitle => 'Recipes';

  @override
  String recipeStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '$count step',
    );
    return '$_temp0';
  }

  @override
  String recipeStepLabel(int step, String type) {
    return 'Step $step - $type';
  }

  @override
  String get taskTypeCalculations => 'Calculations';

  @override
  String get taskTypeInstructions => 'Instructions';

  @override
  String get taskTypeAddIngredients => 'Add ingredients';

  @override
  String get taskTypeWait => 'Wait';

  @override
  String get taskTypeResult => 'Result';

  @override
  String get taskPrepareFruitName => 'Prepare the fruit';

  @override
  String get taskPrepareFruitDescription =>
      '- Collect the fruit and put it in the primary fermentation bucket.\n- Crush it to release the juice.\n- Take the must measurements you will need in the next step (volume, sweetness, acidity).';

  @override
  String get taskCalculationsName => 'Calculations';

  @override
  String get taskAddIngredientsName => 'Add ingredients';

  @override
  String get taskAddIngredientsDescription =>
      'Add the yeast, yeast nutrient, the first sugar portion and water.';

  @override
  String get taskFermentWithSkinsName => 'Ferment with the skins';

  @override
  String get taskFermentWithSkinsDescription =>
      'Let the must ferment in the bucket with the fruit skins in a warm room, punching the floating cap of skins down into the liquid once or twice a day. Press when the vigorous fermentation has calmed and the cap no longer rises (usually about a week).';

  @override
  String get taskMoveToCarboyName => 'Move to the carboy';

  @override
  String get taskMoveToCarboyDescription =>
      '- Press the pulp and discard the solids.\n- Move the juice into a glass carboy.\n- Keep it in a warm room.';

  @override
  String get taskWaitSugarDropName => 'Wait for the sugar to drop';

  @override
  String get taskWaitSugarDropDescription =>
      'Wait until the sugar level drops noticeably before adding the next sugar portion. As a guide, complete this step once the measured sweetness falls to about 2-5 Blg.';

  @override
  String get taskAddRemainingSugarName => 'Add remaining sugar';

  @override
  String get taskAddRemainingSugarDescription =>
      'Add the remaining sugar portion.';

  @override
  String get taskWaitFermentationSlowName => 'Wait for fermentation to slow';

  @override
  String get taskWaitFermentationSlowDescription =>
      'Wait for the active fermentation to wind down. Rack once the airlock bubbles only occasionally and a layer of sediment has settled at the bottom.';

  @override
  String get taskRackWineName => 'Rack the wine';

  @override
  String get taskRackWineDescription =>
      '- Siphon (rack) the wine into a clean carboy, leaving the sediment (lees) behind.\n- Keep it in a cool room.';

  @override
  String get taskMatureWineName => 'Mature the wine';

  @override
  String get taskMatureWineDescription =>
      'Let the wine mature for a few months, racking off the sediment every 1-3 months. Typical total bulk aging: light reds 3-6 months, medium reds 6-9 months, full-bodied reds 12 months or more.';

  @override
  String get taskRackWineAgainName => 'Rack the wine again';

  @override
  String get taskRackWineAgainDescription =>
      '- Siphon (rack) the wine into a clean carboy, leaving the sediment (lees) behind.\n- Keep it in a cool room.';

  @override
  String get taskMatureWineAgainName => 'Mature the wine again';

  @override
  String get taskMatureWineAgainDescription =>
      'Let the wine mature for a few more months, until it is clear and tastes smooth.';

  @override
  String get taskBottleWineName => 'Bottle the wine';

  @override
  String get taskBottleWineDescription =>
      '- Siphon the wine into bottles, leaving the last of the sediment behind.';

  @override
  String get taskResultName => 'Result';

  @override
  String get newRealization => 'New realization';

  @override
  String get chooseRecipe => 'Choose a recipe';

  @override
  String get completed => 'Completed';

  @override
  String stepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get deleteRealizationTitle => 'Delete realization?';

  @override
  String get deleteRealizationMessage =>
      'This removes the realization and all its entered data.';

  @override
  String get noRealizationsTitle => 'No realizations yet';

  @override
  String get noRealizationsMessage =>
      'Tap \"New realization\" to start making wine.';

  @override
  String get recipeFallbackTitle => 'Recipe';

  @override
  String get descriptionFallbackTitle => 'Description';

  @override
  String get rename => 'Rename';

  @override
  String get allTasksComplete => 'All tasks complete';

  @override
  String get progress => 'Progress';

  @override
  String get semanticsRecipeProgress => 'Recipe progress';

  @override
  String semanticsTasksCompleted(int completed, int total) {
    return '$completed of $total tasks completed';
  }

  @override
  String get statusCompletedTapToView => 'Completed - tap to view';

  @override
  String get statusTapToStart => 'Tap to start';

  @override
  String get statusPending => 'Pending';

  @override
  String get redoTitle => 'Redo from here?';

  @override
  String redoMessage(String label) {
    return 'Go back to \"$label\" and redo from there? Data entered in later tasks will be discarded.';
  }

  @override
  String get realizationCompletedTitle => 'Realization completed';

  @override
  String get realizationCompletedMessage =>
      'You have completed every task in this realization.';

  @override
  String get stayHere => 'Stay here';

  @override
  String get backToList => 'Back to list';

  @override
  String get renameRealizationTitle => 'Rename realization';

  @override
  String get nameLabel => 'Name';

  @override
  String get addedThisStep => 'Added this step';

  @override
  String get addedSugar => 'Added sugar';

  @override
  String get addedWater => 'Added water';

  @override
  String get yeastAdded => 'Yeast added';

  @override
  String get nutrientsAdded => 'Nutrients added';

  @override
  String get remainingToAdd => 'Remaining to add';

  @override
  String postponeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Postpone $days days',
      one: 'Postpone $days day',
    );
    return '$_temp0';
  }

  @override
  String get completeNow => 'Complete now';

  @override
  String get readyToContinue => 'Ready to continue';

  @override
  String get waitingPeriodOver => 'The waiting period is over.';

  @override
  String reminderOn(String date) {
    return 'Reminder on $date';
  }

  @override
  String timeLeftDays(int days, int hours) {
    return '$days d $hours h left';
  }

  @override
  String timeLeftHours(int hours, int minutes) {
    return '$hours h $minutes m left';
  }

  @override
  String timeLeftMinutes(int minutes, int seconds) {
    return '$minutes m $seconds s left';
  }

  @override
  String get resultsLabel => 'Results';

  @override
  String get resultsHint =>
      'How did the wine turn out? Taste, clarity, strength…';

  @override
  String get mistakesLabel => 'Mistakes';

  @override
  String get mistakesHint => 'Anything to do differently next time?';

  @override
  String get presetDry => 'Dry';

  @override
  String get presetSemiDry => 'Semi-dry';

  @override
  String get presetSemiSweet => 'Semi-sweet';

  @override
  String get presetSweet => 'Sweet';

  @override
  String get presetRedTableWine => 'Red table wine';

  @override
  String get presetWhiteTableWine => 'White table wine';

  @override
  String get presetLightSparkling => 'Light / sparkling';

  @override
  String get presetLightWhite => 'Light white';

  @override
  String get presetFullWhite => 'Full white';

  @override
  String get presetLightRed => 'Light red';

  @override
  String get presetFullRed => 'Full red';

  @override
  String get presetTableWine => 'Table wine';

  @override
  String get presetDessert => 'Dessert';

  @override
  String get presetFortified => 'Fortified';

  @override
  String get presetWhiteGrape => 'White grape';

  @override
  String get presetRedGrape => 'Red grape';

  @override
  String get presetCoolClimateMust => 'Cool-climate must';

  @override
  String get presetApple => 'Apple';

  @override
  String get presetPear => 'Pear';

  @override
  String get presetPlum => 'Plum';

  @override
  String get presetSweetCherry => 'Sweet cherry';

  @override
  String get presetSourCherry => 'Sour cherry';

  @override
  String get presetBlackcurrant => 'Blackcurrant';

  @override
  String get presetRedcurrant => 'Redcurrant';

  @override
  String get presetRaspberry => 'Raspberry';

  @override
  String get presetGooseberry => 'Gooseberry';

  @override
  String get presetStrawberry => 'Strawberry';

  @override
  String get presetGrape => 'Grape';

  @override
  String get presetEgJohanniter => 'e.g. Johanniter 7–9';

  @override
  String get presetEgRegent => 'e.g. Regent 6–7';
}
