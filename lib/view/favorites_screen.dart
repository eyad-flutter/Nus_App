import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/view/news_details_screen.dart';

import '../controller/favorites_controller.dart';
import '../widgets/double_back_to_exit_wrapper.dart';
import '../widgets/favorites_widgets.dart';
import '../widgets/nav_bar_icons.dart';
import '../widgets/nav_bars.dart';

/// Displays saved favorite news articles in a grid view with empty state fallback.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favController = Get.put(FavoriteController());

    return ReturnHome(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'favorite_Banner'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading:
              false, // Disables default leading back button
        ),
        body: Obx(() {
          // Display empty state layout when no articles are saved
          if (favController.favoriteList.isEmpty) {
            return buildEmptyState();
          }

          // Build grid layout for saved favorite articles
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favController.favoriteList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final article = favController.favoriteList[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => NewsDetailsScreen(article: article));
                },
                child: buildFavoriteCard(context, article, favController),
              );
            },
          );
        }),
        bottomNavigationBar: NavBars(navGenre: buildNavItem),
      ),
    );
  }
}
