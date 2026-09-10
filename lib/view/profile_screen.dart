import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/controller/profile_controller.dart';
import 'package:test/helper/consts.dart';

import '../controller/base_controller.dart';
import '../widgets/nav_bar_icons.dart';
import '../widgets/nav_bars.dart';

/// Screen for editing user profile information (avatar and username).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final BaseController baseController = Get.put(BaseController());

  bool _isPressed = false;
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Prompt user if unsaved profile changes exist
        if (controller.profileDidChange) {
          controller.showUnsavedChangesDialog(
            onDiscard: () {
              baseController.changeIndex(2);
              Get.offNamed('/home');
            },
          );
        } else {
          baseController.changeIndex(2);
          Get.offNamed('/home');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          toolbarHeight: 70,
          title: Text(
            "update_Profile_Banner".tr,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          automaticallyImplyLeading:
              false, // Disables default leading back button
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: Get.mediaQuery.size.height * 0.05),

                  // Avatar selection section header
Text(
                      "update_Profile_Avatar".tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),


                  SizedBox(height: Get.mediaQuery.size.height * 0.03),

                  // Horizontal avatar choice selector
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: avatarList.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            controller.selectedAvatarIndex == index;
                        Color itemColor = avatarList[index]['color'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.selectedAvatarIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? itemColor
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: itemColor.withValues(alpha: 0.2),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  avatarList[index]['icon'],
                                ),
                                radius: 52,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.1),

                  // Username text field section header
Text(
                      "update_Profile_Name".tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.02),

                  // Editable username form input field
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            controller.validatorOne();
                            return '';
                          }
                          if (value.length > 14) {
                            controller.validatorTwo();
                            return '';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        controller: controller.editedNameController,
                        cursorColor: Theme.of(
                          context,
                        ).textSelectionTheme.cursorColor,
                        cursorHeight: 20,
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textSelectionTheme.cursorColor,
                        ),
                        decoration: InputDecoration(
                          // Hide default error line space to rely on custom snackBars
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          labelText: "text_Form_Label".tr,
                          labelStyle: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.6),
                          ),
                          hintText: "text_Form_Hint".tr,
                          hintStyle: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Get.mediaQuery.size.height * 0.1),

                  // Animated save profile action button
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _isPressed = true);
                    },
                    onTapUp: (_) {
                      setState(() => _isPressed = false);
                    },
                    onTapCancel: () {
                      setState(() => _isPressed = false);
                    },
                    onTap: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (controller.profileDidChange) {
                        controller.saveInfo();
                        controller.snackBar();
                        return;
                      }
                      controller.oldInfoSnackBar();
                    },
                    child: AnimatedScale(
                      scale: _isPressed ? 0.96 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      child: Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.13,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Theme.of(context).shadowColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(
                                    alpha: _isPressed ? 0.25 : 0.45,
                                  ),
                                  offset: const Offset(0, 6),
                                  blurRadius: _isPressed ? 10 : 20,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "update_Profile_Button".tr,
                                style: TextStyle(
                                  color: Colors.white70.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavBars(navGenre: buildNavItemProfile),
      ),
    );
  }
}
