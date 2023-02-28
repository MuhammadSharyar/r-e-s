import 'package:get/get.dart';

class ObscureController extends GetxController {
  RxBool obscure = true.obs;

  void setObscure(bool newValue) {
    obscure.value = newValue;
  }
}
