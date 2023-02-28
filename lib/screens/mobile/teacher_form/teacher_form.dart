import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/dropdown_controllers.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

class TeacherForm extends StatelessWidget {
  final loadingController = Get.put(LoadingController());
  final errorController = Get.put(ErrorController());
  final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  // FOR OFFICE ONLY
  final regNoController = TextEditingController();
  final dateOfRegController = TextEditingController();

  // TEACHER INFORMATION
  final nameController = TextEditingController();
  final genderController = Get.put(GenderController());
  final dobController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final religionController = TextEditingController();
  final nationalityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emergencyPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Form"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FOR OFFICE USE ONLY",
                style: TextStyle(
                  fontSize: large,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addVerticalSpace(10),
              customTextField(
                controller: regNoController,
                labelText: "Registration No.",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: dateOfRegController,
                labelText: "Date of Registration",
                textInputType: TextInputType.datetime,
              ),
              addVerticalSpace(10),
              Text(
                "TEACHER INFORMATION",
                style: TextStyle(
                  fontSize: large,
                  fontWeight: FontWeight.bold,
                ),
              ),
              customTextField(
                controller: regNoController,
                labelText: "Registration No.",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: nameController,
                labelText: "Full Name",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              GetX<GenderController>(
                builder: (controller) {
                  return genderDropdown(controller: controller);
                },
              ),
              customTextField(
                controller: dobController,
                labelText: "Date of Birth",
                textInputType: TextInputType.datetime,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: placeOfBirthController,
                labelText: "Place of Birth",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: religionController,
                labelText: "Religion",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: nationalityController,
                labelText: "Nationality",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: addressController,
                labelText: "Address",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: phoneController,
                labelText: "Phone No.",
                textInputType: TextInputType.phone,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: emergencyPhoneController,
                labelText: "Emergency Phone No.",
                textInputType: TextInputType.phone,
              ),
              addVerticalSpace(10),
              GetX<ErrorController>(builder: (controller) {
                return errorText(controller);
              }),
              addVerticalSpace(10),
              customButton1(
                context: context,
                title: "Submit",
                onPressed: () async {
                  if (regNoController.text == "" ||
                      dateOfRegController.text == "" ||
                      nameController.text == "" ||
                      dobController.text == "" ||
                      genderController.selectedGender.value ==
                          "Select gender" ||
                      placeOfBirthController.text == "" ||
                      religionController.text == "" ||
                      nationalityController.text == "" ||
                      addressController.text == "" ||
                      phoneController.text == "" ||
                      emergencyPhoneController.text == "") {
                    errorController.setErrorMessage("Please fill all fields");
                  } else {
                    try {
                      loadingController.setLoading(true);
                      errorController.setErrorMessage("");

                      await FirebaseFirestore.instance
                          .collection("Schools")
                          .doc(schoolEmail)
                          .collection("Teacher Forms")
                          .doc(regNoController.text)
                          .set({
                        "teacherRegNo": regNoController.text.trim(),
                        "dateOfReg": dateOfRegController.text.trim(),
                        "teacherName": nameController.text.trim(),
                        "gender": genderController.selectedGender.value,
                        "teacherDob": dobController.text.trim(),
                        "placeOfBirth": placeOfBirthController.text.trim(),
                        "religion": religionController.text.trim(),
                        "nationality": nationalityController.text.trim(),
                        "address": addressController.text.trim(),
                        "phone": phoneController.text.trim(),
                        "emergencyPhone": emergencyPhoneController.text.trim(),
                      });
                      loadingController.setLoading(false);
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Form added successfully",
                      );
                    } catch (_) {
                      loadingController.setLoading(false);
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: "Cannot add form rightnow please try later",
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
