import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/controllers/user_info_controller.dart';
import 'package:r_e_s/screens/mobile/all_screens/all_screens.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

import '../../../controllers/navigation_controller.dart';
import '../home/school_home.dart';
import '../profile/profile.dart';

// ignore: must_be_immutable
class SchoolScreens extends StatelessWidget {
  SchoolScreens({Key? key}) : super(key: key);

  final navigationController = Get.put(NavigationController());
  final userInfoController = Get.put(UserInfoController());
  final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  List screens = [
    const SchoolHome(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    print("School Email: $schoolEmail");
    userInfoController.getInfo();
    return GetX<UserInfoController>(builder: (controller) {
      if (controller.userDetails == {}) {
        return Scaffold(
          body: Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          )),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: GetX<NavigationController>(
            builder: (controller) {
              return (controller.currentIndex.value == 0)
                  ? const Text("Home")
                  : const Text("Profile");
            },
          ),
        ),
        body: GetX<NavigationController>(
          builder: (controller) {
            return screens[controller.currentIndex.value];
          },
        ),
        bottomNavigationBar: GetX<NavigationController>(
          builder: (controller) {
            return myBottomNavigationBar(
              controller: controller,
              onTap: (newIndex) {
                controller.setCurrentIndex(newIndex);
              },
            );
          },
        ),
      );
    });
  }
}
