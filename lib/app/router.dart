import 'package:go_router/go_router.dart';
import 'package:winemaker/features/calculator/presentation/calculator_screen.dart';
import 'package:winemaker/features/realization/presentation/recipe_view.dart';
import 'package:winemaker/features/realization/presentation/adding_ingredients_screen.dart';
import 'package:winemaker/features/realization/presentation/description_screen.dart';
import 'package:winemaker/features/realization/presentation/result_screen.dart';
import 'package:winemaker/features/realization/presentation/calculations_screen.dart';
import 'package:winemaker/features/realization/presentation/recipe_realizations_list_screen.dart';
import 'package:winemaker/features/realization/presentation/time_notification_screen.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/features/recipe/presentation/recipe_detail_screen.dart';
import 'package:winemaker/features/recipe/presentation/recipes_screen.dart';

class AppRoute {
  static const realizationIdParam = 'realizationId';
  static const recipeNameParam = 'recipeName';

  static const home = 'home';
  static const calculator = 'calculator';
  static const recipes = 'recipes';
  static const recipeDetail = 'recipeDetail';
  static const recipe = 'recipe';
  static const description = 'description';
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

class CalculationsScreenArgs {
  const CalculationsScreenArgs({
    required this.title,
    required this.taskIndex,
    this.readOnly = false,
  });

  final String title;
  final int taskIndex;
  final bool readOnly;
}

class AddingIngredientsScreenArgs {
  const AddingIngredientsScreenArgs({
    required this.title,
    required this.taskIndex,
    required this.description,
    required this.calculationsTaskIndex,
    required this.priorIngredientTaskIndices,
    this.readOnly = false,
  });

  final String title;
  final int taskIndex;
  final String description;

  /// Task index of the `calculations` occurrence holding the calculated total,
  /// or null if none precedes this task.
  final int? calculationsTaskIndex;

  /// Task indices of earlier `addingIngredients` occurrences whose added
  /// amounts are subtracted from the total to get the remaining-to-add.
  final List<int> priorIngredientTaskIndices;
  final bool readOnly;
}

class ResultScreenArgs {
  const ResultScreenArgs({
    required this.title,
    required this.taskIndex,
    this.readOnly = false,
  });

  final String title;
  final int taskIndex;
  final bool readOnly;
}

class TimeNotificationScreenArgs {
  const TimeNotificationScreenArgs({
    required this.title,
    required this.taskIndex,
    required this.description,
    required this.delay,
    required this.postpone,
    this.readOnly = false,
  });

  final String title;
  final int taskIndex;
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
              title: args?.title ?? 'Description',
              markdown: args?.markdown ?? '',
              readOnly: args?.readOnly ?? false,
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
              taskIndex: args.taskIndex,
              title: args.title,
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
              taskIndex: args.taskIndex,
              title: args.title,
              description: args.description,
              calculationsTaskIndex: args.calculationsTaskIndex,
              priorIngredientTaskIndices: args.priorIngredientTaskIndices,
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
              taskIndex: args.taskIndex,
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
              taskIndex: args.taskIndex,
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
