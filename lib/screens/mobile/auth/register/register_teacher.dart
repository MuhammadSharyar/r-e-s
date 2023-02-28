import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/error_controller.dart';

import '../../../../controllers/dropdown_controllers.dart';
import '../../../../controllers/loading_controller.dart';
import '../../../../services/auth_service.dart';
import '../../../../utils/helper_widgets.dart';
import '../../all_screens/all_screens.dart';

// ignore: must_be_immutable
class RegisterTeacher extends StatelessWidget {
  RegisterTeacher({Key? key}) : super(key: key);

  final keyController = TextEditingController();
  final schoolEmailController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = Get.put(GenderController());
  final errorController = Get.put(ErrorController());
  final loadingController = Get.put(LoadingController());
  String teacherSecurityKey = "";

  Future registerTeacher() async {
    if (keyController.text == "" ||
        schoolEmailController.text == "" ||
        nameController.text == "" ||
        emailController.text == "" ||
        passController.text == "" ||
        confirmPassController.text == "" ||
        phoneController.text == "" ||
        addressController.text == "" ||
        genderController.selectedGender.value == "Select gender") {
      errorController.setErrorMessage('Please fill all fields.');
    } else if (passController.text != confirmPassController.text) {
      errorController.setErrorMessage('Passwords are not similar.');
    } else {
      try {
        var schoolAccountExists = false;
        await FirebaseFirestore.instance
            .collection('Schools')
            .doc(schoolEmailController.text.trim())
            .get()
            .then((value) {
          if (value.exists) {
            schoolAccountExists = true;
          } else {
            schoolAccountExists = false;
          }
        });
        if (schoolAccountExists == true) {
          await FirebaseFirestore.instance
              .collection("Schools")
              .doc(schoolEmailController.text.trim())
              .get()
              .then((value) =>
                  teacherSecurityKey = value.data()!['keyForTeachers']);

          if (keyController.text.trim() != teacherSecurityKey) {
            errorController.setErrorMessage('Your provided key is incorrect.');
          } else {
            loadingController.setLoading(true);
            errorController.setErrorMessage('');
            await AuthService().createTeacherAccount(
              key: keyController.text.trim(),
              schoolEmail: schoolEmailController.text.trim(),
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passController.text.trim(),
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
              gender: genderController.selectedGender.value,
            );
            loadingController.setLoading(false);
            if (FirebaseAuth.instance.currentUser != null) {
              Get.offAll(AllScreens());
            }
          }
        } else if (schoolAccountExists == false) {
          loadingController.setLoading(false);
          errorController.setErrorMessage('Please enter a valid school email.');
        }
      } on FirebaseAuthException catch (e) {
        loadingController.setLoading(false);
        if (e.message.toString().contains(
            "The email address is already in use by another account")) {
          errorController.setErrorMessage("The email is already in use.");
        } else {
          errorController.setErrorMessage(e.message.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Registration")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customTextField(
                  controller: keyController,
                  labelText: "Enter the key provided by school",
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: schoolEmailController,
                  labelText: "School Email",
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: nameController,
                  labelText: "Your Name",
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: emailController,
                  labelText: "Your Email",
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                passwordTextField(
                  controller: passController,
                  labelText: "Your Password",
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                passwordTextField(
                  controller: confirmPassController,
                  labelText: "Confirm Password",
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: phoneController,
                  labelText: "Your Contact",
                  textInputType: TextInputType.phone,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: addressController,
                  labelText: "Your Address",
                  textInputType: TextInputType.streetAddress,
                ),
                addVerticalSpace(10),
                GetX<GenderController>(
                  builder: (controller) {
                    return genderDropdown(controller: controller);
                  },
                ),
                addVerticalSpace(10),
                GetX<ErrorController>(
                  builder: (controller) => errorText(controller),
                ),
                addVerticalSpace(10),
                GetX<LoadingController>(builder: (controller) {
                  return registerButton(
                    context: context,
                    controller: controller,
                    onPressed: () async {
                      if (controller.loading.value == false) {
                        await registerTeacher();
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
