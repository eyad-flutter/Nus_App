import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/helper/consts.dart';
import 'package:test/view/home_screen.dart';

import '../controller/profile_controller.dart';
import '../widgets/double_back_to_exit_wrapper.dart';

/// Screen for initial username setup during onboarding/login flow.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController nameController = TextEditingController();
  final ProfileController controller = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: Get.mediaQuery.size.height * 0.25),

                // Screen title header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "login_Name".tr,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: Get.mediaQuery.size.height * 0.08),

                // Username input form field
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
                      controller: nameController,
                      cursorColor: Theme.of(
                        context,
                      ).textSelectionTheme.cursorColor,
                      cursorHeight: 20,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionTheme.cursorColor,
                      ),
                      decoration: InputDecoration(
                        // Hide default error text space to use custom snackBars
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
              ],
            ),
          ),
        ),

        // Navigation FAB to move to avatar selection
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              return;
            }

            box.write('username', nameController.text.trim().capitalizeFirst);

            Get.off(
              () => const LoginAvatar(),
              transition: Transition.leftToRightWithFade,
              duration: const Duration(milliseconds: 300),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Screen for avatar selection during initial setup.
class LoginAvatar extends StatefulWidget {
  const LoginAvatar({super.key});

  @override
  State<LoginAvatar> createState() => _LoginAvatarState();
}

class _LoginAvatarState extends State<LoginAvatar> {
  final TextEditingController avatarController = TextEditingController();
  int selectedAvatarIndex = 0;
  final box = GetStorage();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: Get.mediaQuery.size.height * 0.25),

                // Screen title header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "login_Avatar".tr,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: Get.mediaQuery.size.height * 0.05),

                // Horizontal avatar selection list
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarList.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedAvatarIndex == index;
                      Color itemColor = avatarList[index]['color'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatarIndex = index;
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
              ],
            ),
          ),
        ),

        // Navigation FAB to save avatar and enter HomeScreen
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            box.write('Avatar', avatarList[selectedAvatarIndex]['icon']);
            Get.off(
              () => const HomeScreen(),
              transition: Transition.leftToRightWithFade,
              duration: const Duration(milliseconds: 300),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
