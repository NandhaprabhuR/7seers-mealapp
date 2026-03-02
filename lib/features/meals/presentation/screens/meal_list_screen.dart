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

class _MealListScreenState extends State<MealListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _searchAnimController;
  late Animation<double> _searchWidthAnimation;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _searchWidthAnimation = CurvedAnimation(
      parent: _searchAnimController,
      curve: Curves.easeOutCubic,
    );
    context.read<MealBloc>().add(const LoadDefaultMeals());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) {
        _searchAnimController.forward();
      } else {
        _searchAnimController.reverse();
        if (_searchController.text.isNotEmpty) {
          _searchController.clear();
          context.read<MealBloc>().add(const ClearSearch());
        }
      }
    });
  }

  void _onSearchChanged(String query) {
    context.read<MealBloc>().add(SearchMeals(query));
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<MealBloc>().add(const ClearSearch());
  }

  void _navigateToDetail(MealModel meal) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
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
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                      onRetry: () {
                        context.read<MealBloc>().add(const LoadDefaultMeals());
                      },
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                    ),
                    Text(
                      'What would you like to cook?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleSearch,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isSearchExpanded
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _isSearchExpanded
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                      color: _isSearchExpanded
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizeTransition(
            sizeFactor: _searchWidthAnimation,
            axisAlignment: -1.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search meals...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (_, value, __) {
                        if (value.text.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: _clearSearch,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: meals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
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
