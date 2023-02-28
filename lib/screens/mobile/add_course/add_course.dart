import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/loading_controller.dart';

import '../../../controllers/error_controller.dart';
import '../../../controllers/get_data_controllers.dart';
import '../../../controllers/permission_controller.dart';
import '../../../controllers/school_email_controller.dart';
import '../../../controllers/user_info_controller.dart';
import '../../../controllers/user_type_controller.dart';
import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';
import '../add_chapter/add_chapter.dart';

class AddCourse extends StatelessWidget {
  final String forClass;
  AddCourse({Key? key, required this.forClass}) : super(key: key);

  final courseController = Get.put(GetCoursesController());
  final courseNameController = TextEditingController();
  final userType = Get.find<UserTypeController>().userType.value;
  final permissionController = Get.put(CoursePermissionController());
  final loadingController = Get.put(LoadingController());
  final errorController = Get.put(ErrorController());
  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  @override
  Widget build(BuildContext context) {
    courseController.getCourses(forClass: forClass);
    if (userType == "school") {
      permissionController.setPermission(true);
    } else {
      var userInfoController = Get.find<UserInfoController>();
      permissionController
          .setPermission(userInfoController.permissions['addCourse']);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: Obx(
        () => ListView.builder(
          itemCount: courseController.courses.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  AddChapter(
                    forClass: forClass,
                    forCourse: courseController.courses[index]['name'],
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Text(
                    courseController.courses[index]['name'],
                    style: TextStyle(
                      fontSize: large,
                    ),
                  ),
                  trailing: deleteButton(onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return deleteAlert(
                            context: context,
                            content:
                                "Are your sure you want to delete ${courseController.courses[index]['name']}",
                            onConfirm: () async {
                              Navigator.pop(context);
                              loadingController.setLoading(true);
                              await FirebaseFirestore.instance
                                  .collection('Schools')
                                  .doc(schoolEmail)
                                  .collection("Classes")
                                  .doc(forClass)
                                  .collection("Courses")
                                  .doc(courseController.courses[index]['name'])
                                  .delete();
                              loadingController.setLoading(false);
                              courseController.getCourses(forClass: forClass);
                            },
                          );
                        });
                  }),
                ),
              ),
            );
          }),
        ),
      ),
      floatingActionButton:
          GetX<CoursePermissionController>(builder: (controller) {
        return (controller.permission.value == true)
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add Course"),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customTextField(
                                    controller: courseNameController,
                                    labelText: "Course Name",
                                    textInputType: TextInputType.text,
                                  ),
                                  addVerticalSpace(10),
                                  GetX<ErrorController>(builder: (controller) {
                                    return errorText(controller);
                                  }),
                                  addButton(
                                    context: context,
                                    onPressed: () async {
                                      if (courseNameController.text == "") {
                                        errorController.setErrorMessage(
                                            "Please enter course name");
                                      } else {
                                        errorController.setErrorMessage("");
                                        loadingController.setLoading(true);
                                        await FirebaseFirestore.instance
                                            .collection('Schools')
                                            .doc(schoolEmail)
                                            .collection('Classes')
                                            .doc(forClass)
                                            .collection("Courses")
                                            .doc(courseNameController.text
                                                .trim())
                                            .set({
                                          "name":
                                              courseNameController.text.trim()
                                        });
                                        loadingController.setLoading(false);
                                        courseNameController.text = "";
                                        Navigator.pop(context);
                                        courseController.getCourses(
                                            forClass: forClass);
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
                label: const Text("Add Course"),
              )
            : Container();
      }),
    );
  }
}
