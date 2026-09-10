import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/base_controller.dart';
import '../controller/profile_controller.dart';

/// Navigation bar widget providing persistent tab switching and custom item rendering.
class NavBars extends StatelessWidget {
  const NavBars({super.key, required this.navGenre});

  /// Flexible builder function to render navigation items based on active screen context.
  final Function navGenre;

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return GetBuilder<BaseController>(
      builder: (baseController) {
        return Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).cardTheme.shadowColor ?? Colors.black)
                    .withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(1.0, -10.0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(
                baseController,
                0,
                Icons.favorite_outline,
                Icons.favorite,
                '/favorites',
                profileController,
              ),
              _buildItem(
                baseController,
                1,
                Icons.category_outlined,
                Icons.category,
                '/categories',
                profileController,
              ),
              _buildItem(
                baseController,
                2,
                Icons.home_outlined,
                Icons.home,
                '/home',
                profileController,
              ),
              _buildItem(
                baseController,
                3,
                Icons.settings_outlined,
                Icons.settings,
                '/settings',
                profileController,
              ),
              _buildItem(
                baseController,
                4,
                Icons.person_outline,
                Icons.person,
                '/profile',
                profileController,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper method invoking [navGenre] with required routing and controller arguments.
  Widget _buildItem(
    BaseController controller,
    int index,
    IconData icon,
    IconData activeIcon,
    String route,
    ProfileController profile,
  ) {
    return navGenre(
      controller: controller,
      index: index,
      icon: icon,
      activeIcon: activeIcon,
      route: route,
      profile: profile,
    );
  }
}
