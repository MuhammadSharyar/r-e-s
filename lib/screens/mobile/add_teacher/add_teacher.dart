import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/firebase_options.dart';
import '../../../controllers/dropdown_controllers.dart';
import '../../../controllers/get_users_controllers.dart';
import '../../../controllers/user_type_controller.dart';
import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';
import '../user_details/teacher_details.dart';

class AddTeacher extends StatelessWidget {
  AddTeacher({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final teacherController = Get.put(GetTeacherController());
  final genderController = Get.put(GenderController());
  final userType = Get.find<UserTypeController>().userType.value;
  final errorController = Get.put(ErrorController());
  final loadingController = Get.put(LoadingController());
  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  Future addTeacher() async {
    if (nameController.text == "" ||
        emailController.text == "" ||
        passController.text == "" ||
        phoneController.text == "" ||
        addressController.text == "" ||
        genderController.selectedGender.value == "Select gender") {
      errorController.setErrorMessage("Please fill all fields");
    } else {
      errorController.setErrorMessage("");
      try {
        loadingController.setLoading(true);
        var temporaryApp = await Firebase.initializeApp(
          name: "TemporaryApp",
          options: DefaultFirebaseOptions.currentPlatform,
        );

        await FirebaseAuth.instanceFor(app: temporaryApp)
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim(),
        );

        await FirebaseAuth.instanceFor(app: temporaryApp).signOut();

        await FirebaseFirestore.instance
            .collection('Teachers')
            .doc(emailController.text.trim())
            .set(
          {
            "position": "teacher",
            "school_email": schoolEmail,
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "password": passController.text.trim(),
            "phone": phoneController.text.trim(),
            "address": addressController.text.trim(),
            "gender": genderController.selectedGender.value,
            "permissions": {
              "addClass": false,
              "addTeacher": false,
              "addManagement": false,
              "addStudent": false,
              "addCourse": false,
              "addQuestion": false,
              "addTeacherForm": false,
              "addStudentForm": false,
              "addBook": false,
              "addPaperPattern": false,
              "createPaper": false,
              "setCurriculum": false,
            },
          },
        );

        nameController.text = "";
        emailController.text = "";
        passController.text = "";
        phoneController.text = "";
        addressController.text = "";
        genderController.setGender("Select gender");
        loadingController.setLoading(false);
        return "Request Successful";
      } catch (e) {
        loadingController.setLoading(false);
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    teacherController.getTeachers();
    return Scaffold(
      appBar: AppBar(title: const Text("Teachers")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Obx(
          () => ListView.builder(
            itemCount: teacherController.allTeachers.length,
            itemBuilder: ((context, index) {
              return GetX<LoadingController>(builder: (controller) {
                return userCard(
                  context: context,
                  controller: controller,
                  name: teacherController.allTeachers[index]['name'],
                  email: teacherController.allTeachers[index]['email'],
                  onPressed: () async {
                    var teacher = await teacherController.allTeachers[index];
                    Get.to(
                      TeacherDetails(
                        name: teacher['name'],
                        email: teacher['email'],
                        contact: teacher['phone'],
                        address: teacher['address'],
                        gender: teacher['gender'],
                        permissions: teacher['permissions'],
                      ),
                    );
                  },
                  onDelete: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return deleteAlert(
                            context: context,
                            content:
                                "Are you sure you want to delete ${teacherController.allTeachers[index]['email']}?",
                            onConfirm: () async {
                              Navigator.pop(context);
                              loadingController.setLoading(true);
                              var temporaryApp = await Firebase.initializeApp(
                                name: "TemporaryApp",
                                options: DefaultFirebaseOptions.currentPlatform,
                              );
                              await FirebaseFirestore.instanceFor(
                                      app: temporaryApp)
                                  .collection('Teachers')
                                  .doc(teacherController.allTeachers[index]
                                      ['email'])
                                  .delete();
                              await FirebaseAuth.instanceFor(app: temporaryApp)
                                  .signInWithEmailAndPassword(
                                email: teacherController.allTeachers[index]
                                    ['email'],
                                password: teacherController.allTeachers[index]
                                    ['password'],
                              );
                              await FirebaseAuth.instanceFor(app: temporaryApp)
                                  .currentUser!
                                  .delete();
                              loadingController.setLoading(false);
                              await teacherController.getTeachers();
                            },
                          );
                        });
                  },
                );
              });
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Teacher"),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customTextField(
                            controller: nameController,
                            labelText: "Teacher's Name",
                            textInputType: TextInputType.text,
                          ),
                          addVerticalSpace(10),
                          customTextField(
                            controller: emailController,
                            labelText: "Teacher's Email",
                            textInputType: TextInputType.text,
                          ),
                          addVerticalSpace(10),
                          customTextField(
                            controller: passController,
                            labelText: "Teacher's Password",
                            textInputType: TextInputType.text,
                          ),
                          addVerticalSpace(10),
                          customTextField(
                            controller: phoneController,
                            labelText: "Teacher's Contact",
                            textInputType: TextInputType.phone,
                          ),
                          addVerticalSpace(10),
                          customTextField(
                            controller: addressController,
                            labelText: "Teacher's Address",
                            textInputType: TextInputType.streetAddress,
                          ),
                          addVerticalSpace(10),
                          GetX<GenderController>(
                            builder: (controller) {
                              return genderDropdown(controller: controller);
                            },
                          ),
                          addVerticalSpace(10),
                          GetX<ErrorController>(builder: (controller) {
                            return errorText(controller);
                          }),
                          addButton(
                            context: context,
                            onPressed: () async {
                              await addTeacher();
                              if (errorController.errorMessage.value == "") {
                                Navigator.pop(context);
                                teacherController.getTeachers();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        label: const Text("Add Teacher"),
      ),
    );
  }
}
