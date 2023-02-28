import 'package:get/get.dart';

class LoadingController extends GetxController {
  RxBool loading = false.obs;

  void setLoading(bool changeLoading) {
    loading.value = changeLoading;
  }
}
