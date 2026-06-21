import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';

/// Browse the built-in recipes. Tapping one opens its read-only task list.
class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const recipes = AvailableRecipes.values;
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: recipes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _RecipeTile(recipe: recipes[index]),
        ),
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe});

  final AvailableRecipes recipe;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskCount = recipe.getRecipe().tasks.length;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          child: const Icon(Icons.local_bar_outlined),
        ),
        title: Text(recipe.displayName),
        subtitle: Text('$taskCount step${taskCount == 1 ? '' : 's'}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed(
          AppRoute.recipeDetail,
          pathParameters: {AppRoute.recipeNameParam: recipe.name},
        ),
      ),
    );
  }
}
