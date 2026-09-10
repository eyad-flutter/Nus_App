import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/view_all_controller.dart';
import '../view/view_all_screen.dart';
import '../widgets/double_back_to_exit_wrapper.dart';
import '../widgets/nav_bar_icons.dart';
import '../widgets/nav_bars.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  // توزيعة احترافية بنظام الأبعاد النسبية الموزعة هرمياً
  final List<Map<String, dynamic>> categoryItems = [
    {
      'key': 'categories_Tech',
      'photo': 'images/categories/technology.jpg',
      'size': 0.32,
      'top': 0.02,
      'left': -0.06, // مقصوصة من الشمال فوق
    },
    {
      'key': 'categories_Sports',
      'photo': 'images/categories/sports.jpg',
      'size': 0.36,
      'top': 0.08,
      'left': 0.58, // مقصوصة خفيف من اليمين فوق
    },
    {
      'key': 'categories_Politics',
      'photo': 'images/categories/politics.jpg',
      'size': 0.38,
      'top': 0.26,
      'left': 0.16, // في المنتصف المائل يساراً
    },
    {
      'key': 'categories_Entertainment',
      'photo': 'images/categories/entertainment.jpg',
      'size': 0.30,
      'top': 0.42,
      'left': 0.68, // مقصوصة من اليمين وسط
    },
    {
      'key': 'categories_Business',
      'photo': 'images/categories/business.jpg',
      'size': 0.35,
      'top': 0.56,
      'left': -0.05, // مقصوصة من الشمال أسفل
    },
    {
      'key': 'categories_Science',
      'photo': 'images/categories/science.jpg',
      'size': 0.40,
      'top': 0.68,
      'left': 0.38, // مركزية في الأسفل
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ViewAllController viewAllController = Get.put(ViewAllController());

    return ReturnHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          toolbarHeight: 55,
          elevation: 0,
          title: Text(
            "categories_Title".tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // منطقة رسم الكانفاس بـ LayoutBuilder لضمان عدم التداخل مع النصوص
              Expanded(
                child: ClipRect(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double canvasWidth = constraints.maxWidth;
                      final double canvasHeight = constraints.maxHeight;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        children: categoryItems.map((item) {
                          // قراءة أمنة تحمي من الـ Null Safety الإيرور
                          final double sizeFactor =
                              (item['size'] as num?)?.toDouble() ?? 0.3;
                          final double topFactor =
                              (item['top'] as num?)?.toDouble() ?? 0.1;
                          final double leftFactor =
                              (item['left'] as num?)?.toDouble() ?? 0.1;

                          final double bubbleSize = canvasWidth * sizeFactor;

                          return Positioned(
                            top: canvasHeight * topFactor,
                            left: canvasWidth * leftFactor,
                            child: _buildCategoryBubble(
                              context,
                              categoryKey: item['key'] ?? '',
                              photo: item['photo'] ?? '',
                              bubbleSize: bubbleSize,
                              onTap: () {
                                viewAllController.changeCategory(item['key']);
                                Get.to(() => const ViewAllScreen());
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBars(navGenre: buildNavItem),
      ),
    );
  }

  Widget _buildCategoryBubble(
    BuildContext context, {
    required String categoryKey,
    required String photo,
    required double bubbleSize,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: bubbleSize,
        height: bubbleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(
              0xFF0F52BA,
            ).withValues(alpha: isDark ? 0.8 : 0.8),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF0F52BA,
              ).withValues(alpha: isDark ? 0.35 : 0.25),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(photo),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.45),
                    BlendMode.darken,
                  )
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              categoryKey.tr,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: bubbleSize * 0.12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: isDark ? Colors.black87 : Colors.black54,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
