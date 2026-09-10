import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/helper/consts.dart';

/// Manages user profile updating, input validation, dialogs, and persistence.
class ProfileController extends GetxController {
  final box = GetStorage();

  late TextEditingController editedNameController;

  late int selectedAvatarIndex = avatarList.indexWhere(
    (item) => item['icon'] == box.read('Avatar'),
  );

  /// Dynamically computes whether input name or selected avatar changed from storage.
  bool get profileDidChange {
    String? currentSavedName = box.read('username');
    String? currentSavedAvatar = box.read('Avatar');

    String inputName = editedNameController.text.trim().capitalizeFirst ?? '';
    String selectedAvatar = avatarList[selectedAvatarIndex]['icon'];

    return inputName != currentSavedName ||
        selectedAvatar != currentSavedAvatar;
  }

  @override
  void onInit() {
    super.onInit();
    String oldName = box.read('username') ?? '';
    editedNameController = TextEditingController(text: oldName);
  }

  /// Displays success notification when profile updates successfully.
  void snackBar() {
    Get.snackbar(
      'update_Profile_Msg_Done'.tr,
      'update_Profile_Msg_Done_Des'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      reverseAnimationCurve: Curves.slowMiddle,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Displays notification when user attempts saving without modifications.
  void oldInfoSnackBar() {
    Get.snackbar(
      'update_Profile_Msg_Nothing'.tr,
      'update_Profile_Msg_Nothing_Des'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xffCAE000),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      reverseAnimationCurve: Curves.slowMiddle,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Displays confirmation dialog when user attempts navigating away with unsaved changes.
  void showUnsavedChangesDialog({required VoidCallback onDiscard}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning icon header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),

              // Title text
              Text(
                'update_Profile_Msg_Unsaved'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Description body
              Text(
                'update_Profile_Msg_Unsaved_Des'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons (Discard / Keep Editing)
              Row(
                children: [
                  // Discard changes button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        onDiscard();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'update_Profile_Msg_Discard'.tr,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Continue editing button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F52BA),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'update_Profile_Msg_Keep_Editing'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Validation snackbar for empty name input.
  void validatorOne() {
    Get.snackbar(
      'update_Profile_Validator_Error'.tr,
      "update_Profile_Validator_One".tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      reverseAnimationCurve: Curves.fastOutSlowIn,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Validation snackbar for name length exceeding threshold.
  void validatorTwo() {
    Get.snackbar(
      'update_Profile_Validator_Error'.tr,
      'update_Profile_Validator_Two'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      reverseAnimationCurve: Curves.fastOutSlowIn,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Persists updated username and avatar choice to local storage.
  void saveInfo() {
    box.write('username', editedNameController.text.trim().capitalizeFirst);
    box.write('Avatar', avatarList[selectedAvatarIndex]['icon']);
    update();
  }
}
