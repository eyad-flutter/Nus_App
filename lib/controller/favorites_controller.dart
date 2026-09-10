import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/news_model.dart';

/// Manages favorite news articles and local storage persistence.
class FavoriteController extends GetxController {
  final _box = GetStorage();
  final String _storageKey = 'favorite_articles';

  /// Reactive list of user's saved articles.
  var favoriteList = <Results>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Loads saved articles from GetStorage during controller initialization.
  void loadFavorites() {
    List? storedFavs = _box.read<List>(_storageKey);
    if (storedFavs != null) {
      favoriteList.value = storedFavs
          .map((item) => Results.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }

  /// Toggles an article's saved status (Adds if new, Removes if existing).
  void toggleFavorite(Results article) {
    int index = favoriteList.indexWhere(
      (element) => element.title == article.title,
    );

    if (index >= 0) {
      // Remove article from favorites
      favoriteList.removeAt(index);
      Get.snackbar(
        'favorite_Msg_Remove'.tr,
        'favorite_Msg_Remove_Des'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
        reverseAnimationCurve: Curves.slowMiddle,
      );
    } else {
      // Add article to favorites
      favoriteList.add(article);
      Get.snackbar(
        'favorite_Msg_Saved'.tr,
        'favorite_Msg_Saved_Des'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
        reverseAnimationCurve: Curves.slowMiddle,
      );
    }

    _saveToStorage();
    update();
  }

  /// Checks if a specific article is currently saved in favorites.
  bool isFavorite(Results article) {
    return favoriteList.any((element) => element.title == article.title);
  }

  /// Persists current favorite list to local storage as JSON.
  void _saveToStorage() {
    List<dynamic> jsonList = favoriteList
        .map((article) => article.toJson())
        .toList();
    _box.write(_storageKey, jsonList);
    update();
  }
}
