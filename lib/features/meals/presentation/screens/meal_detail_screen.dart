import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sevenseers/core/theme/app_colors.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';
import 'package:sevenseers/features/meals/presentation/widgets/ingredient_list_card.dart';
import 'package:sevenseers/features/meals/presentation/widgets/section_title.dart';
import 'package:sevenseers/features/meals/presentation/widgets/youtube_button.dart';

class MealDetailScreen extends StatelessWidget {
  final MealModel meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _DetailAppBar(meal: meal),
          SliverToBoxAdapter(
            child: _DetailBody(meal: meal),
          ),
        ],
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final MealModel meal;

  const _DetailAppBar({required this.meal});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.surfaceDark,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'meal-image-${meal.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: meal.thumbnail ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.shimmerBase,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.shimmerBase,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
              Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.darkOverlay),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final MealModel meal;

  const _DetailBody({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _TagRow(meal: meal),
          const SizedBox(height: 24),
          if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty) ...[
            YoutubeButton(url: meal.youtubeUrl!),
            const SizedBox(height: 24),
          ],
          if (meal.ingredients.isNotEmpty) ...[
            const SectionTitle(
              title: 'Ingredients',
              icon: Icons.shopping_basket_rounded,
            ),
            const SizedBox(height: 12),
            IngredientListCard(ingredients: meal.ingredients),
            const SizedBox(height: 24),
          ],
          if (meal.instructions != null && meal.instructions!.isNotEmpty) ...[
            const SectionTitle(
              title: 'Instructions',
              icon: Icons.menu_book_rounded,
            ),
            const SizedBox(height: 12),
            _InstructionsCard(text: meal.instructions!),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  final MealModel meal;

  const _TagRow({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (meal.category != null)
          _InfoChip(
            icon: Icons.category_rounded,
            label: meal.category!,
            color: AppColors.primary,
          ),
        if (meal.area != null)
          _InfoChip(
            icon: Icons.public_rounded,
            label: meal.area!,
            color: AppColors.accent,
          ),
        if (meal.tags != null && meal.tags!.isNotEmpty)
          ...meal.tags!.split(',').map((tag) => _InfoChip(
                icon: Icons.tag_rounded,
                label: tag.trim(),
                color: AppColors.accentYellow,
              )),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _InstructionsCard extends StatelessWidget {
  final String text;

  const _InstructionsCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.7,
              color: AppColors.textPrimary.withValues(alpha: 0.85),
            ),
      ),
    );
  }
}
