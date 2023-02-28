import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/get_school_details.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/controllers/user_info_controller.dart';
import 'package:r_e_s/screens/mobile/all_screens/management_screens.dart';
import 'package:r_e_s/screens/mobile/all_screens/school_screens.dart';
import 'package:r_e_s/screens/mobile/all_screens/student_screens.dart';
import 'package:r_e_s/screens/mobile/all_screens/teacher_screens.dart';
import '../../../controllers/error_controller.dart';
import '../../../controllers/user_type_controller.dart';

// ignore: must_be_immutable
class AllScreens extends StatelessWidget {
  AllScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userTypeController = Get.put(UserTypeController());
    var schoolEmailController = Get.put(SchoolEmailController());
    var schoolDetailsController = Get.put(GetSchoolDetails());

    userTypeController.getUserType().whenComplete(
      () async {
        await schoolEmailController.getSchoolEmail();
        await schoolDetailsController.getSchoolDetails();
        Get.put(UserInfoController());
        Get.put(ErrorController());
      },
    );

    return GetX<UserTypeController>(
      builder: ((controller) {
        if (controller.userType.value == "" ||
            schoolEmailController.schoolEmail.value == "") {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          print("USER TYPE: ${userTypeController.userType}");
          print("SCHOOL EMAIL: ${schoolEmailController.schoolEmail.value}");
          return (controller.userType.value == "school")
              ? SchoolScreens()
              : (controller.userType.value == "teacher")
                  ? TeacherScreens()
                  : (controller.userType.value == "management")
                      ? ManagementScreens()
                      : (controller.userType.value == "student")
                          ? StudentScreens()
                          : const Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
        }
      }),
    );
  }
}
