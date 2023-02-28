import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTypeController extends GetxController {
  RxString userType = "".obs;

  Future getUserType() async {
    userType.value = "";
    var userTypeFound = false;

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then(
      (value) async {
        if (value.exists) {
          userType.value = "school";
          userTypeFound = true;
        }
      },
    );

    if (userTypeFound == false) {
      await FirebaseFirestore.instance
          .collection("Teachers")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            userType.value = "teacher";
            userTypeFound = true;
          }
        },
      );
    }

    if (userTypeFound == false) {
      await FirebaseFirestore.instance
          .collection("Management")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            userType.value = "management";
            userTypeFound = true;
          }
        },
      );
    }

    if (userTypeFound == false) {
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            userType.value = "student";
            userTypeFound = true;
          }
        },
      );
    }

    if (userTypeFound == false) {
      userType.value = "none";
      FirebaseAuth.instance.signOut();
      // Get.offAll(Login());
    }
  }
}
