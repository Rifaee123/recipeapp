import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/presantation/mealDetailPage/meal_detail_page.dart';
import 'package:recipe_app/presantation/mealPage/controller/meals_controller%20.dart';

class MealsPage extends StatelessWidget {
  final MealsController controller = Get.put(MealsController());

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
                controller.fetchMeals();
              },
              decoration: InputDecoration(
                labelText: 'Search Ingredient',
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
                    subtitle: Text('Meal ID: ${meal.id}'),
                    onTap: () {
                      Get.to(() => MealDetailPage(), arguments: meal.id);
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
  