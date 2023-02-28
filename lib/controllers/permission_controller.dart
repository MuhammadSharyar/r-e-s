import 'package:get/get.dart';

class ClassPermissionController extends GetxController {
  RxBool permission = false.obs;

  void setPermission(bool newPermission) {
    permission.value = newPermission;
  }
}

class CoursePermissionController extends GetxController {
  RxBool permission = false.obs;

  void setPermission(bool newPermission) {
    permission.value = newPermission;
  }
}

class ChapterPermissionController extends GetxController {
  RxBool permission = false.obs;

  void setPermission(bool newPermission) {
    permission.value = newPermission;
  }
}
