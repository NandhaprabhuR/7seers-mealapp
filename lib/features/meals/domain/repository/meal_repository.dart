import 'package:sevenseers/features/meals/data/models/meal_model.dart';

abstract class MealRepository {
  Future<List<MealModel>> getDefaultMeals();
  Future<List<MealModel>> searchMeals(String query);
  Future<MealModel> getMealById(String id);
}
