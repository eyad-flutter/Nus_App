import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/controller/profile_controller.dart';
import 'package:test/view/view_all_screen.dart';
import 'package:test/widgets/nav_bars.dart';

import '../controller/base_controller.dart';
import '../controller/news_controller.dart';
import '../widgets/banner_cards.dart';
import '../widgets/double_back_to_exit_wrapper.dart';
import '../widgets/nav_bar_icons.dart';
import '../widgets/news_cards.dart';

/// Displays main home dashboard featuring user greeting, banner carousel, and primary news feed.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = GetStorage();

  final NewsController newsController = Get.put(NewsController());
  final BaseController baseController = Get.put(BaseController());
  final ProfileController defaultValues = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Get.mediaQuery.size.height * 0.01),

                  // User Profile Greeting Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          baseController.changeIndex(4);
                          Get.toNamed('/profile');
                        },
                        icon: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            box.read('Avatar') ?? 'images/man.png',
                          ),
                        ),
                      ),
                      SizedBox(width: Get.mediaQuery.size.width * 0.03),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "home_Profile_Wel".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color
                                    ?.withValues(alpha: 0.3),
                              ),
                              children: [
                                TextSpan(
                                  text: " ${box.read('username')}!\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color
                                        ?.withValues(alpha: 0.3),
                                  ),
                                ),
                                TextSpan(
                                  text: "home_Profile_Bio".tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.01),

                  // Horizontal Banner News Slider
                  GetBuilder<NewsController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        return SizedBox(
                          height: Get.mediaQuery.size.height * 0.35,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (controller.bannerNews.isEmpty) {
                        return SizedBox(
                          height: Get.mediaQuery.size.height * 0.35,
                          child: Center(child: Text("home_No_News".tr)),
                        );
                      }

                      return SizedBox(
                        height: Get.mediaQuery.size.height * 0.35,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.bannerNews.length,
                          itemBuilder: (context, index) {
                            return NewsBannerCard(
                              article: controller.bannerNews[index],
                            );
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.01),

                  // Section Divider
                  Divider(
                    thickness: Get.mediaQuery.size.width * 0.002,
                    color: Colors.black.withValues(alpha: 0.2),
                    indent: Get.mediaQuery.size.width * 0.12,
                    endIndent: Get.mediaQuery.size.width * 0.12,
                  ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.01),

                  // Section Title Header & Navigation Link
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      children: [
                        Text(
                          "home_News_Sec_Title".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.to(() => const ViewAllScreen()),
                          child: Text(
                            "home_News_Sec_All".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.01),

                  // Vertical News Cards List
                  GetBuilder<NewsController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        return SizedBox(
                          height: Get.mediaQuery.size.height * 0.35,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (controller.news.isEmpty) {
                        return SizedBox(
                          height: Get.mediaQuery.size.height * 0.35,
                          child: Center(child: Text("home_No_News".tr)),
                        );
                      }

                      return SizedBox(
                        height: Get.mediaQuery.size.height * 0.35,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: controller.news.length,
                          itemBuilder: (context, index) {
                            return NewsCard(article: controller.news[index]);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavBars(navGenre: buildNavItem),
      ),
    );
  }
}
