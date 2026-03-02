import 'package:flutter/material.dart';
import 'package:sevenseers/core/theme/app_colors.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';

class IngredientListCard extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientListCard({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: ingredients.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 56,
          color: AppColors.shimmerBase,
        ),
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return _IngredientTile(
            ingredient: ingredient,
            index: index,
          );
        },
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final int index;

  const _IngredientTile({
    required this.ingredient,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(
            alpha: 0.08 + (index * 0.02).clamp(0.0, 0.15),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
      title: Text(
        ingredient.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text(
        ingredient.measure,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
