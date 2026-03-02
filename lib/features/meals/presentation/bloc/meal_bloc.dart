import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sevenseers/features/meals/domain/repository/meal_repository.dart';
import 'package:sevenseers/features/meals/presentation/bloc/meal_event.dart';
import 'package:sevenseers/features/meals/presentation/bloc/meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository repository;

  MealBloc({required this.repository}) : super(const MealInitial()) {
    on<LoadDefaultMeals>(_onLoadDefaultMeals);
    on<SearchMeals>(
      _onSearchMeals,
      transformer: _debounceSearch(),
    );
    on<ClearSearch>(_onClearSearch);
  }

  /// Debounce transformer – 500ms delay for search events
  EventTransformer<SearchMeals> _debounceSearch() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(mapper);
  }

  Future<void> _onLoadDefaultMeals(
    LoadDefaultMeals event,
    Emitter<MealState> emit,
  ) async {
    emit(const MealLoading());
    try {
      final meals = await repository.getDefaultMeals();
      if (meals.isEmpty) {
        emit(const MealEmpty());
      } else {
        emit(MealLoaded(meals: meals));
      }
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> _onSearchMeals(
    SearchMeals event,
    Emitter<MealState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const LoadDefaultMeals());
      return;
    }

    emit(const MealLoading());
    try {
      final meals = await repository.searchMeals(event.query.trim());
      if (meals.isEmpty) {
        emit(MealEmpty(query: event.query));
      } else {
        emit(MealLoaded(
          meals: meals,
          isSearchResult: true,
          searchQuery: event.query,
        ));
      }
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<MealState> emit,
  ) async {
    add(const LoadDefaultMeals());
  }
}
