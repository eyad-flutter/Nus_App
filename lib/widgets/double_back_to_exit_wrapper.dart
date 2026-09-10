import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test/controller/base_controller.dart';

/// Wraps a widget to handle the double-tap-to-exit pattern with a confirmation snackbar.
class DoubleBackToExitWrapper extends StatefulWidget {
  final Widget child;

  const DoubleBackToExitWrapper({super.key, required this.child});

  @override
  State<DoubleBackToExitWrapper> createState() =>
      _DoubleBackToExitWrapperState();
}

class _DoubleBackToExitWrapperState extends State<DoubleBackToExitWrapper> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents immediate pop navigation action
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);

        // Show confirmation message if first back press or elapsed duration exceeds threshold
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > maxDuration) {
          _lastPressedAt = now;

          Get.snackbar(
            '',
            '',
            titleText: const SizedBox.shrink(),
            messageText: Text(
              'double_Click_Exit'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black26.withValues(alpha: 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            borderRadius: 25,
            duration: const Duration(seconds: 2),
            reverseAnimationCurve: Curves.slowMiddle,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
          );
        } else {
          // Trigger system application exit on consecutive double back press
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}

/// Wraps secondary screen views to intercept back gestures and redirect back to the Home tab.
class ReturnHome extends StatefulWidget {
  final Widget child;

  const ReturnHome({super.key, required this.child});

  @override
  State<ReturnHome> createState() => _ReturnHomeState();
}

class _ReturnHomeState extends State<ReturnHome> {
  @override
  Widget build(BuildContext context) {
    final BaseController controller = Get.put(BaseController());

    return PopScope(
      canPop: false, // Prevents default pop action to enforce home redirection
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Reset bottom navigation index to home tab and navigate to home screen
        controller.changeIndex(2);
        Get.offNamed('/home');
      },
      child: widget.child,
    );
  }
}
