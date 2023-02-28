import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  void setCurrentIndex(int newIndex) {
    currentIndex.value = newIndex;
  }
}
