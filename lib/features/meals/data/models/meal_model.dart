import 'package:equatable/equatable.dart';

class MealModel extends Equatable {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? thumbnail;
  final String? tags;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;

  const MealModel({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.instructions,
    this.thumbnail,
    this.tags,
    this.youtubeUrl,
    this.ingredients = const [],
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(Ingredient(
          name: ingredient.trim(),
          measure: (measure != null && measure.trim().isNotEmpty)
              ? measure.trim()
              : '',
        ));
      }
    }

    return MealModel(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      instructions: json['strInstructions'] as String?,
      thumbnail: json['strMealThumb'] as String?,
      tags: json['strTags'] as String?,
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }

  @override
  List<Object?> get props => [id, name, category, area, thumbnail];
}

class Ingredient extends Equatable {
  final String name;
  final String measure;

  const Ingredient({
    required this.name,
    required this.measure,
  });

  @override
  List<Object> get props => [name, measure];
}
