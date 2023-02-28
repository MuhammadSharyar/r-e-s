import 'package:get/get.dart';

class FilenameController extends GetxController {
  RxString filename = ''.obs;

  void setFilename(String newname) {
    filename.value = newname;
  }
}
