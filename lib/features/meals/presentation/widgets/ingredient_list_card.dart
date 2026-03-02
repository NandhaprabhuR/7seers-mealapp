import 'package:flutter/material.dart';
import 'package:sevenseers/core/theme/app_colors.dart';

class IngredientListCard extends StatelessWidget {
  final List<dynamic> ingredients;

  const IngredientListCard({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.shimmerBase),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: ingredients.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 52,
          color: AppColors.shimmerBase.withValues(alpha: 0.6),
        ),
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06 + (index * 0.015).clamp(0.0, 0.12)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ingredient.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  ingredient.measure,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
