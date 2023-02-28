import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';

class GetTeacherController extends GetxController {
  RxList allTeachers = [].obs;

  Future getTeachers() async {
    String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    allTeachers.value = [];

    await FirebaseFirestore.instance
        .collection('Teachers')
        .where("school_email", isEqualTo: schoolEmail)
        .get()
        .then(
          (value) => allTeachers.value += value.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }
}

class GetManagementController extends GetxController {
  RxList allManagement = [].obs;

  Future getManagement() async {
    String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    allManagement.value = [];

    await FirebaseFirestore.instance
        .collection('Management')
        .where("school_email", isEqualTo: schoolEmail)
        .get()
        .then(
          (value) => allManagement.value += value.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }
}

class GetStudentController extends GetxController {
  RxList allStudents = [].obs;

  Future getStudents() async {
    String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    allStudents.value = [];

    await FirebaseFirestore.instance
        .collection('Students')
        .where("school_email", isEqualTo: schoolEmail)
        .get()
        .then(
          (value) => allStudents.value += value.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }
}
