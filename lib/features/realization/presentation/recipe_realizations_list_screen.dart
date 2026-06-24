import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:winemaker/app/router.dart';
import 'package:winemaker/features/realization/domain/recipe_realization.dart';
import 'package:winemaker/features/realization/presentation/recipe_realization_controller.dart';
import 'package:winemaker/features/realization/presentation/rename_realization_dialog.dart';
import 'package:winemaker/features/recipe/domain/recipes.dart';
import 'package:winemaker/l10n/app_localizations.dart';

/// Home screen listing the user's realizations.
///
/// In-progress realizations appear first (most recent first), completed ones
/// are marked and sorted to the bottom. The user can open, delete, or start a
/// new realization, and reach the Recipes and Calculator screens.
class RecipeRealizationsListScreen extends ConsumerWidget {
  const RecipeRealizationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realizations = ref.watch(recipeRealizationsControllerProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Winemaker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            tooltip: l10n.recipesTitle,
            onPressed: () => context.pushNamed(AppRoute.recipes),
          ),
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: l10n.calculatorTitle,
            onPressed: () => context.pushNamed(AppRoute.calculator),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.newRealization),
        onPressed: () => _startNewRealization(context, ref),
      ),
      body: SafeArea(
        child: realizations.when(
          data: (items) => items.isEmpty
              ? const _EmptyState()
              : _RealizationList(realizations: items),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(l10n.errorWithMessage(error))),
        ),
      ),
    );
  }

  Future<void> _startNewRealization(BuildContext context, WidgetRef ref) async {
    final recipe = await _pickRecipe(context);
    if (recipe == null || !context.mounted) return;
    final id =
        await ref.read(recipeRealizationsControllerProvider.notifier).create(
              recipe,
            );
    if (!context.mounted) return;
    context.pushNamed(
      AppRoute.recipe,
      pathParameters: {AppRoute.realizationIdParam: '$id'},
    );
  }

  Future<AvailableRecipes?> _pickRecipe(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<AvailableRecipes>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l10n.chooseRecipe,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final recipe in AvailableRecipes.values)
              ListTile(
                leading: const Icon(Icons.local_bar_outlined),
                title: Text(recipe.displayName(l10n)),
                onTap: () => Navigator.of(context).pop(recipe),
              ),
          ],
        ),
      ),
    );
  }
}

class _RealizationList extends StatelessWidget {
  const _RealizationList({required this.realizations});

  final List<RecipeRealization> realizations;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: realizations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _RealizationTile(
        realization: realizations[index],
      ),
    );
  }
}

class _RealizationTile extends ConsumerWidget {
  const _RealizationTile({required this.realization});

  final RecipeRealization realization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final totalTasks = realization.recipe.getRecipe().tasks.length;
    final completed = realization.completed;
    final startedOn = DateFormat('d MMM y, HH:mm', l10n.localeName)
        .format(realization.startTime);
    final progress = completed
        ? l10n.completed
        : l10n.stepProgress(
            (realization.currentTask + 1).clamp(1, totalTasks),
            totalTasks,
          );

    return Dismissible(
      key: ValueKey(realization.id),
      direction: DismissDirection.endToStart,
      background: _deleteBackground(colors),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => ref
          .read(recipeRealizationsControllerProvider.notifier)
          .delete(realization.id),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                completed ? colors.surfaceContainerHighest : colors.primaryContainer,
            foregroundColor:
                completed ? colors.onSurfaceVariant : colors.onPrimaryContainer,
            child: Icon(
              completed ? Icons.check : Icons.local_bar_outlined,
            ),
          ),
          title: Text(realization.displayName(l10n)),
          subtitle: Text('$progress  -  $startedOn'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed(
            AppRoute.recipe,
            pathParameters: {
              AppRoute.realizationIdParam: '${realization.id}',
            },
          ),
          onLongPress: () => _rename(context, ref),
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final name = await showRenameRealizationDialog(
      context,
      currentName: realization.displayName(AppLocalizations.of(context)),
    );
    if (name == null) return;
    await ref
        .read(recipeRealizationsControllerProvider.notifier)
        .rename(realization.id, name);
  }

  Widget _deleteBackground(ColorScheme colors) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: colors.onErrorContainer),
      );

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRealizationTitle),
        content: Text(l10n.deleteRealizationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_bar_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noRealizationsTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noRealizationsMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
