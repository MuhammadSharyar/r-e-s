import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/curriculum_controller.dart';
import 'package:r_e_s/controllers/dropdown_controllers.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

class StudentForm extends StatelessWidget {
  final loadingController = Get.put(LoadingController());
  final errorController = Get.put(ErrorController());
  final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  // FOR OFFICE ONLY
  final regNoController = TextEditingController();
  final dateOfRegController = TextEditingController();
  final classDropdownController = Get.put(ClassController());

  // CHILD INFORMATION
  final nameController = TextEditingController();
  final genderController = Get.put(GenderController());
  final dobController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final religionController = TextEditingController();
  final nationalityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emergencyPhoneController = TextEditingController();

  // PARENT INFORMATION
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final fatherCNICController = TextEditingController();
  final motherCNICController = TextEditingController();
  final parentAddressController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final occupationController = TextEditingController();
  final designationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (classDropdownController.classList.isEmpty) {
      classDropdownController.getClasses();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Form"),
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
              GetX<ClassController>(builder: (controller) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: controller.currentClass.value,
                      items: [
                        const DropdownMenuItem(
                          value: "Select Class",
                          child: Text("Select Class"),
                        ),
                        ...controller.classList.map(
                          (c) => DropdownMenuItem(
                            value: c['name'],
                            child: Text(c['name']),
                          ),
                        ),
                      ],
                      onChanged: (value) async {
                        controller.setClass(value.toString());
                      }),
                );
              }),
              addVerticalSpace(10),
              Text(
                "CHILD INFORMATION",
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
              Text(
                "PARENTS INFORMATION",
                style: TextStyle(
                  fontSize: large,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addVerticalSpace(10),
              customTextField(
                controller: fatherNameController,
                labelText: "Father's Name",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: fatherCNICController,
                labelText: "Father's CNIC",
                textInputType: TextInputType.number,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: motherNameController,
                labelText: "Mother's Name",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: motherCNICController,
                labelText: "Mother's CNIC",
                textInputType: TextInputType.number,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: parentAddressController,
                labelText: "Address (if different from that of child)",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: parentPhoneController,
                labelText: "Phone No.",
                textInputType: TextInputType.phone,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: occupationController,
                labelText: "Occupation",
                textInputType: TextInputType.text,
              ),
              addVerticalSpace(10),
              customTextField(
                controller: designationController,
                labelText: "Designation",
                textInputType: TextInputType.text,
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
                      classDropdownController.currentClass.value ==
                          "Select Class" ||
                      nameController.text == "" ||
                      dobController.text == "" ||
                      genderController.selectedGender.value ==
                          "Select gender" ||
                      placeOfBirthController.text == "" ||
                      religionController.text == "" ||
                      nationalityController.text == "" ||
                      addressController.text == "" ||
                      phoneController.text == "" ||
                      emergencyPhoneController.text == "" ||
                      fatherNameController.text == "" ||
                      fatherCNICController.text == "" ||
                      motherNameController.text == "" ||
                      motherCNICController.text == "" ||
                      parentPhoneController.text == "" ||
                      occupationController.text == "" ||
                      designationController.text == "") {
                    errorController.setErrorMessage("Please fill all fields");
                  } else {
                    try {
                      loadingController.setLoading(true);
                      errorController.setErrorMessage("");

                      await FirebaseFirestore.instance
                          .collection("Schools")
                          .doc(schoolEmail)
                          .collection("Student Forms")
                          .doc(regNoController.text)
                          .set({
                        "studentRegNo": regNoController.text.trim(),
                        "dateOfReg": dateOfRegController.text.trim(),
                        "class": classDropdownController.currentClass.value,
                        "studentName": nameController.text.trim(),
                        "gender": genderController.selectedGender.value,
                        "studentDob": dobController.text.trim(),
                        "placeOfBirth": placeOfBirthController.text.trim(),
                        "religion": religionController.text.trim(),
                        "nationality": nationalityController.text.trim(),
                        "address": addressController.text.trim(),
                        "phone": phoneController.text.trim(),
                        "emergencyPhone": emergencyPhoneController.text.trim(),
                        "fatherName": fatherNameController.text.trim(),
                        "fatherCNIC": fatherCNICController.text.trim(),
                        "motherName": motherNameController.text.trim(),
                        "motherCNIC": motherCNICController.text.trim(),
                        "parentAddress": (parentAddressController.text == "")
                            ? "Same as that of child"
                            : parentAddressController.text.trim(),
                        "parentPhone": parentPhoneController.text.trim(),
                        "occupation": occupationController.text.trim(),
                        "designation": designationController.text.trim(),
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
