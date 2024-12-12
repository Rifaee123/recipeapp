import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageController extends GetxController {
  var meals = [].obs;
  var isLoading = true.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchMeals();
  }

  void fetchMeals() async {
    try {
      final query =
          searchController.text.isNotEmpty ? searchController.text : 'a';
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/search.php?f=$query'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        meals.value = data['meals'] ?? [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch meals');
    } finally {
      isLoading(false);
    }
  }
}
