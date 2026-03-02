import 'package:sevenseers/features/meals/domain/repository/meal_repository.dart';
import 'package:sevenseers/features/meals/data/datasource/meal_remote_datasource.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  MealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MealModel>> getDefaultMeals() async {
    try {
      return await remoteDataSource.getDefaultMeals();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    try {
      return await remoteDataSource.searchMeals(query);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MealModel> getMealById(String id) async {
    try {
      return await remoteDataSource.getMealById(id);
    } catch (e) {
      rethrow;
    }
  }
}
