import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevenseers/core/theme/app_colors.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';
import 'package:sevenseers/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:sevenseers/features/meals/presentation/bloc/meal_event.dart';
import 'package:sevenseers/features/meals/presentation/bloc/meal_state.dart';
import 'package:sevenseers/features/meals/presentation/screens/meal_detail_screen.dart';
import 'package:sevenseers/features/meals/presentation/widgets/empty_state_widget.dart';
import 'package:sevenseers/features/meals/presentation/widgets/meal_card.dart';
import 'package:sevenseers/features/meals/presentation/widgets/meal_error_widget.dart';
import 'package:sevenseers/features/meals/presentation/widgets/shimmer_loading.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  int _selectedCategoryIndex = 0;

  static const List<String> _categories = [
    'All',
    'Chicken',
    'Beef',
    'Seafood',
    'Pasta',
    'Dessert',
    'Vegetarian',
    'Lamb',
    'Pork',
    'Side',
  ];

  @override
  void initState() {
    super.initState();
    context.read<MealBloc>().add(const LoadDefaultMeals());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<MealBloc>().add(SearchMeals(query));
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocus.unfocus();
    setState(() => _selectedCategoryIndex = 0);
    context.read<MealBloc>().add(const ClearSearch());
  }

  void _onCategoryTap(int index) {
    setState(() => _selectedCategoryIndex = index);
    _searchController.clear();
    _searchFocus.unfocus();

    if (index == 0) {
      context.read<MealBloc>().add(const LoadDefaultMeals());
    } else {
      context.read<MealBloc>().add(SearchMeals(_categories[index]));
    }
  }

  void _navigateToDetail(MealModel meal) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => MealDetailScreen(meal: meal),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search - not scrollable, stays pinned
            _buildHeader(),
            // Category chips
            _buildCategoryChips(),
            // Meal list content
            Expanded(
              child: BlocBuilder<MealBloc, MealState>(
                builder: (context, state) {
                  if (state is MealLoading) {
                    return const ShimmerListLoading();
                  } else if (state is MealLoaded) {
                    return _buildMealList(state.meals);
                  } else if (state is MealEmpty) {
                    return EmptyStateWidget(query: state.query);
                  } else if (state is MealError) {
                    return MealErrorWidget(
                      message: state.message,
                      onRetry: () =>
                          context.read<MealBloc>().add(const LoadDefaultMeals()),
                    );
                  }
                  return const ShimmerListLoading();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover Recipes',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'What would you like to cook today?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.shimmerBase),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.search_rounded, size: 20, color: AppColors.textLight),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: _onSearchChanged,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: const InputDecoration(
                      hintText: 'Search for recipes, cuisines...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (_, value, __) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: _clearSearch,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final isSelected = index == _selectedCategoryIndex;
            return GestureDetector(
              onTap: () => _onCategoryTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.shimmerBase,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _categories[index],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealList(List<MealModel> meals) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<MealBloc>().add(const LoadDefaultMeals());
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: meals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final meal = meals[index];
          return MealCard(
            meal: meal,
            index: index,
            onTap: () => _navigateToDetail(meal),
          );
        },
      ),
    );
  }
}
