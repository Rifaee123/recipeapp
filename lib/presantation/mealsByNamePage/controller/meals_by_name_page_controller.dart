import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/model/meals_by_name_model/meal_by_name_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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