import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../theme/app_theme.dart';
import 'base_controller.dart';

/// Manages application theme switching (Dark/Light mode) and storage persistence.
class ThemeController extends GetxController {
  final box = GetStorage();

  /// Holds the current theme state.
  late bool isDarkMode;

  @override
  void onInit() {
    super.onInit();
    // Read persisted theme preference from local storage on controller initialization
    isDarkMode = box.read('isDarkMode') ?? false;
  }

  /// Toggles between light and dark themes, persists choice, and updates UI state.
  void changeTheme() {
    isDarkMode = !isDarkMode;

    // Apply active theme mode to GetX interface
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    Get.changeTheme(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);

    // Save selected theme preference locally
    box.write("isDarkMode", isDarkMode);

    // Refresh theme UI across active widgets and components
    update();
    if (Get.isRegistered<BaseController>()) {
      Get.find<BaseController>()
          .update(); // Triggers bottom navigation bar theme sync
    }
  }
}
