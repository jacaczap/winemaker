import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @markAsDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get markAsDone;

  /// No description provided for @saveAndMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Save & mark done'**
  String get saveAndMarkDone;

  /// No description provided for @calculateIngredients.
  ///
  /// In en, this message translates to:
  /// **'Calculate ingredients'**
  String get calculateIngredients;

  /// No description provided for @redoFromHere.
  ///
  /// In en, this message translates to:
  /// **'Redo from here'**
  String get redoFromHere;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithMessage(Object error);

  /// No description provided for @ingredientSugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get ingredientSugar;

  /// No description provided for @ingredientWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get ingredientWater;

  /// No description provided for @ingredientYeast.
  ///
  /// In en, this message translates to:
  /// **'Yeast'**
  String get ingredientYeast;

  /// No description provided for @ingredientNutrients.
  ///
  /// In en, this message translates to:
  /// **'Nutrients'**
  String get ingredientNutrients;

  /// No description provided for @valueAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get valueAdd;

  /// No description provided for @valueNotNeeded.
  ///
  /// In en, this message translates to:
  /// **'Not needed'**
  String get valueNotNeeded;

  /// No description provided for @valueDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get valueDone;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter value'**
  String get validationRequired;

  /// No description provided for @validationNotANumber.
  ///
  /// In en, this message translates to:
  /// **'Value must be a number'**
  String get validationNotANumber;

  /// No description provided for @validationNegative.
  ///
  /// In en, this message translates to:
  /// **'Value cannot be negative'**
  String get validationNegative;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Wine tasks'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders for timed wine-making steps'**
  String get notificationChannelDescription;

  /// No description provided for @suggestedValues.
  ///
  /// In en, this message translates to:
  /// **'Suggested values'**
  String get suggestedValues;

  /// No description provided for @calculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculatorTitle;

  /// No description provided for @desiredWine.
  ///
  /// In en, this message translates to:
  /// **'Desired wine'**
  String get desiredWine;

  /// No description provided for @mustMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Must measurements'**
  String get mustMeasurements;

  /// No description provided for @ingredientsToAdd.
  ///
  /// In en, this message translates to:
  /// **'Ingredients to add'**
  String get ingredientsToAdd;

  /// No description provided for @fieldDesiredAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Desired alcohol'**
  String get fieldDesiredAlcohol;

  /// No description provided for @fieldDesiredSweetness.
  ///
  /// In en, this message translates to:
  /// **'Desired sweetness'**
  String get fieldDesiredSweetness;

  /// No description provided for @fieldDesiredAcidity.
  ///
  /// In en, this message translates to:
  /// **'Desired acidity'**
  String get fieldDesiredAcidity;

  /// No description provided for @fieldCollectedVolume.
  ///
  /// In en, this message translates to:
  /// **'Collected volume'**
  String get fieldCollectedVolume;

  /// No description provided for @fieldMustSugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get fieldMustSugar;

  /// No description provided for @fieldMustAcidity.
  ///
  /// In en, this message translates to:
  /// **'Acidity'**
  String get fieldMustAcidity;

  /// No description provided for @recipeRedWine.
  ///
  /// In en, this message translates to:
  /// **'Red Wine'**
  String get recipeRedWine;

  /// No description provided for @recipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipesTitle;

  /// No description provided for @recipeStepCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} step} other{{count} steps}}'**
  String recipeStepCount(int count);

  /// No description provided for @recipeStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {step} - {type}'**
  String recipeStepLabel(int step, String type);

  /// No description provided for @taskTypeCalculations.
  ///
  /// In en, this message translates to:
  /// **'Calculations'**
  String get taskTypeCalculations;

  /// No description provided for @taskTypeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get taskTypeInstructions;

  /// No description provided for @taskTypeAddIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get taskTypeAddIngredients;

  /// No description provided for @taskTypeWait.
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get taskTypeWait;

  /// No description provided for @taskTypeResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get taskTypeResult;

  /// No description provided for @taskPrepareFruitName.
  ///
  /// In en, this message translates to:
  /// **'Prepare the fruit'**
  String get taskPrepareFruitName;

  /// No description provided for @taskPrepareFruitDescription.
  ///
  /// In en, this message translates to:
  /// **'- Collect the fruit and put it in the primary fermentation bucket.\n- Crush it to release the juice.\n- Take the must measurements you will need in the next step (volume, sweetness, acidity).'**
  String get taskPrepareFruitDescription;

  /// No description provided for @taskCalculationsName.
  ///
  /// In en, this message translates to:
  /// **'Calculations'**
  String get taskCalculationsName;

  /// No description provided for @taskAddIngredientsName.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get taskAddIngredientsName;

  /// No description provided for @taskAddIngredientsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add the yeast, yeast nutrient, the first sugar portion and water.'**
  String get taskAddIngredientsDescription;

  /// No description provided for @taskFermentWithSkinsName.
  ///
  /// In en, this message translates to:
  /// **'Ferment with the skins'**
  String get taskFermentWithSkinsName;

  /// No description provided for @taskFermentWithSkinsDescription.
  ///
  /// In en, this message translates to:
  /// **'Let the must ferment in the bucket with the fruit skins in a warm room, punching the floating cap of skins down into the liquid once or twice a day. Press when the vigorous fermentation has calmed and the cap no longer rises (usually about a week).'**
  String get taskFermentWithSkinsDescription;

  /// No description provided for @taskMoveToCarboyName.
  ///
  /// In en, this message translates to:
  /// **'Move to the carboy'**
  String get taskMoveToCarboyName;

  /// No description provided for @taskMoveToCarboyDescription.
  ///
  /// In en, this message translates to:
  /// **'- Press the pulp and discard the solids.\n- Move the juice into a glass carboy.\n- Keep it in a warm room.'**
  String get taskMoveToCarboyDescription;

  /// No description provided for @taskWaitSugarDropName.
  ///
  /// In en, this message translates to:
  /// **'Wait for the sugar to drop'**
  String get taskWaitSugarDropName;

  /// No description provided for @taskWaitSugarDropDescription.
  ///
  /// In en, this message translates to:
  /// **'Wait until the sugar level drops noticeably before adding the next sugar portion. As a guide, complete this step once the measured sweetness falls to about 2-5 Blg.'**
  String get taskWaitSugarDropDescription;

  /// No description provided for @taskAddRemainingSugarName.
  ///
  /// In en, this message translates to:
  /// **'Add remaining sugar'**
  String get taskAddRemainingSugarName;

  /// No description provided for @taskAddRemainingSugarDescription.
  ///
  /// In en, this message translates to:
  /// **'Add the remaining sugar portion.'**
  String get taskAddRemainingSugarDescription;

  /// No description provided for @taskWaitFermentationSlowName.
  ///
  /// In en, this message translates to:
  /// **'Wait for fermentation to slow'**
  String get taskWaitFermentationSlowName;

  /// No description provided for @taskWaitFermentationSlowDescription.
  ///
  /// In en, this message translates to:
  /// **'Wait for the active fermentation to wind down. Rack once the airlock bubbles only occasionally and a layer of sediment has settled at the bottom.'**
  String get taskWaitFermentationSlowDescription;

  /// No description provided for @taskRackWineName.
  ///
  /// In en, this message translates to:
  /// **'Rack the wine'**
  String get taskRackWineName;

  /// No description provided for @taskRackWineDescription.
  ///
  /// In en, this message translates to:
  /// **'- Siphon (rack) the wine into a clean carboy, leaving the sediment (lees) behind.\n- Keep it in a cool room.'**
  String get taskRackWineDescription;

  /// No description provided for @taskMatureWineName.
  ///
  /// In en, this message translates to:
  /// **'Mature the wine'**
  String get taskMatureWineName;

  /// No description provided for @taskMatureWineDescription.
  ///
  /// In en, this message translates to:
  /// **'Let the wine mature for a few months, racking off the sediment every 1-3 months. Typical total bulk aging: light reds 3-6 months, medium reds 6-9 months, full-bodied reds 12 months or more.'**
  String get taskMatureWineDescription;

  /// No description provided for @taskRackWineAgainName.
  ///
  /// In en, this message translates to:
  /// **'Rack the wine again'**
  String get taskRackWineAgainName;

  /// No description provided for @taskRackWineAgainDescription.
  ///
  /// In en, this message translates to:
  /// **'- Siphon (rack) the wine into a clean carboy, leaving the sediment (lees) behind.\n- Keep it in a cool room.'**
  String get taskRackWineAgainDescription;

  /// No description provided for @taskMatureWineAgainName.
  ///
  /// In en, this message translates to:
  /// **'Mature the wine again'**
  String get taskMatureWineAgainName;

  /// No description provided for @taskMatureWineAgainDescription.
  ///
  /// In en, this message translates to:
  /// **'Let the wine mature for a few more months, until it is clear and tastes smooth.'**
  String get taskMatureWineAgainDescription;

  /// No description provided for @taskBottleWineName.
  ///
  /// In en, this message translates to:
  /// **'Bottle the wine'**
  String get taskBottleWineName;

  /// No description provided for @taskBottleWineDescription.
  ///
  /// In en, this message translates to:
  /// **'- Siphon the wine into bottles, leaving the last of the sediment behind.'**
  String get taskBottleWineDescription;

  /// No description provided for @taskResultName.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get taskResultName;

  /// No description provided for @newRealization.
  ///
  /// In en, this message translates to:
  /// **'New realization'**
  String get newRealization;

  /// No description provided for @chooseRecipe.
  ///
  /// In en, this message translates to:
  /// **'Choose a recipe'**
  String get chooseRecipe;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepProgress(int current, int total);

  /// No description provided for @deleteRealizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete realization?'**
  String get deleteRealizationTitle;

  /// No description provided for @deleteRealizationMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes the realization and all its entered data.'**
  String get deleteRealizationMessage;

  /// No description provided for @noRealizationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No realizations yet'**
  String get noRealizationsTitle;

  /// No description provided for @noRealizationsMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New realization\" to start making wine.'**
  String get noRealizationsMessage;

  /// No description provided for @recipeFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipeFallbackTitle;

  /// No description provided for @descriptionFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionFallbackTitle;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @allTasksComplete.
  ///
  /// In en, this message translates to:
  /// **'All tasks complete'**
  String get allTasksComplete;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @semanticsRecipeProgress.
  ///
  /// In en, this message translates to:
  /// **'Recipe progress'**
  String get semanticsRecipeProgress;

  /// No description provided for @semanticsTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} tasks completed'**
  String semanticsTasksCompleted(int completed, int total);

  /// No description provided for @statusCompletedTapToView.
  ///
  /// In en, this message translates to:
  /// **'Completed - tap to view'**
  String get statusCompletedTapToView;

  /// No description provided for @statusTapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start'**
  String get statusTapToStart;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @redoTitle.
  ///
  /// In en, this message translates to:
  /// **'Redo from here?'**
  String get redoTitle;

  /// No description provided for @redoMessage.
  ///
  /// In en, this message translates to:
  /// **'Go back to \"{label}\" and redo from there? Data entered in later tasks will be discarded.'**
  String redoMessage(String label);

  /// No description provided for @realizationCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Realization completed'**
  String get realizationCompletedTitle;

  /// No description provided for @realizationCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have completed every task in this realization.'**
  String get realizationCompletedMessage;

  /// No description provided for @stayHere.
  ///
  /// In en, this message translates to:
  /// **'Stay here'**
  String get stayHere;

  /// No description provided for @backToList.
  ///
  /// In en, this message translates to:
  /// **'Back to list'**
  String get backToList;

  /// No description provided for @renameRealizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename realization'**
  String get renameRealizationTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @addedThisStep.
  ///
  /// In en, this message translates to:
  /// **'Added this step'**
  String get addedThisStep;

  /// No description provided for @addedSugar.
  ///
  /// In en, this message translates to:
  /// **'Added sugar'**
  String get addedSugar;

  /// No description provided for @addedWater.
  ///
  /// In en, this message translates to:
  /// **'Added water'**
  String get addedWater;

  /// No description provided for @yeastAdded.
  ///
  /// In en, this message translates to:
  /// **'Yeast added'**
  String get yeastAdded;

  /// No description provided for @nutrientsAdded.
  ///
  /// In en, this message translates to:
  /// **'Nutrients added'**
  String get nutrientsAdded;

  /// No description provided for @remainingToAdd.
  ///
  /// In en, this message translates to:
  /// **'Remaining to add'**
  String get remainingToAdd;

  /// No description provided for @postponeDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{Postpone {days} day} other{Postpone {days} days}}'**
  String postponeDays(int days);

  /// No description provided for @completeNow.
  ///
  /// In en, this message translates to:
  /// **'Complete now'**
  String get completeNow;

  /// No description provided for @readyToContinue.
  ///
  /// In en, this message translates to:
  /// **'Ready to continue'**
  String get readyToContinue;

  /// No description provided for @waitingPeriodOver.
  ///
  /// In en, this message translates to:
  /// **'The waiting period is over.'**
  String get waitingPeriodOver;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'Reminder on {date}'**
  String reminderOn(String date);

  /// No description provided for @timeLeftDays.
  ///
  /// In en, this message translates to:
  /// **'{days} d {hours} h left'**
  String timeLeftDays(int days, int hours);

  /// No description provided for @timeLeftHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} m left'**
  String timeLeftHours(int hours, int minutes);

  /// No description provided for @timeLeftMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} m {seconds} s left'**
  String timeLeftMinutes(int minutes, int seconds);

  /// No description provided for @resultsLabel.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsLabel;

  /// No description provided for @resultsHint.
  ///
  /// In en, this message translates to:
  /// **'How did the wine turn out? Taste, clarity, strength…'**
  String get resultsHint;

  /// No description provided for @mistakesLabel.
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get mistakesLabel;

  /// No description provided for @mistakesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything to do differently next time?'**
  String get mistakesHint;

  /// No description provided for @presetDry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get presetDry;

  /// No description provided for @presetSemiDry.
  ///
  /// In en, this message translates to:
  /// **'Semi-dry'**
  String get presetSemiDry;

  /// No description provided for @presetSemiSweet.
  ///
  /// In en, this message translates to:
  /// **'Semi-sweet'**
  String get presetSemiSweet;

  /// No description provided for @presetSweet.
  ///
  /// In en, this message translates to:
  /// **'Sweet'**
  String get presetSweet;

  /// No description provided for @presetRedTableWine.
  ///
  /// In en, this message translates to:
  /// **'Red table wine'**
  String get presetRedTableWine;

  /// No description provided for @presetWhiteTableWine.
  ///
  /// In en, this message translates to:
  /// **'White table wine'**
  String get presetWhiteTableWine;

  /// No description provided for @presetLightSparkling.
  ///
  /// In en, this message translates to:
  /// **'Light / sparkling'**
  String get presetLightSparkling;

  /// No description provided for @presetLightWhite.
  ///
  /// In en, this message translates to:
  /// **'Light white'**
  String get presetLightWhite;

  /// No description provided for @presetFullWhite.
  ///
  /// In en, this message translates to:
  /// **'Full white'**
  String get presetFullWhite;

  /// No description provided for @presetLightRed.
  ///
  /// In en, this message translates to:
  /// **'Light red'**
  String get presetLightRed;

  /// No description provided for @presetFullRed.
  ///
  /// In en, this message translates to:
  /// **'Full red'**
  String get presetFullRed;

  /// No description provided for @presetTableWine.
  ///
  /// In en, this message translates to:
  /// **'Table wine'**
  String get presetTableWine;

  /// No description provided for @presetDessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get presetDessert;

  /// No description provided for @presetFortified.
  ///
  /// In en, this message translates to:
  /// **'Fortified'**
  String get presetFortified;

  /// No description provided for @presetWhiteGrape.
  ///
  /// In en, this message translates to:
  /// **'White grape'**
  String get presetWhiteGrape;

  /// No description provided for @presetRedGrape.
  ///
  /// In en, this message translates to:
  /// **'Red grape'**
  String get presetRedGrape;

  /// No description provided for @presetCoolClimateMust.
  ///
  /// In en, this message translates to:
  /// **'Cool-climate must'**
  String get presetCoolClimateMust;

  /// No description provided for @presetApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get presetApple;

  /// No description provided for @presetPear.
  ///
  /// In en, this message translates to:
  /// **'Pear'**
  String get presetPear;

  /// No description provided for @presetPlum.
  ///
  /// In en, this message translates to:
  /// **'Plum'**
  String get presetPlum;

  /// No description provided for @presetSweetCherry.
  ///
  /// In en, this message translates to:
  /// **'Sweet cherry'**
  String get presetSweetCherry;

  /// No description provided for @presetSourCherry.
  ///
  /// In en, this message translates to:
  /// **'Sour cherry'**
  String get presetSourCherry;

  /// No description provided for @presetBlackcurrant.
  ///
  /// In en, this message translates to:
  /// **'Blackcurrant'**
  String get presetBlackcurrant;

  /// No description provided for @presetRedcurrant.
  ///
  /// In en, this message translates to:
  /// **'Redcurrant'**
  String get presetRedcurrant;

  /// No description provided for @presetRaspberry.
  ///
  /// In en, this message translates to:
  /// **'Raspberry'**
  String get presetRaspberry;

  /// No description provided for @presetGooseberry.
  ///
  /// In en, this message translates to:
  /// **'Gooseberry'**
  String get presetGooseberry;

  /// No description provided for @presetStrawberry.
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get presetStrawberry;

  /// No description provided for @presetGrape.
  ///
  /// In en, this message translates to:
  /// **'Grape'**
  String get presetGrape;

  /// No description provided for @presetEgJohanniter.
  ///
  /// In en, this message translates to:
  /// **'e.g. Johanniter 7–9'**
  String get presetEgJohanniter;

  /// No description provided for @presetEgRegent.
  ///
  /// In en, this message translates to:
  /// **'e.g. Regent 6–7'**
  String get presetEgRegent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
