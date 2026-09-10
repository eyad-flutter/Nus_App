import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/news_model.dart';
import 'news_controller.dart';

/// Manages category, country, and text search filters for the View All screen.
class ViewAllController extends GetxController {
  final NewsController newsController = Get.find<NewsController>();

  // --- Observables & Active State ---
  var selectedCategory = 'all'.obs;
  var selectedCountry = 'all'.obs;
  var searchQuery = ''.obs;

  // --- Filter Options Data ---
  final List<String> categories = const [
    'categories',
    'categories_Sports',
    'categories_Politics',
    'categories_Entertainment',
    'categories_Tech',
    'categories_Business',
    'categories_Science',
  ];

  final List<Map<String, String>> countries = const [
    {'key': 'all', 'label': 'view_All_country_All'},
    {'key': 'arabic', 'label': 'view_All_country_Arabic'},
    {'key': 'india', 'label': 'view_All_country_India'},
    {'key': 'us', 'label': 'view_All_country_US'},
  ];

  final List<String> arabicKeywords = const [
    'egypt',
    'saudi',
    'ksa',
    'uae',
    'emirates',
    'dubai',
    'oman',
    'qatar',
    'kuwait',
    'bahrain',
    'jordan',
    'palestine',
    'gaza',
    'lebanon',
    'syria',
    'iraq',
    'yemen',
    'sudan',
    'libya',
    'tunisia',
    'algeria',
    'morocco',
    'mauritania',
    'somalia',
    'djibouti',
    'comoros',
    'arab',
    'middle east',
  ];

  bool get isLoading => newsController.isLoading;

  List<Results> get filteredNews {
    final List<Results> allNews = newsController.news;
    if (allNews.isEmpty) return [];

    return allNews.where((article) {
      return _matchesCategory(article) &&
          _matchesCountry(article) &&
          _matchesSearch(article);
    }).toList();
  }

  bool _matchesCategory(Results article) {
    if (selectedCategory.value == 'all' ||
        selectedCategory.value == 'categories') {
      return true;
    }
    if (article.category == null || article.category!.isEmpty) return false;

    final targetCat = selectedCategory.value
        .replaceAll('categories_', '')
        .toLowerCase()
        .trim();
    final cleanTarget = targetCat == 'tech' ? 'technology' : targetCat;

    return article.category!.any((c) {
      final apiCat = c.toLowerCase().trim();
      return apiCat == cleanTarget ||
          apiCat.contains(cleanTarget) ||
          cleanTarget.contains(apiCat);
    });
  }

  bool _matchesCountry(Results article) {
    final countryFilter = selectedCountry.value;
    if (countryFilter == 'all') return true;

    final searchBody =
        "${article.title ?? ''} ${article.description ?? ''} ${article.content ?? ''}"
            .toLowerCase();

    switch (countryFilter) {
      case 'arabic':
        return RegExp(r'[\u0600-\u06FF]').hasMatch(searchBody) ||
            article.language == 'arabic' ||
            article.language == 'ar' ||
            arabicKeywords.any((k) => searchBody.contains(k)) ||
            (article.country != null &&
                article.country!.any(
                  (c) => c.toLowerCase().contains('arabic'),
                ));
      case 'india':
        return RegExp(r'[\u0900-\u097F]').hasMatch(searchBody) ||
            searchBody.contains('india') ||
            searchBody.contains('indian') ||
            searchBody.contains('delhi') ||
            searchBody.contains('mumbai') ||
            (article.country != null &&
                article.country!.any((c) => c.toLowerCase().contains('india')));
      case 'us':
        return (article.country != null &&
                article.country!.any(
                  (c) => c.toLowerCase().contains('united states'),
                )) ||
            searchBody.contains('usa') ||
            searchBody.contains('us news') ||
            searchBody.contains('washington') ||
            searchBody.contains('america') ||
            searchBody.contains('biden') ||
            searchBody.contains('trump');
      default:
        return true;
    }
  }

  void showFilterDialog(BuildContext context) {
    // استخدام النسخة المحقونة بالفعل بدلاً من إنشاء instance جديدة
    final ViewAllController viewAllController = Get.find<ViewAllController>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Get.theme.cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        content: SizedBox(
          width:
              MediaQuery.of(context).size.width *
              0.8, // تحديد عرض محدد للـ Dialog
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewAllController.countries.length,
            itemBuilder: (context, index) {
              final country = viewAllController.countries[index];
              return Obx(() {
                final isSelected =
                    viewAllController.selectedCountry.value == country['key'];
                return GestureDetector(
                  onTap: () => viewAllController.changeCountry(country['key']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0F52BA) // Royal Blue
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        country['label']!.tr,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  bool _matchesSearch(Results article) {
    if (searchQuery.value.isEmpty) return true;
    return article.title != null &&
        article.title!.toLowerCase().contains(
          searchQuery.value.trim().toLowerCase(),
        );
  }

  void changeCategory(String categoryKey) async {
    selectedCategory.value = categoryKey;
    update();

    if (filteredNews.length < 5 && newsController.nextPage != null) {
      await newsController.fetchNewsUntilTargetCount(
        targetCategory: categoryKey,
        targetCount: 10,
      );
    }
  }

  void changeCountry(String countryKey) {
    selectedCountry.value = countryKey;
    update();
  }

  void updateSearchQuery(String query) async {
    searchQuery.value = query;
    update();

    if (query.trim().isNotEmpty &&
        filteredNews.length < 4 &&
        newsController.nextPage != null) {
      await newsController.fetchNewsUntilSearchMatch(query: query.trim());
    }
  }
}
