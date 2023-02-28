import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/user_type_controller.dart';

class UserInfoController extends GetxController {
  RxMap userDetails = {}.obs;
  var permissions = {}.obs;

  Future getInfo() async {
    var userType = Get.find<UserTypeController>().userType.value;
    userDetails.value = {};
    permissions.value = {};
    if (userType == "school") {
      await FirebaseFirestore.instance
          .collection('Schools')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) {
        userDetails.value = value.data()!;
      });
    } else if (userType == "teacher") {
      await FirebaseFirestore.instance
          .collection('Teachers')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) {
        userDetails.value = value.data()!;
      });
    } else if (userType == "management") {
      await FirebaseFirestore.instance
          .collection('Management')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) {
        userDetails.value = value.data()!;
        print(userDetails);
      });
    } else if (userType == "student") {
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) {
        userDetails.value = value.data()!;
      });
    }
  }
}
