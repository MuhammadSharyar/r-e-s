import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/image_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/theme/theme_constants.dart';

import '../../../../services/auth_service.dart';
import '../../../../utils/helper_widgets.dart';
import '../../all_screens/all_screens.dart';

class RegisterSchool extends StatelessWidget {
  RegisterSchool({Key? key}) : super(key: key);

  final schoolNameController = TextEditingController();
  final schoolAddressController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final imageController = Get.put(ImageController());
  final errorController = Get.put(ErrorController());
  final loadingController = Get.put(LoadingController());

  Future registerSchool() async {
    if (imageController.pickedImage.value == "") {
      errorController.setErrorMessage('Please pick your school logo.');
    } else if (schoolNameController.text == "" ||
        schoolAddressController.text == "" ||
        emailController.text == "" ||
        passController.text == "" ||
        confirmPassController.text == "") {
      errorController.setErrorMessage('Please fill all fields.');
    } else if (passController.text != confirmPassController.text) {
      errorController.setErrorMessage('Passwords are not similar.');
    } else {
      try {
        loadingController.setLoading(true);
        errorController.setErrorMessage('');
        await AuthService().createSchoolAccount(
            logo: Get.find<ImageController>().pickedImage.value,
            name: schoolNameController.text,
            address: schoolAddressController.text,
            email: emailController.text,
            password: passController.text);
        loadingController.setLoading(false);
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

  Future pickImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then(
        (pickedImage) => imageController.setPickedImage(pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Your School")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addVerticalSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await pickImage();
                      },
                      child: const Text("Pick Logo"),
                    ),
                    GetX<ImageController>(
                      builder: (controller) =>
                          (controller.pickedImage.value != "")
                              ? SizedBox(
                                  height: 150,
                                  child: Image.file(
                                    File(controller.pickedImage.value),
                                  ),
                                )
                              : Container(),
                    ),
                  ],
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: schoolNameController,
                  labelText: 'School Name',
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: schoolAddressController,
                  labelText: 'School Address',
                  textInputType: TextInputType.streetAddress,
                ),
                addVerticalSpace(10),
                customTextField(
                  controller: emailController,
                  labelText: 'Your Email',
                  textInputType: TextInputType.emailAddress,
                ),
                addVerticalSpace(10),
                passwordTextField(
                  controller: passController,
                  labelText: 'Password',
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                passwordTextField(
                  controller: confirmPassController,
                  labelText: 'Confirm Password',
                  textInputType: TextInputType.text,
                ),
                addVerticalSpace(10),
                GetX<ErrorController>(
                  builder: (controller) => errorText(controller),
                ),
                GetX<LoadingController>(builder: (controller) {
                  return registerButton(
                    context: context,
                    controller: controller,
                    onPressed: () async {
                      if (controller.loading.value == false) {
                        await registerSchool();
                      }
                    },
                  );
                }),
                addVerticalSpace(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
