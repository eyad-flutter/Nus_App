import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/view_all_controller.dart';
import '../widgets/news_cards.dart';

/// Screen for displaying filtered news list with search capabilities, category tabs, and infinite scroll pagination.
class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final ViewAllController viewAllController = Get.find<ViewAllController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to scroll position to trigger infinite pagination when reaching bottom threshold
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        viewAllController.newsController.fetchMoreNews();
      }
    });
    viewAllController.searchQuery.value = '';
    viewAllController.selectedCountry.value = 'all';
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Discover header title and subtitle
            Text(
              'view_All_HeadLine'.tr,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'view_All_HeadLine_Des'.tr,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),

            // 2. Interactive text search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                onChanged: (value) =>
                    viewAllController.updateSearchQuery(value),
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: 'view_All_Search_Hint'.tr,
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  icon: Icon(Icons.search_rounded, color: Colors.grey[400]),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      viewAllController.showFilterDialog(context);
                    },
                    icon: Icon(Icons.tune_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Horizontal category filter chips
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewAllController.categories.length,
                itemBuilder: (context, index) {
                  final category = viewAllController.categories[index];
                  return Obx(() {
                    final isSelected =
                        viewAllController.selectedCategory.value == category;
                    return GestureDetector(
                      onTap: () => viewAllController.changeCategory(category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(
                                  0xFF0F52BA,
                                ) // Royal Blue active accent
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category.tr,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // 4. Filtered news list with pull-to-refresh and infinite scroll
            Expanded(
              child: GetBuilder<ViewAllController>(
                builder: (controller) {
                  if (viewAllController.newsController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredList = viewAllController.filteredNews;

                  // Empty list layout wrapped in pull-to-refresh
                  if (filteredList.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await viewAllController.newsController
                            .refreshCategoryNews(
                              targetCategory:
                                  viewAllController.selectedCategory.value,
                            );
                        viewAllController.update();
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 60,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'view_All_Msg_Date'.tr,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // News list layout supporting infinite pagination and pull-to-refresh
                  return RefreshIndicator(
                    onRefresh: () async {
                      await viewAllController.newsController
                          .refreshCategoryNews(
                            targetCategory:
                                viewAllController.selectedCategory.value,
                          );
                      viewAllController.update();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: filteredList.length + 1,
                      itemBuilder: (context, index) {
                        // Render pagination loader at bottom of list when loading additional items
                        if (index == filteredList.length) {
                          return Obx(() {
                            return viewAllController
                                    .newsController
                                    .isLoadingMore
                                    .value
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          });
                        }

                        return NewsCard(article: filteredList[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
