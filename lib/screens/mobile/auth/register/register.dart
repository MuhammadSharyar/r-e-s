import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/screens/mobile/auth/register/register_management.dart';
import 'package:r_e_s/screens/mobile/auth/register/register_school.dart';
import 'package:r_e_s/screens/mobile/auth/register/register_student.dart';
import 'package:r_e_s/screens/mobile/auth/register/register_teacher.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customOutlinedButton(
                context: context,
                text: "School Registration",
                onPressed: () => {
                  Get.find<ErrorController>().setErrorMessage(""),
                  Get.to(RegisterSchool())
                },
              ),
              addVerticalSpace(10),
              customOutlinedButton(
                context: context,
                text: "Teacher Registration",
                onPressed: () => {
                  Get.find<ErrorController>().setErrorMessage(""),
                  Get.to(RegisterTeacher()),
                },
              ),
              addVerticalSpace(10),
              customOutlinedButton(
                context: context,
                text: "Management Registration",
                onPressed: () => {
                  Get.find<ErrorController>().setErrorMessage(""),
                  Get.to(RegisterManagement()),
                },
              ),
              addVerticalSpace(10),
              customOutlinedButton(
                context: context,
                text: "Student Registration",
                onPressed: () => {
                  Get.find<ErrorController>().setErrorMessage(""),
                  Get.to(RegisterStudent()),
                },
              ),
              addVerticalSpace(20),
              customTextButton(
                  text: "Already have an account?",
                  onPressed: () => Get.back()),
            ],
          ),
        ),
      ),
    );
  }
}
