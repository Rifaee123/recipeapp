class MealByName {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;

  MealByName({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
  });

  factory MealByName.fromJson(Map<String, dynamic> json) {
    return MealByName(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'] ?? 'Unknown',
      area: json['strArea'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? 'No instructions provided.',
      thumbnail: json['strMealThumb'],
      youtube: json['strYoutube'] ?? '',
    );
  }
}