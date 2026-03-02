import 'package:flutter_test/flutter_test.dart';
import 'package:sevenseers/features/meals/data/models/meal_model.dart';

void main() {
  group('MealModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'idMeal': '12345',
        'strMeal': 'Test Meal',
        'strCategory': 'Chicken',
        'strArea': 'Indian',
        'strInstructions': 'Cook it well',
        'strMealThumb': 'https://example.com/image.jpg',
        'strTags': 'Spicy,Meat',
        'strYoutube': 'https://youtube.com/watch?v=abc',
        'strIngredient1': 'Chicken',
        'strMeasure1': '500g',
        'strIngredient2': 'Salt',
        'strMeasure2': '1 tsp',
        'strIngredient3': '',
        'strMeasure3': '',
      };

      final meal = MealModel.fromJson(json);

      expect(meal.id, '12345');
      expect(meal.name, 'Test Meal');
      expect(meal.category, 'Chicken');
      expect(meal.area, 'Indian');
      expect(meal.ingredients.length, 2);
      expect(meal.ingredients[0].name, 'Chicken');
      expect(meal.ingredients[0].measure, '500g');
      expect(meal.ingredients[1].name, 'Salt');
    });

    test('fromJson handles null meals', () {
      final json = {
        'idMeal': '99',
        'strMeal': 'Empty Meal',
        'strCategory': null,
        'strArea': null,
        'strInstructions': null,
        'strMealThumb': null,
        'strTags': null,
        'strYoutube': null,
      };

      final meal = MealModel.fromJson(json);

      expect(meal.id, '99');
      expect(meal.name, 'Empty Meal');
      expect(meal.category, isNull);
      expect(meal.ingredients.isEmpty, true);
    });
  });
}
