import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/view/login.dart';

import 'onboarding_model.dart';

/// Controls onboarding screen navigation, page transitions, and slide data.
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  int currentIndex = 0;

  /// List of onboarding pages containing imagery and localized copy.
  final List<OnboardingModel> pages = [
    OnboardingModel(
      image: "images/splashScreenOne.jpg",
      title: "splash_Title_One".tr,
      description: "splash_Des_One".tr,
    ),
    OnboardingModel(
      image: "images/splashScreenTwo.jpg",
      title: "splash_Title_Two".tr,
      description: "splash_Des_Two".tr,
    ),
    OnboardingModel(
      image: "images/splashScreenThree.jpg",
      title: "splash_Title_Three".tr,
      description: "splash_Des_Three".tr,
    ),
  ];

  /// Navigates to the next onboarding slide or proceeds to the authentication/login screen.
  void nextPage() {
    if (currentIndex < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Login screen after the final slide
      Get.offAll(
        () => Login(),
        transition: Transition.leftToRightWithFade,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  /// Skips onboarding flow and navigates directly to the Login screen.
  void skip() {
    Get.offAll(
      () => Login(),
      transition: Transition.leftToRightWithFade,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Updates current active page index and refreshes UI indicators.
  void onPageChanged(int index) {
    currentIndex = index;
    update();
  }
}
