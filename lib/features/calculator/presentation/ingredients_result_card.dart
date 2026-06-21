import 'package:flutter/material.dart';
import 'package:winemaker/features/calculator/domain/ingredients.dart';

/// Displays the ingredients computed from desired wine + must measurements.
class IngredientsResultCard extends StatelessWidget {
  const IngredientsResultCard({super.key, required this.ingredients});

  final Ingredients ingredients;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ingredients to add', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _IngredientRow(
              icon: Icons.scale_outlined,
              label: 'Sugar',
              value: '${ingredients.sugar.value} kg',
            ),
            _IngredientRow(
              icon: Icons.water_drop_outlined,
              label: 'Water',
              value: '${ingredients.water.value} l',
            ),
            _IngredientRow(
              icon: Icons.science_outlined,
              label: 'Yeast',
              value: ingredients.yeast ? 'Add' : 'Not needed',
            ),
            _IngredientRow(
              icon: Icons.eco_outlined,
              label: 'Nutrients',
              value: ingredients.nutrients ? 'Add' : 'Not needed',
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(
            value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
