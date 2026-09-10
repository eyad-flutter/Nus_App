import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class Lang extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'home_Profile_Wel': 'Hello,',
      'home_Profile_Bio': 'Discover The World Around You',
      'home_News_Sec_Title': 'Discover',
      'home_News_Sec_All': 'View all',
      'home_No_News': 'No News Found',

      'update_Profile_Banner': 'Update Profile',
      'update_Profile_Avatar': 'Choose Your New Avatar',
      'update_Profile_Name': 'How Do You Want To Be Called?',
      'update_Profile_Button': 'Save Changes',
      'update_Profile_Validator_Error': 'Error!',
      'update_Profile_Validator_One': 'Please Type Your Name',
      'update_Profile_Validator_Two': 'Name Must Be Under 14 Character!',
      'text_Form_Hint': 'Type your name',
      'text_Form_Label': 'Name',

      'update_Profile_Msg_Done': 'Done!',
      'update_Profile_Msg_Done_Des': 'Profile Updated Successfully',
      'update_Profile_Msg_Nothing': 'Nothing',
      'update_Profile_Msg_Nothing_Des': 'Nothing to change!',
      'update_Profile_Msg_Unsaved': 'Unsaved Changes',
      'update_Profile_Msg_Unsaved_Des':
          'You have unsaved changes in your profile. Are you sure you want to leave without saving?',
      'update_Profile_Msg_Discard': 'Discard',
      'update_Profile_Msg_Keep_Editing': 'Keep Editing',

      'login_Avatar': 'Choose \n     your avatar',
      'login_Name': 'Tell us \n     your name',

      'settings_Under_Name': 'User Preferences & App Setup',

      'settings_Under_Preferences_Section': 'PREFERENCES',
      'settings_Dark_Mode': 'Dark Mode',
      'settings_Light_Mode': 'Light Mode',
      'settings_Dark_Mode_Des': 'Switch Between Light \n& Dark Theme',
      'settings_Lang': 'App Language',

      'settings_Under_storage_Section': 'CONTENT & STORAGE',
      'settings_Cache': 'Clear Cache',
      'settings_Cache_Des': 'Free Up Local Memory',
      'settings_Cache_Snack': 'Cache Cleared',
      'settings_Cache_Snack_Des': 'Local temporary files deleted successfully.',
      'settings_Cache_Snack_Nothing': 'Nothing!',
      'settings_Cache_Snack_Nothing_Des': 'No Caches To Delete.',


      'settings_Under_Support_Section': 'SUPPORT & ABOUT',
      'settings_Rate': 'Rate App',
      'settings_Rate_Des': 'Support Us On Store',
      'settings_Privacy': 'Privacy Policy',
      'settings_Privacy_Des': 'Terms Of Service & Legal Info',
      'settings_Version': 'App Version',
      'settings_Version_Des': 'v1.0.0',

      'favorite_Banner': 'Favorite News',
      'favorite_Msg_Remove': 'Removed',
      'favorite_Msg_Remove_Des': 'Article removed from favorites',
      'favorite_Msg_Saved': 'Saved',
      'favorite_Msg_Saved_Des': 'Article added to favorites',

      'News_Details_Msg_Category': 'GENERAL',
      'News_Details_Msg_Title': 'No Title Available',
      'News_Details_Msg_Source': 'Unknown Source',
      'News_Details_Msg_Date': 'Recent',
      'News_Details_Msg_Creator': 'Editor',
      'news_Details_Ai': 'AI Summary',
      'News_Details_Description': 'No Full Content Available for this Article.',

      'categories': 'All',
      'categories_Sports': 'Sports',
      'categories_Politics': 'Politics',
      'categories_Entertainment': 'Entertainment',
      'categories_Tech': 'Technology',
      'categories_Business': 'Business',
      'categories_Science': 'Science',

      'splash_Skip': 'Skip',
      'splash_Get_Started': 'Get Started',
      'splash_Continue': 'Continue',

      'splash_Title_One': 'Connect with Family\n& Friends',
      'splash_Title_Two': 'Discover Trending\nStories',
      'splash_Title_Three': 'Never Miss a Moment',

      'splash_Des_One':
          'Share your moments, stay updated, and keep\nthe conversation going with people.',
      'splash_Des_Two':
          'Explore the latest news and updates from around\nthe world tailored to your interests.',
      'splash_Des_Three':
          'Get instant notifications and personalized content\nright at your fingertips anytime.',

      'double_Click_Exit': 'Press again to exit',

      'banner_Cards_Msg_Title': 'No Title',
      'banner_Cards_Msg_Unknown': 'Unknown',

      'favorites_Widgets_Msg_Title': 'No Title ',
      'favorites_Widgets_Msg_Category': 'GENERAL',
      'favorites_Widgets_Msg_No_News': 'No Favorites Saved Yet',
      'favorites_Widgets_Msg_No_News_Des':
          'Click the heart icon on any news to save it here.',

      'News_Card_Msg_Category': 'GENERAL',
      'News_Card_Msg_Title': 'No Title Available',
      'News_Card_Msg_Source': 'Unknown Source',
      'News_Card_Msg_Date': 'Recent',

      'view_All_HeadLine': 'Discover',
      'view_All_HeadLine_Des': 'News from all around the world',
      'view_All_Search_Hint': 'Search',
      'view_All_Msg_Date': 'No news found',
      'view_All_country_All': 'All',
      'view_All_country_Arabic': 'Arabic',
      'view_All_country_India': 'India',
      'view_All_country_US': 'United States',

      'news_Controller_Msg': 'Warning!',
      'news_Controller_Msg_Des': 'The maximum number of requests has been reached currently, please try again in a little while',

      'categories_Title': 'Discover Topics',
      'categories_Subtitle': 'Select a category to view the latest stories',

    },

    'ar': {
      'home_Profile_Wel': 'اهلا,',
      'home_Profile_Bio': 'اكتشف العالم من حولك',
      'home_News_Sec_Title': 'استكشف',
      'home_News_Sec_All': 'عرض الكل',
      'home_No_News': 'لا يوجد اخبار',

      'update_Profile_Banner': 'تحديث البيانات الشخصية',
      'update_Profile_Avatar': 'اختر الصورة الجديدة الخاصة بك',
      'update_Profile_Name': 'كيف تريد ان يتم مناداتك؟',
      'update_Profile_Button': 'سجل التغييرات',
      'update_Profile_Validator_Error': 'خطأ!',
      'update_Profile_Validator_One': 'من فضلك ادخل اسمك',
      'update_Profile_Validator_Two': 'الاسم يجب ان لا يتخطى ال ١٤ حرف!',
      'text_Form_Hint': 'ادخل اسمك',
      'text_Form_Label': 'الاسم',

      'update_Profile_Msg_Done': 'تم!',
      'update_Profile_Msg_Done_Des': 'تم تحديث الملف الشخصي بنجاح',
      'update_Profile_Msg_Nothing': 'لا شئ',
      'update_Profile_Msg_Nothing_Des': 'لا شئ للتغير!',
      'update_Profile_Msg_Unsaved': 'تغييرات غير محفوظة',
      'update_Profile_Msg_Unsaved_Des':
          'لديك تغييرات لم يتم حفظها في ملفك الشخصي. هل انت متأكد انك تريد المغادرة بدون حفظ؟',
      'update_Profile_Msg_Discard': 'الغاء',
      'update_Profile_Msg_Keep_Editing': 'متابعة التعديل',

      'login_Avatar': 'اختر الصورة الخاصة بك',
      'login_Name': 'اخبرنا باسمك',

      'settings_Under_Name': 'تفضيلات المستخدم وإعداد التطبيق',

      'settings_Under_Preferences_Section': 'التفضيلات',
      'settings_Dark_Mode': 'الوضع الداكن',
      'settings_Light_Mode': 'الوضع الفاتح',
      'settings_Dark_Mode_Des': 'التبديل بين الوضع \nالفاتح والداكن',
      'settings_Lang': 'اللغة',

      'settings_Under_storage_Section': 'المحتوى والمساحة',
      'settings_Cache': 'مسح الذاكرة المؤقتة',
      'settings_Cache_Des': 'تحرير الذاكرة المحلية',
      'settings_Cache_Snack': 'تم مسح الذاكرة المؤقتة',
      'settings_Cache_Snack_Des': 'تم حذف الملفات المؤقتة المحلية بنجاح.',
      'settings_Cache_Snack_Nothing': 'لا شئ!',
      'settings_Cache_Snack_Nothing_Des': 'لا توجد ملفات مؤقتة للحذف.',

      'settings_Under_Support_Section': 'الدعم والمعلومات',
      'settings_Rate': 'تقييم التطبيق',
      'settings_Rate_Des': 'قيم تطبيقنا على المتجر',
      'settings_Privacy': 'سياسة الخصوصية',
      'settings_Privacy_Des': 'شروط الخدمة والمعلومات القانونية',
      'settings_Version': 'الاصدار',
      'settings_Version_Des': 'اصدار ١.٠.٠',

      'favorite_Banner': 'الاخبار المفضلة',
      'favorite_Msg_Remove': 'تم الحذف',
      'favorite_Msg_Remove_Des': 'تمت ازالة المقالة من المفضلة',
      'favorite_Msg_Saved': 'تم الحفظ',
      'favorite_Msg_Saved_Des': 'تمت اضافة المقالة للمفضلة',

      'news_Details_Msg_Category': 'اخبار',
      'news_Details_Msg_Title': 'لا يوجد عنوان',
      'news_Details_Msg_Source': 'مصدر غير معروف',
      'news_Details_Msg_Date': 'منذ قليل',
      'news_Details_Msg_Creator': 'محرر',
      'news_Details_Ai': 'ملخص الذكاء الاصطناعي',
      'news_Details_Description': 'لا يوجد محتوى كامل متاح لهذه المقالة.',

      'categories': 'الكل',
      'categories_Sports': 'الرياضة',
      'categories_Politics': 'السياسة',
      'categories_Entertainment': 'الترفيه',
      'categories_Tech': 'التكنولوجيا',
      'categories_Business': 'العمل',
      'categories_Science': 'العلم',

      'splash_Skip': 'تخطي',
      'splash_Get_Started': 'ابدا',
      'splash_Continue': 'استمر',

      'splash_Title_One': 'تواصل مع العائلة والأصدقاء',
      'splash_Title_Two': 'اكتشف القصص الرائجة',
      'splash_Title_Three': 'لا تفوت اي لحظة',

      'splash_Des_One':
          'شارك لحظاتك، وابقى على اطلاع، \nواستمر في الحديث مع الآخرين.',
      'splash_Des_Two':
          'اكتشف احدث الاخبار \nوالتحديثات من حول العالم وفقا لاهتماماتك.',
      'splash_Des_Three':
          'احصل على اشعارات فورية \nومحتوى مخصص بين يديك في اي وقت.',

      'double_Click_Exit': 'اضغط مجددا للخروج',

      'banner_Cards_Msg_Title': 'لا يوجد عنوان',
      'banner_Cards_Msg_Unknown': 'غير معروف',

      'favorites_Widgets_Msg_Title': 'لا يوجد عنوان',
      'favorites_Widgets_Msg_Category': 'عام',
      'favorites_Widgets_Msg_No_News': 'لا توجد مفضلات محفوظة بعد',
      'favorites_Widgets_Msg_No_News_Des':
          'اضغط على القلب على اي خبر لحفظه هنا.',

      'News_Card_Msg_Category': 'عام',
      'News_Card_Msg_Title': 'لا يوجد عنوان',
      'News_Card_Msg_Source': 'مصدر غير معروف',
      'News_Card_Msg_Date': 'منذ قليل',

      'view_All_HeadLine': 'استكشف',
      'view_All_HeadLine_Des': 'اخبار من كل انحاء العالم',
      'view_All_Search_Hint': 'البحث',
      'view_All_Msg_Date': 'لا يوجد اخبار',
      'view_All_country_All': 'الكل',
      'view_All_country_Arabic': 'عربي',
      'view_All_country_India': 'هندي',
      'view_All_country_US': 'أمريكي',

      'news_Controller_Msg': 'تنبيه',
      'news_Controller_Msg_Des': 'تم الوصول للحد الأقصى للطلبات حالياً، يرجى المحاولة بعد قليل',

      'categories_Title': 'استكشف الاقسام',
      'categories_Subtitle': 'اختر القسـم لعرض احدث الاخبار التابعة له',

    },
  };
}

class LangController extends GetxController {
  void switchLang(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
    update();
  }

  void showLanguageDialog() {
    final controller = Get.find<LangController>();

    final box = GetStorage();

    String selectedLanguage = box.read('isEnglish') ?? 'en';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Get.theme.cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: selectedLanguage == 'en'
                  ? const Icon(Icons.check, color: Color(0xFF0F52BA))
                  : null,
              onTap: () {
                controller.switchLang('en');
                box.write('isEnglish', 'en');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('العربية'),
              trailing: selectedLanguage == 'ar'
                  ? const Icon(Icons.check, color: Color(0xFF0F52BA))
                  : null,
              onTap: () {
                controller.switchLang('ar');
                box.write('isEnglish', 'ar');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
