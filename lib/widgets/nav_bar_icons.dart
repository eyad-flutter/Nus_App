import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/controller/profile_controller.dart';
import 'package:test/helper/consts.dart';

import '../controller/base_controller.dart';

/// Renders standard navigation bar item with smooth scale animations and active indicator styling.
Widget buildNavItem({
  required BaseController controller,
  required int index,
  required IconData icon,
  required IconData activeIcon,
  required String route,
  ProfileController? profile,
}) {
  final isSelected = controller.navCurrentIndex == index;

  return IconButton(
    onPressed: () {
      if (isSelected) return;
      controller.changeIndex(index);
      Get.offNamed(route);
    },
    icon: AnimatedScale(
      scale: isSelected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Container(
        width: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(18),
            right: Radius.circular(18),
          ),
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected
              ? const Color(0xFF0F52BA)
              : Get.theme.iconTheme.color,
          size: 24,
        ),
      ),
    ),
  );
}

/// Renders profile-aware navigation item that prompts unsaved changes dialog before tab navigation.
Widget buildNavItemProfile({
  required BaseController controller,
  required ProfileController profile,
  required int index,
  required IconData icon,
  required IconData activeIcon,
  required String route,
}) {
  final box = GetStorage();
  final isSelected = controller.navCurrentIndex == index;

  return IconButton(
    onPressed: () {
      // Check for unsaved profile modifications before executing navigation
      if (box.read('username') !=
              profile.editedNameController.text.trim().capitalizeFirst ||
          box.read('Avatar') !=
              avatarList[profile.selectedAvatarIndex]['icon']) {
        profile.showUnsavedChangesDialog(
          onDiscard: () {
            controller.changeIndex(index);
            Get.offNamed(route);
          },
        );
        return;
      }
      if (isSelected) return;
      controller.changeIndex(index);
      Get.offNamed(route);
    },
    icon: AnimatedScale(
      scale: isSelected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Container(
        width: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(18),
            right: Radius.circular(18),
          ),
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected
              ? const Color(0xFF0F52BA)
              : Get.theme.iconTheme.color,
          size: 24,
        ),
      ),
    ),
  );
}
