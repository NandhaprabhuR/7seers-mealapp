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

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final clampedIndex = widget.index.clamp(0, 5);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (clampedIndex * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isPressed ? 0.03 : 0.06),
                  blurRadius: _isPressed ? 6 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MealCardImage(meal: widget.meal),
                _MealCardInfo(meal: widget.meal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MealCardImage extends StatelessWidget {
  final MealModel meal;

  const _MealCardImage({required this.meal});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Hero(
        tag: 'meal-image-${meal.id}',
        child: CachedNetworkImage(
          imageUrl: meal.thumbnail ?? '',
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            height: 200,
            color: AppColors.shimmerBase,
            child: const Center(
              child: Icon(
                Icons.restaurant_rounded,
                size: 40,
                color: AppColors.textLight,
              ),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            height: 200,
            color: AppColors.shimmerBase,
            child: const Center(
              child: Icon(
                Icons.broken_image_rounded,
                size: 40,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MealCardInfo extends StatelessWidget {
  final MealModel meal;

  const _MealCardInfo({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.name,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (meal.category != null) ...[
                _CategoryTag(label: meal.category!, color: AppColors.primary),
                const SizedBox(width: 12),
              ],
              if (meal.area != null)
                _CategoryTag(
                  label: meal.area!,
                  icon: Icons.public_rounded,
                  color: AppColors.accent,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryTag({
    required this.label,
    this.icon = Icons.category_rounded,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
