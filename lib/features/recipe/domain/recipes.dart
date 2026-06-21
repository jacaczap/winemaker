import 'package:winemaker/features/recipe/domain/recipe.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/recipe/domain/task_type.dart';

const Recipe redWineRecipe = Recipe([
  Task(
    'Prepare the fruit',
    TaskType.description,
    description: '- Collect the fruit and put it in the fermentation bucket.\n'
        '- Squash it to release the juice.\n'
        '- Take the must measurements you will need in the next step '
        '(volume, sweetness, acidity).',
  ),
  Task('Calculations', TaskType.calculations),
  Task(
    'Add ingredients',
    TaskType.addingIngredients,
    description: 'Add the yeast, nutrients, the first sugar portion '
        'and water.',
  ),
  Task(
    'Ferment with the skins',
    TaskType.timeNotification,
    description: 'Let it ferment in the bucket together with the fruit skins '
        'in a warm room.',
    notification: TimeNotificationParams(
      delay: Duration(days: 14),
      postpone: Duration(days: 2),
    ),
  ),
  Task(
    'Move to the bottle',
    TaskType.description,
    description: '- Squeeze the mass and discard the solids.\n'
        '- Move the juice into a glass fermentation bottle.\n'
        '- Keep it in a warm room.',
  ),
  Task(
    'Wait for the sugar to drop',
    TaskType.timeNotification,
    description: 'Wait until the sugar level drops noticeably.',
    notification: TimeNotificationParams(
      delay: Duration(days: 14),
      postpone: Duration(days: 2),
    ),
  ),
  Task(
    'Add remaining sugar',
    TaskType.addingIngredients,
    description: 'Add the remaining sugar portion.',
  ),
  Task(
    'Wait for fermentation to slow',
    TaskType.timeNotification,
    description: 'Wait until the fermentation slows down a lot.',
    notification: TimeNotificationParams(
      delay: Duration(days: 14),
      postpone: Duration(days: 7),
    ),
  ),
  Task(
    'Rack the wine',
    TaskType.description,
    description: '- Rack the wine into another bottle.\n'
        '- Discard the sediment.\n'
        '- Keep it in a cool room.',
  ),
  Task(
    'Mature the wine',
    TaskType.timeNotification,
    description: 'Let the wine mature for a few months.',
    notification: TimeNotificationParams(
      delay: Duration(days: 90),
      postpone: Duration(days: 14),
    ),
  ),
  Task(
    'Rack the wine again',
    TaskType.description,
    description: '- Rack the wine into another bottle.\n'
        '- Discard the sediment.\n'
        '- Keep it in a cool room.',
  ),
  Task(
    'Mature the wine again',
    TaskType.timeNotification,
    description: 'Let the wine mature for a few more months.',
    notification: TimeNotificationParams(
      delay: Duration(days: 90),
      postpone: Duration(days: 14),
    ),
  ),
  Task(
    'Bottle the wine',
    TaskType.description,
    description: '- Pour the wine into bottles.\n'
        '- Discard the sediment.',
  ),
  Task('Result', TaskType.result),
]);

enum AvailableRecipes {
  redWine,
}

extension AvaliableRecipesExtension on AvailableRecipes {
  Recipe getRecipe() {
    switch (this) {
      case AvailableRecipes.redWine:
        return redWineRecipe;
    }
  }

  String get displayName {
    switch (this) {
      case AvailableRecipes.redWine:
        return 'Red Wine';
    }
  }
}
