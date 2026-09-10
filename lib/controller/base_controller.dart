import 'package:get/get.dart';

class BaseController extends GetxController {
  int navCurrentIndex = 2;

  void changeIndex(int index) {
    navCurrentIndex = index;
    update();
  }
}
