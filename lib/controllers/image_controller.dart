import 'package:get/get.dart';

class ImageController extends GetxController {
  RxString pickedImage = ''.obs;

  void setPickedImage(String path) {
    pickedImage.value = path;
  }
}
