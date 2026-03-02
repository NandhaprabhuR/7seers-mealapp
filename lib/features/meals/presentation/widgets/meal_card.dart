import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sevenseers/core/theme/app_colors.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';

class MealCard extends StatefulWidget {
  final MealModel meal;
  final VoidCallback onTap;
  final int index;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.index,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final clampedIndex = widget.index.clamp(0, 5);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 350 + (clampedIndex * 60)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImageSection(meal: widget.meal),
                _InfoSection(meal: widget.meal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final MealModel meal;

  const _ImageSection({required this.meal});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'meal-image-${meal.id}',
              child: CachedNetworkImage(
                imageUrl: meal.thumbnail ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.shimmerBase,
                  child: const Center(
                    child: Icon(Icons.restaurant, size: 32, color: AppColors.textLight),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.shimmerBase,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 32, color: AppColors.textLight),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: const BoxDecoration(gradient: AppColors.cardGradient),
              ),
            ),
            if (meal.area != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    meal.area!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final MealModel meal;

  const _InfoSection({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (meal.category != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    meal.category!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(Icons.timer_outlined, size: 13, color: AppColors.textLight),
              const SizedBox(width: 3),
              Text(
                '30-45 min',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const _DotSeparator(),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.shimmerBase,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DotSeparator extends StatelessWidget {
  const _DotSeparator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Container(
          width: 3,
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
