import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/model/meals_model/meal.dart';

class MealsController extends GetxController {
  var meals = <Meal>[].obs;
  var isLoading = true.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      final query =
          searchController.text.isNotEmpty ? searchController.text : 'beef';
      final url = 'https://www.themealdb.com/api/json/v1/1/filter.php?i=$query';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        meals.value =
            (data['meals'] as List).map((meal) => Meal.fromJson(meal)).toList();
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
