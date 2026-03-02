import 'package:equatable/equatable.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

class MealInitial extends MealState {
  const MealInitial();
}

class MealLoading extends MealState {
  const MealLoading();
}

class MealLoaded extends MealState {
  final List<MealModel> meals;
  final bool isSearchResult;
  final String searchQuery;

  const MealLoaded({
    required this.meals,
    this.isSearchResult = false,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [meals, isSearchResult, searchQuery];
}

class MealEmpty extends MealState {
  final String query;

  const MealEmpty({this.query = ''});

  @override
  List<Object?> get props => [query];
}

class MealError extends MealState {
  final String message;

  const MealError(this.message);

  @override
  List<Object?> get props => [message];
}
