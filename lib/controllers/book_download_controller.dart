import 'package:get/get.dart';

class BookDownloadController extends GetxController {
  RxBool showLoading = false.obs;

  void setLoading(bool newValue) {
    showLoading.value = newValue;
  }
}
