import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/controller/logo_controller.dart';

import '../onboarding/onboarding_controller.dart';
import '../widgets/double_back_to_exit_wrapper.dart';

/// Animated branding splash screen displayed upon application launch.
class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: Center(
          child: GetBuilder<SplashController>(
            init: SplashController(),
            builder: (controller) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                opacity: controller.opacity,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.newspaper, size: 90),
                    SizedBox(height: 20),
                    Text("Nus App", style: TextStyle(fontSize: 40)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Onboarding carousel screen displaying introduction slides and action controls.
class SplashScreens extends StatelessWidget {
  const SplashScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: GetBuilder<OnboardingController>(
          init: OnboardingController(),
          builder: (controller) {
            return Stack(
              children: [
                // 1. PageView displaying slide imagery, gradient overlays, and copy
                PageView.builder(
                  physics: const ClampingScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.pages.length,
                  itemBuilder: (context, index) {
                    final item = controller.pages[index];
                    return Stack(
                      children: [
                        // Featured slide image with smooth bottom gradient mask
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: Get.height * 0.53,
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.65, 1.0],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.asset(item.image, fit: BoxFit.cover),
                          ),
                        ),

                        // Title and description copy at bottom of slide
                        SafeArea(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.color,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.mediaQuery.size.height * 0.03,
                                ),
                                Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.mediaQuery.size.height * 0.24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // 2. Skip action button
                Positioned(
                  bottom: 25,
                  left: Get.mediaQuery.size.width * 0.42,
                  child: TextButton(
                    onPressed: controller.skip,
                    child: Text(
                      "splash_Skip".tr,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // 3. Page indicators displaying current step position
                Positioned(
                  bottom: Get.mediaQuery.size.height * 0.19,
                  left: Get.mediaQuery.size.width * 0.4,
                  right: Get.mediaQuery.size.width * 0.4,
                  child: Row(
                    children: List.generate(
                      controller.pages.length,
                      (index) => Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          height: 4,
                          decoration: BoxDecoration(
                            color: controller.currentIndex == index
                                ? Theme.of(context).textTheme.titleLarge?.color
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. Fixed action button (Continue / Get Started)
                Positioned(
                  bottom: 80,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        controller.currentIndex == controller.pages.length - 1
                            ? "splash_Get_Started".tr
                            : "splash_Continue".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
