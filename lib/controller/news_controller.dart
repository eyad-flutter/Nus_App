import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/controller/news_service.dart';
import 'package:test/controller/view_all_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/news_model.dart';

/// Manages news data fetching, pagination, local caching, and article navigation.
class NewsController extends GetxController {
  final box = GetStorage();
  final NewsService _newsService = NewsService();

  bool isLoading = false;
  List<Results> news = [];
  List<Results> bannerNews = [];
  var isLoadingMore = false.obs;

  /// Holds the pagination key for the next page from the API.
  String? nextPage;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  /// Fetches initial news articles using an offline-first strategy.
  Future<void> fetchNews() async {
    _loadCachedNews();

    if (news.isEmpty) {
      isLoading = true;
      update();
    }

    try {
      final result = await _newsService.getNews();

      if (result != null &&
          result.results != null &&
          result.results!.isNotEmpty) {
        news = result.results!;
        nextPage = result.nextPage;

        _updateCacheWithCurrentNews();

        List<Results> tempList = List.from(news);
        tempList.shuffle();
        bannerNews = tempList.take(8).toList();
      }
    } catch (e) {
      debugPrint("Error in Controller: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Retrieves cached news articles and pagination state from local storage.
  void _loadCachedNews() {
    final cachedData = box.read('cached_news');
    if (cachedData != null) {
      var data = Articles.fromJson(cachedData);
      if (data.results != null && data.results!.isNotEmpty) {
        news = data.results!;
        nextPage = data.nextPage;

        List<Results> tempList = List.from(news);
        tempList.shuffle();
        bannerNews = tempList.take(8).toList();
      }
    }
  }

  /// Refreshes and guarantees fetching target number of articles for a specific category.
  /// Solves the issue where pull-to-refresh on a specific category returns empty/few articles.
  Future<void> refreshCategoryNews({
    String targetCategory = 'all',
    int minTargetCount = 6,
  }) async {
    try {
      isLoading = true;
      update();

      final result = await _newsService.getNews();

      if (result != null && result.results != null) {
        news = result.results!;
        nextPage = result.nextPage;
        _updateCacheWithCurrentNews();
      }

      // If category requires more items to be usable, keep fetching until target is met
      if (targetCategory.toLowerCase() != 'all' && nextPage != null) {
        await fetchNewsUntilTargetCount(
          targetCategory: targetCategory,
          targetCount: minTargetCount,
          isRefreshing: true,
        );
      }
    } catch (e) {
      debugPrint("Error refreshing category news: $e");
    } finally {
      isLoading = false;
      update();
      if (Get.isRegistered<ViewAllController>()) {
        Get.find<ViewAllController>().update();
      }
    }
  }

  /// Fetches the next page of news articles for infinite scroll.
  Future<void> fetchMoreNews() async {
    if (isLoadingMore.value || nextPage == null) return;

    try {
      isLoadingMore.value = true;

      final result = await _newsService.getNews(page: nextPage);

      if (result != null &&
          result.results != null &&
          result.results!.isNotEmpty) {
        news.addAll(result.results!);
        nextPage = result.nextPage;

        _updateCacheWithCurrentNews();
        update();

        if (Get.isRegistered<ViewAllController>()) {
          Get.find<ViewAllController>().update();
        }
      }
    } catch (e) {
      debugPrint("Error fetching more news: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Iteratively fetches API pages until a target count of articles matching [targetCategory] is accumulated.
  Future<void> fetchNewsUntilTargetCount({
    required String targetCategory,
    int targetCount = 5,
    bool isRefreshing = false,
  }) async {
    if ((isLoadingMore.value && !isRefreshing) || nextPage == null) return;

    try {
      isLoadingMore.value = true;
      update();

      int currentLoop = 0;
      const int maxSafetyLoops = 10; // Safety threshold against API rate-limit

      while (nextPage != null && currentLoop < maxSafetyLoops) {
        // Count existing matches in global memory
        int currentMatches = _countCategoryMatches(targetCategory);
        if (currentMatches >= targetCount) break;

        currentLoop++;



        if (currentLoop > 1) {
          await Future.delayed(const Duration(milliseconds: 300));
        }

        final result = await _newsService.getNews(page: nextPage);

        if (result == null || result.results == null || result.results!.isEmpty) break;

        if (result.results != null && result.results!.isNotEmpty) {
          news.addAll(result.results!);
          nextPage = result.nextPage;

          _updateCacheWithCurrentNews();
          update();

          if (Get.isRegistered<ViewAllController>()) {
            Get.find<ViewAllController>().update();
          }
          await Future.delayed(const Duration(milliseconds: 300));
        } else {
          break;
        }
      }
    } catch (e) {
      debugPrint("Error fetching targeted news: $e");
    } finally {
      isLoadingMore.value = false;
      update();
      if (Get.isRegistered<ViewAllController>()) {
        Get.find<ViewAllController>().update();
      }
    }
  }

  /// Helper method to count existing matched articles for a category in memory.
  int _countCategoryMatches(String categoryKey) {
    if (categoryKey.toLowerCase() == 'all' || categoryKey.toLowerCase() == 'categories') {
      return news.length;
    }

    final cleanTarget = categoryKey
        .replaceAll('categories_', '')
        .toLowerCase()
        .trim();
    final target = cleanTarget == 'tech' ? 'technology' : cleanTarget;

    return news.where((article) {
      if (article.category == null) return false;
      return article.category!.any((c) {
        String apiCat = c.toLowerCase().trim();
        return apiCat == target || apiCat.contains(target) || target.contains(apiCat);
      });
    }).length;
  }

  void _updateCacheWithCurrentNews() {
    Articles currentArticles = Articles(
      status: "success",
      results: news,
      nextPage: nextPage,
    );
    box.write('cached_news', currentArticles.toJson());
  }

  Future<void> openArticleUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;

    try {
      final Uri url = Uri.parse(urlString);
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching url: $e');
    }
  }

  void deleteCaches() async {
    bool clearedAnyFile = false;

    if (box.read('cached_news') != null) {
      await box.remove('cached_news');
      clearedAnyFile = true;
    }

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    try {
      final Directory tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        final List<FileSystemEntity> files = tempDir.listSync();

        if (files.isNotEmpty) {
          for (var file in files) {
            try {
              file.deleteSync(recursive: true);
              clearedAnyFile = true;
            } catch (e) {
              debugPrint("Could not delete file: $e");
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error clearing cache folder: $e");
    }

    if (clearedAnyFile) {
      Get.snackbar(
        'settings_Cache_Snack'.tr,
        'settings_Cache_Snack_Des'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
        reverseAnimationCurve: Curves.slowMiddle,
        dismissDirection: DismissDirection.horizontal,
      );
    } else {
      Get.snackbar(
        'settings_Cache_Snack_Nothing'.tr,
        'settings_Cache_Snack_Nothing_Des'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xffCAE000),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
        reverseAnimationCurve: Curves.slowMiddle,
        dismissDirection: DismissDirection.horizontal,
      );
    }
    update();
  }

  /// Search helper method: fetches extra API pages until matching articles for [query] are found.
  Future<void> fetchNewsUntilSearchMatch({required String query, int targetCount = 4}) async {
    if (isLoadingMore.value || nextPage == null) return;

    try {
      isLoadingMore.value = true;
      update();

      int currentLoop = 0;
      const int maxSafetyLoops = 2;

      while (nextPage != null && currentLoop < maxSafetyLoops) {
        // فحص عدد الأخبار المطابقة للبحث في القائمة الحالية
        int matches = news.where((article) =>
        article.title != null && article.title!.toLowerCase().contains(query.toLowerCase())
        ).length;

        if (matches >= targetCount) break;

        currentLoop++;

        final result = await _newsService.getNews(page: nextPage);
        if (result == null || result.results == null || result.results!.isEmpty) break;

        news.addAll(result.results!);
        nextPage = result.nextPage;

        _updateCacheWithCurrentNews();
        update();

        if (Get.isRegistered<ViewAllController>()) {
          Get.find<ViewAllController>().update();
        }

        await Future.delayed(const Duration(milliseconds: 400));
      }
    } catch (e) {
      debugPrint("Error fetching search news: $e");
    } finally {
      isLoadingMore.value = false;
      update();
      if (Get.isRegistered<ViewAllController>()) {
        Get.find<ViewAllController>().update();
      }
    }
  }

}