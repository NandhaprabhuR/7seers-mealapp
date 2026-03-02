import 'package:equatable/equatable.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object?> get props => [];
}

class LoadDefaultMeals extends MealEvent {
  const LoadDefaultMeals();
}

class SearchMeals extends MealEvent {
  final String query;

  const SearchMeals(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends MealEvent {
  const ClearSearch();
}
