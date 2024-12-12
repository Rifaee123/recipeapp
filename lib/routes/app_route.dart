import 'package:get/get.dart';
import 'package:recipe_app/presantation/homePage/binding/home_page_binding.dart';
import 'package:recipe_app/presantation/homePage/home_page.dart';

class AppRoutes {
  static const String landingpageScreen = '/landingpage_screen';

  static const String initialRoute = '/initialRoute';
  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () =>  HomePage(),
      bindings: [
        HomePageBinding(),
      ],
    )
  ];
}
