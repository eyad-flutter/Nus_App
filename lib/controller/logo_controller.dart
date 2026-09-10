import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Controls the splash screen animation sequence and initial app routing.
class SplashController extends GetxController {
  final box = GetStorage();
  double opacity = 0.0;

  @override
  void onInit() {
    super.onInit();
    startSplashAnimation();
  }

  /// Runs the fade-in/fade-out animation and redirects the user based on profile state.
  void startSplashAnimation() async {
    // Initial delay before starting fade-in
    await Future.delayed(const Duration(seconds: 1));

    // Trigger fade-in animation
    opacity = 1.0;
    update();

    // Display splash branding
    await Future.delayed(const Duration(seconds: 3));

    // Trigger fade-out animation
    opacity = 0.0;
    update();

    // Final delay before page transition
    await Future.delayed(const Duration(seconds: 1));

    // Check user profile data for routing
    String? username = box.read('username');
    String? avatar = box.read('Avatar');

    // Route to Home if user profile exists, otherwise send to Onboarding/Splash flow
    if (username != null &&
        username.isNotEmpty &&
        avatar != null &&
        avatar.isNotEmpty) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/splashScreens');
    }
  }
}
