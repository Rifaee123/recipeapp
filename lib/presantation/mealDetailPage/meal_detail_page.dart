import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/presantation/mealDetailPage/controller/meals_detail_controller.dart';

class MealDetailPage extends StatelessWidget {
  final MealDetailController controller = Get.put(MealDetailController());

  @override
  Widget build(BuildContext context) {
    final mealId = Get.arguments as String;
    controller.fetchMealDetail(mealId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.mealDetail.value == null) {
          return Center(child: Text('Meal details not found.'));
        }

        final meal = controller.mealDetail.value!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(meal.thumbnail),
                SizedBox(height: 16),
                Text(meal.name,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Category: ${meal.category}'),
                Text('Area: ${meal.area}'),
                SizedBox(height: 16),
                Text('Ingredients:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...meal.ingredients.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ingredient = entry.value;
                  final measure = meal.measures[index];
                  return Text('$ingredient - $measure');
                }),
                SizedBox(height: 16),
                Text('Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(meal.instructions),
              ],
            ),
          ),
        );
      }),
    );
  }
}