import 'package:flutter/material.dart';
import 'package:sevenseers/core/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String query;

  const EmptyStateWidget({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.no_meals_rounded,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              query.isNotEmpty ? 'No results found' : 'No recipes available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              query.isNotEmpty
                  ? 'Try "chicken", "pasta", or "dessert"'
                  : 'Pull down to refresh',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
