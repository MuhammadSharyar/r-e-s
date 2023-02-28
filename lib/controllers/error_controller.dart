import 'package:get/get.dart';

class ErrorController extends GetxController {
  RxString errorMessage = "".obs;

  void setErrorMessage(String newMessage) {
    errorMessage.value = newMessage;
  }
}
