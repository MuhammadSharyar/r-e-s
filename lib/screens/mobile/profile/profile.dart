import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/user_info_controller.dart';
import 'package:r_e_s/utils/helper_widgets.dart';
import '../../../controllers/user_type_controller.dart';
import '../../../theme/theme_constants.dart';
import '../auth/login/login.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  final userType = Get.find<UserTypeController>().userType.value;
  final userDetailsController = Get.put(UserInfoController());

  @override
  Widget build(BuildContext context) {
    return GetX<UserInfoController>(builder: (controller) {
      if (controller.userDetails == {}) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: TextStyle(fontSize: xlarge),
              ),
              addVerticalSpace(30),
              ElevatedButton(
                child: const Text("Sign Out"),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (FirebaseAuth.instance.currentUser == null) {
                    Get.offAll(Login());
                  }
                },
              ),
              addVerticalSpace(30),
              (userType == "school")
                  ? Obx(() {
                      if (controller.userDetails.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            keyCard(
                              context: context,
                              title: "Key for Teachers",
                              keyText: controller.userDetails['keyForTeachers'],
                            ),
                            keyCard(
                              context: context,
                              title: "Key for Management",
                              keyText:
                                  controller.userDetails['keyForManagement'],
                            ),
                            keyCard(
                              context: context,
                              title: "Key for Students",
                              keyText: controller.userDetails['keyForStudents'],
                            ),
                          ],
                        ),
                      );
                    })
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}
