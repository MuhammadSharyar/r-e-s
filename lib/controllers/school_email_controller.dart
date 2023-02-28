import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:r_e_s/controllers/user_type_controller.dart';

class SchoolEmailController extends GetxController {
  RxString schoolEmail = "".obs;
  RxBool changeState = false.obs;

  Future getSchoolEmail() async {
    final userType = Get.find<UserTypeController>().userType.value;
    if (userType == "school") {
      schoolEmail.value = FirebaseAuth.instance.currentUser!.email.toString();
    } else if (userType == "teacher") {
      await FirebaseFirestore.instance
          .collection('Teachers')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) => schoolEmail.value = value.data()!['school_email']);
    } else if (userType == "management") {
      await FirebaseFirestore.instance
          .collection('Management')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) => schoolEmail.value = value.data()!['school_email']);
    } else if (userType == "student") {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) => schoolEmail.value = value.data()!['school_email']);
    }
  }
}
