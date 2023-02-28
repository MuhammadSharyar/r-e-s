import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/screens/mobile/all_screens/all_screens.dart';
import 'package:r_e_s/utils/helper_widgets.dart';
import '../../../controllers/navigation_controller.dart';
import '../home/teacher_home.dart';
import '../profile/profile.dart';

// ignore: must_be_immutable
class TeacherScreens extends StatelessWidget {
  TeacherScreens({Key? key}) : super(key: key);

  final navigationController = Get.put(NavigationController());

  List screens = [
    TeacherHome(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: GetX<NavigationController>(builder: (controller) {
        return myBottomNavigationBar(
          controller: controller,
          onTap: (newIndex) {
            controller.setCurrentIndex(newIndex);
          },
        );
      }),
    );
  }
}
