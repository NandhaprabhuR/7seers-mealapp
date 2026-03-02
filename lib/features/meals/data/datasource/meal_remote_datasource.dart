import 'package:sevenseers/core/constants/api_constants.dart';
import 'package:sevenseers/core/network/api_client.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> getDefaultMeals();
  Future<List<MealModel>> searchMeals(String query);
  Future<MealModel> getMealById(String id);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final ApiClient apiClient;

  MealRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MealModel>> getDefaultMeals() async {
    final response = await apiClient.get(ApiConstants.defaultSearch);
    return _parseMeals(response);
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    final url = '${ApiConstants.searchEndpoint}?s=$query';
    final response = await apiClient.get(url);
    return _parseMeals(response);
  }

  @override
  Future<MealModel> getMealById(String id) async {
    final url = '${ApiConstants.lookupEndpoint}?i=$id';
    final response = await apiClient.get(url);
    final meals = _parseMeals(response);
    if (meals.isEmpty) {
      throw Exception('Meal not found');
    }
    return meals.first;
  }

  List<MealModel> _parseMeals(Map<String, dynamic> response) {
    final mealsJson = response['meals'] as List<dynamic>?;
    if (mealsJson == null) return [];
    return mealsJson
        .map((json) => MealModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
