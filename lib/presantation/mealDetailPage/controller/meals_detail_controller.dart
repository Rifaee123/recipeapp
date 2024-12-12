import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/model/mealsDetailsModel/meal_details_model.dart';



class MealDetailController extends GetxController {
  var isLoading = true.obs;
  var mealDetail = Rxn<MealDetail>();

  Future<void> fetchMealDetail(String id) async {
    try {
      final url = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        log(response.body);
        final data = json.decode(response.body);
        mealDetail.value = MealDetail.fromJson(data['meals'][0]);
      } else {
        Get.snackbar('Error', 'Failed to fetch meal details');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}