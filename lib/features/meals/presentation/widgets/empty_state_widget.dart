import 'package:flutter/material.dart';
import 'package:sevenseers/core/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String query;

  const EmptyStateWidget({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accentYellow.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 48,
                color: AppColors.accentYellow,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              query.isNotEmpty ? 'No meals found' : 'No meals available',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              query.isNotEmpty
                  ? 'Try searching for something else\nlike "pasta" or "chicken"'
                  : 'Pull to refresh or try a different search',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
