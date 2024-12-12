class Meal {
  final String name;
  final String thumbnail;
  final String id;

  Meal({required this.name, required this.thumbnail, required this.id});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      id: json['idMeal'],
    );
  }
}