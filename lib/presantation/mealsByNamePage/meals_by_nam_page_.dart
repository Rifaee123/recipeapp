import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/model/meals_by_name_model/meal_by_name_model.dart';


// class MealByName {
//   final String id;
//   final String name;
//   final String category;
//   final String area;
//   final String instructions;
//   final String thumbnail;
//   final String youtube;

//   MealByName({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.area,
//     required this.instructions,
//     required this.thumbnail,
//     required this.youtube,
//   });

//   factory MealByName.fromJson(Map<String, dynamic> json) {
//     return MealByName(
//       id: json['idMeal'],
//       name: json['strMeal'],
//       category: json['strCategory'] ?? 'Unknown',
//       area: json['strArea'] ?? 'Unknown',
//       instructions: json['strInstructions'] ?? 'No instructions provided.',
//       thumbnail: json['strMealThumb'],
//       youtube: json['strYoutube'] ?? '',
//     );
//   }
// }

class MealByNameController extends GetxController {
  var meals = <MealByName>[].obs;
  var isLoading = false.obs;
  final searchController = TextEditingController();

  Future<void> fetchMeals(String query) async {
    try {
      searchController.text.isNotEmpty ? searchController.text : 'Arrabiata';
      isLoading.value = true;
      final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          meals.value = (data['meals'] as List)
              .map((meal) => MealByName.fromJson(meal))
              .toList();
        } else {
          meals.value = [];
          Get.snackbar('No Results', 'No meals found for "$query"');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch meals');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

class MealByNamePage extends StatelessWidget {
  final MealByNameController controller = Get.put(MealByNameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.searchController,
              onSubmitted: (value) {
                controller.fetchMeals(value);
              },
              decoration: InputDecoration(
                labelText: 'Search Meal',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.meals.isEmpty) {
                return Center(child: Text('No meals found.'));
              }
              return ListView.builder(
                itemCount: controller.meals.length,
                itemBuilder: (context, index) {
                  final meal = controller.meals[index];
                  return ListTile(
                    leading:
                        Image.network(meal.thumbnail, width: 50, height: 50),
                    title: Text(meal.name),
                    subtitle: Text(meal.category),
                    onTap: () {
                      Get.to(() => MealByNameDetailsPage(meal: meal));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class MealByNameDetailsPage extends StatelessWidget {
  final MealByName meal;

  MealByNameDetailsPage({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal.thumbnail),
            SizedBox(height: 8),
            Text(
              meal.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Category: ${meal.category}'),
            Text('Cuisine: ${meal.area}'),
            SizedBox(height: 8),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(meal.instructions),
            if (meal.youtube.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                        'Opening YouTube', 'Redirecting to YouTube...');
                  },
                  child: Text('Watch on YouTube'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
