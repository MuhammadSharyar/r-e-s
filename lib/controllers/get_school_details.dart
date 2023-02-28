import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';

class GetSchoolDetails extends GetxController {
  RxMap schoolDetails = {}.obs;

  Future getSchoolDetails() async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .get()
        .then((doc) => schoolDetails.value = doc.data()!);
  }
}
