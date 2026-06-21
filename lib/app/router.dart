import 'package:go_router/go_router.dart';
import 'package:winemaker/features/realization/presentation/recipe_view.dart';
import 'package:winemaker/features/realization/presentation/description_screen.dart';
import 'package:winemaker/features/realization/presentation/welcome_screen.dart';

class AppRoute {
  static const realizationIdParam = 'realizationId';

  static const welcome = 'welcome';
  static const recipe = 'recipe';
  static const description = 'description';
}

class DescriptionScreenArgs {
  const DescriptionScreenArgs({required this.title, required this.markdown});

  final String title;
  final String markdown;
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.welcome,
      builder: (context, state) => const WelcomeScreen(),
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
            );
          },
        ),
      ],
    ),
  ],
);

int _realizationId(GoRouterState state) =>
    int.parse(state.pathParameters[AppRoute.realizationIdParam]!);
