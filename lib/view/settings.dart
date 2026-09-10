import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test/controller/news_controller.dart';

import '../controller/base_controller.dart';
import '../controller/theme_controller.dart';
import '../helper/lang.dart';
import '../widgets/double_back_to_exit_wrapper.dart';
import '../widgets/nav_bar_icons.dart';
import '../widgets/nav_bars.dart';
import '../widgets/settings_cards.dart';

/// Screen for displaying user profile shortcuts, theme toggles, language settings, and app info.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BaseController baseController = Get.put(BaseController());
  final NewsController newsController = Get.put(NewsController());


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return ReturnHome(
      child: Scaffold(
        body: GetBuilder<ThemeController>(
          init: ThemeController(),
          builder: (controller) {
            return SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                children: [
                  // 1. User Profile Header Card
                  GestureDetector(
                    onTap: () {
                      baseController.changeIndex(4);
                      Get.offNamed('/profile');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).cardTheme.color?.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF0F52BA),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(
                                box.read('Avatar') ?? 'images/man.png',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  box.read('username') ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'settings_Under_Name'.tr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Application Preferences Section (Theme & Language)
                  buildSectionTitle('settings_Under_Preferences_Section'.tr),
                  const SizedBox(height: 10),
                  buildSettingsCard(context, [
                    GestureDetector(
                      onTap: () {
                        controller.changeTheme();
                      },
                      child: ListTile(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        title: Text.rich(
                          TextSpan(
                            text:
                                '${controller.isDarkMode ? "settings_Dark_Mode".tr : "settings_Light_Mode".tr}\n',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                            ),
                            children: [
                              TextSpan(
                                text: "settings_Dark_Mode_Des".tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: Icon(
                          controller.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: Colors.blue,
                        ),
                        trailing: Switch(
                          value: controller.isDarkMode,
                          activeThumbColor: Colors.blue,
                          inactiveTrackColor: Colors.grey.withValues(
                            alpha: 0.6,
                          ),
                          onChanged: (value) {
                            controller.changeTheme();
                          },
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 50),
                    GetBuilder<LangController>(
                      builder: (langController) {
                        String currentLangCode =
                            GetStorage().read('isEnglish') ?? 'en';

                        String displayLanguageName = currentLangCode == 'ar'
                            ? 'العربية'
                            : 'English';

                        return buildListTile(
                          context: context,
                          title: 'settings_Lang'.tr,
                          subtitle: displayLanguageName,
                          icon: Icons.language_outlined,
                          onTap: langController.showLanguageDialog,
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // 3. إدارة البيانات والمحتوى (Content & Storage)
                  buildSectionTitle('settings_Under_storage_Section'.tr),
                  const SizedBox(height: 10),
                  buildSettingsCard(context, [
                    buildListTile(
                      context: context,
                      title: 'settings_Cache'.tr,
                      subtitle: 'settings_Cache_Des'.tr,
                      icon: Icons.cleaning_services_outlined,
                      onTap: () async {
                        newsController.deleteCaches();
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // 3. Support & App Information Section
                  buildSectionTitle('settings_Under_Support_Section'.tr),
                  const SizedBox(height: 10),
                  buildSettingsCard(context, [
                    buildListTile(
                      context: context,
                      title: 'settings_Rate'.tr,
                      subtitle: 'settings_Rate_Des'.tr,
                      icon: Icons.star_border_rounded,
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 50),
                    buildListTile(
                      context: context,
                      title: 'settings_Privacy'.tr,
                      subtitle: 'settings_Privacy_Des'.tr,
                      icon: Icons.privacy_tip_outlined,
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 50),
                    buildListTile(
                      context: context,
                      title: 'settings_Version'.tr,
                      subtitle: 'settings_Version_Des'.tr,
                      icon: Icons.info_outline,
                      onTap: null,
                    ),
                  ]),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: NavBars(navGenre: buildNavItem),
      ),
    );
  }
}
