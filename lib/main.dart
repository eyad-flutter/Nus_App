import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/controller/favorites_controller.dart';
import 'package:test/controller/view_all_controller.dart';
import 'package:test/routes/routes.dart';
import 'package:test/theme/app_theme.dart';

import 'controller/base_controller.dart';
import 'controller/news_controller.dart';
import 'controller/theme_controller.dart';
import 'helper/lang.dart';
import 'routes/app_pages.dart';

/// Entry point of the application. Initializes dependencies, storage, and configures GetX settings.
void main() async {
  // To keep the app in vertical mode only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize GetStorage local persistence
  await GetStorage.init();
  final box = GetStorage();

  // Read stored user preferences for theme and language with fallback defaults
  final isDark = box.read('isDarkMode') ?? false;
  String lang = box.read('isEnglish') ?? 'en';

  // Inject primary global controllers into memory
  Get.put(ThemeController());
  Get.put(FavoriteController());
  Get.put(BaseController());
  Get.put(NewsController());
  Get.put(ViewAllController());
  Get.put(LangController());

  runApp(
    GetMaterialApp(
      translations: Lang(),
      locale: Locale(lang),
      // To Open On This Value On Init
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      builder: (context, child) {
        return Directionality(
          textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },

      initialRoute: Routes.logo,
      getPages: AppPages.routes,
    ),
  );
}
