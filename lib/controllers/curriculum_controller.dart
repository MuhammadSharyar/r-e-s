import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';

class CurriculumController extends GetxController {
  RxList classList = [].obs;
  RxList courseList = [].obs;
  RxList chapterList = [].obs;

  Future getAllData() async {
    classList.value = [];
    courseList.value = [];
    chapterList.value = [];

    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .get()
        .then((value) => classList += value.docs.map((doc) => doc.id));

    for (int i = 0; i < classList.length; i++) {
      await FirebaseFirestore.instance
          .collection("Schools")
          .doc(schoolEmail)
          .collection("Classes")
          .doc(classList[i])
          .collection("Courses")
          .get()
          .then((value) =>
              courseList += {value.docs.map((doc) => doc.id).toList()});
    }

    for (int j = 0; j < courseList.length; j++) {
      for (int k = 0; k < courseList[j].length; k++) {
        await FirebaseFirestore.instance
            .collection("Schools")
            .doc(schoolEmail)
            .collection("Classes")
            .doc(classList[j])
            .collection("Courses")
            .doc(courseList[j][k])
            .collection("Chapters")
            .get()
            .then((value) =>
                chapterList += {value.docs.map((doc) => doc.id).toList()});
      }
    }

    print(classList);
    print(courseList);
    print(chapterList);
  }
}

class classController extends GetxController {
  final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
  RxList classList = [].obs;

  Future getClasses() async {
    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .get()
        .then(
          (value) => classList += value.docs.map((doc) => doc.id),
        );
  }
}
