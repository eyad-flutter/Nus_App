import 'package:get/get.dart';
import 'package:test/routes/routes.dart';
import 'package:test/view/profile_screen.dart';
import 'package:test/view/settings.dart';
import 'package:test/view/splash_screens.dart';

import '../view/categories_screen.dart';
import '../view/favorites_screen.dart';
import '../view/home_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.home, page: () => HomeScreen(),),
    GetPage(name: Routes.logo, page: () => Logo(),),
    GetPage(name: Routes.splashScreens, page: () => SplashScreens(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 100)),
    GetPage(name: Routes.settings, page: () => SettingsScreen(),),
    GetPage(name: Routes.favorites, page: () => FavoritesScreen(),),
    GetPage(name: Routes.profile, page: () => ProfileScreen(),),
    GetPage(name: Routes.categories, page: () => CategoriesScreen(),)
  ];
}