import 'package:go_router/go_router.dart';
import 'package:winemaker/features/calculator/presentation/calculator_screen.dart';
import 'package:winemaker/features/realization/presentation/recipe_view.dart';
import 'package:winemaker/features/realization/presentation/adding_ingredients_screen.dart';
import 'package:winemaker/features/realization/presentation/description_screen.dart';
import 'package:winemaker/features/realization/presentation/initial_measurement_screen.dart';
import 'package:winemaker/features/realization/presentation/result_screen.dart';
import 'package:winemaker/features/realization/presentation/calculations_screen.dart';
import 'package:winemaker/features/realization/presentation/recipe_realizations_list_screen.dart';
import 'package:winemaker/features/realization/presentation/time_notification_screen.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/domain/task.dart';
import 'package:winemaker/features/recipe/presentation/recipe_detail_screen.dart';
import 'package:winemaker/features/recipe/presentation/recipes_screen.dart';
import 'package:winemaker/l10n/app_localizations.dart';

class AppRoute {
  static const realizationIdParam = 'realizationId';
  static const recipeNameParam = 'recipeName';

  static const home = 'home';
  static const calculator = 'calculator';
  static const recipes = 'recipes';
  static const recipeDetail = 'recipeDetail';
  static const recipe = 'recipe';
  static const description = 'description';
  static const initialMeasurement = 'initialMeasurement';
  static const calculations = 'calculations';
  static const addingIngredients = 'addingIngredients';
  static const result = 'result';
  static const timeNotification = 'timeNotification';
}

class DescriptionScreenArgs {
  const DescriptionScreenArgs({
    required this.title,
    required this.markdown,
    this.readOnly = false,
  });

  final String title;
  final String markdown;
  final bool readOnly;
}

class InitialMeasurementScreenArgs {
  const InitialMeasurementScreenArgs({
    required this.title,
    required this.taskId,
    required this.description,
    this.readOnly = false,
  });

  final String title;
  final RecipeTaskId taskId;
  final String description;
  final bool readOnly;
}

class CalculationsScreenArgs {
  const CalculationsScreenArgs({
    required this.title,
    required this.taskId,
    required this.description,
    required this.sweetnessTaskId,
    this.readOnly = false,
  });

  final String title;
  final RecipeTaskId taskId;
  final String description;

  /// Task holding the pre-fermentation sweetness reading, or null if no
  /// earlier task records one.
  final RecipeTaskId? sweetnessTaskId;
  final bool readOnly;
}

class AddingIngredientsScreenArgs {
  const AddingIngredientsScreenArgs({
    required this.title,
    required this.taskId,
    required this.description,
    required this.ingredients,
    required this.calculationsTaskId,
    required this.priorIngredientTaskIds,
    this.readOnly = false,
  });

  final String title;
  final RecipeTaskId taskId;
  final String description;

  /// Which ingredients this step asks the user about.
  final Set<IngredientKind> ingredients;

  /// The `calculations` task holding the calculated total, or null if none
  /// precedes this task.
  final RecipeTaskId? calculationsTaskId;

  /// Earlier `addingIngredients` tasks whose added amounts are subtracted from
  /// the total to get the remaining-to-add.
  final List<RecipeTaskId> priorIngredientTaskIds;
  final bool readOnly;
}

class ResultScreenArgs {
  const ResultScreenArgs({
    required this.title,
    required this.taskId,
    this.readOnly = false,
  });

  final String title;
  final RecipeTaskId taskId;
  final bool readOnly;
}

class TimeNotificationScreenArgs {
  const TimeNotificationScreenArgs({
    required this.title,
    required this.taskId,
    required this.description,
    required this.delay,
    required this.postpone,
    this.readOnly = false,
  });

  final String title;
  final RecipeTaskId taskId;
  final String description;
  final Duration delay;
  final Duration postpone;
  final bool readOnly;
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const RecipeRealizationsListScreen(),
    ),
    GoRoute(
      path: '/calculator',
      name: AppRoute.calculator,
      builder: (context, state) => const CalculatorScreen(),
    ),
    GoRoute(
      path: '/recipes',
      name: AppRoute.recipes,
      builder: (context, state) => const RecipesScreen(),
      routes: [
        GoRoute(
          path: ':${AppRoute.recipeNameParam}',
          name: AppRoute.recipeDetail,
          builder: (context, state) =>
              RecipeDetailScreen(recipe: _recipe(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/realization/:${AppRoute.realizationIdParam}',
      name: AppRoute.recipe,
      builder: (context, state) =>
          RecipeViewWrapper(realizationId: _realizationId(state)),
      routes: [
        GoRoute(
          path: 'description',
          name: AppRoute.description,
          builder: (context, state) {
            final args = state.extra as DescriptionScreenArgs?;
            return DescriptionScreen(
              title: args?.title ??
                  AppLocalizations.of(context).descriptionFallbackTitle,
              markdown: args?.markdown ?? '',
              readOnly: args?.readOnly ?? false,
            );
          },
        ),
        GoRoute(
          path: 'initial-measurement',
          name: AppRoute.initialMeasurement,
          builder: (context, state) {
            final args = state.extra as InitialMeasurementScreenArgs;
            return InitialMeasurementScreen(
              realizationId: _realizationId(state),
              taskId: args.taskId,
              title: args.title,
              description: args.description,
              readOnly: args.readOnly,
            );
          },
        ),
        GoRoute(
          path: 'calculations',
          name: AppRoute.calculations,
          builder: (context, state) {
            final args = state.extra as CalculationsScreenArgs;
            return CalculationsScreen(
              realizationId: _realizationId(state),
              taskId: args.taskId,
              title: args.title,
              description: args.description,
              sweetnessTaskId: args.sweetnessTaskId,
              readOnly: args.readOnly,
            );
          },
        ),
        GoRoute(
          path: 'adding-ingredients',
          name: AppRoute.addingIngredients,
          builder: (context, state) {
            final args = state.extra as AddingIngredientsScreenArgs;
            return AddingIngredientsScreen(
              realizationId: _realizationId(state),
              taskId: args.taskId,
              title: args.title,
              description: args.description,
              ingredients: args.ingredients,
              calculationsTaskId: args.calculationsTaskId,
              priorIngredientTaskIds: args.priorIngredientTaskIds,
              readOnly: args.readOnly,
            );
          },
        ),
        GoRoute(
          path: 'result',
          name: AppRoute.result,
          builder: (context, state) {
            final args = state.extra as ResultScreenArgs;
            return ResultScreen(
              realizationId: _realizationId(state),
              taskId: args.taskId,
              title: args.title,
              readOnly: args.readOnly,
            );
          },
        ),
        GoRoute(
          path: 'time-notification',
          name: AppRoute.timeNotification,
          builder: (context, state) {
            final args = state.extra as TimeNotificationScreenArgs;
            return TimeNotificationScreen(
              realizationId: _realizationId(state),
              taskId: args.taskId,
              title: args.title,
              description: args.description,
              delay: args.delay,
              postpone: args.postpone,
              readOnly: args.readOnly,
            );
          },
        ),
      ],
    ),
  ],
);

int _realizationId(GoRouterState state) =>
    int.parse(state.pathParameters[AppRoute.realizationIdParam]!);

AvailableRecipes _recipe(GoRouterState state) => AvailableRecipes.values
    .byName(state.pathParameters[AppRoute.recipeNameParam]!);
