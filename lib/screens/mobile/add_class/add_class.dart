import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import '../../../controllers/get_data_controllers.dart';
import '../../../controllers/permission_controller.dart';
import '../../../controllers/user_info_controller.dart';
import '../../../controllers/user_type_controller.dart';
import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';
import '../add_course/add_course.dart';

class AddClass extends StatelessWidget {
  AddClass({Key? key}) : super(key: key);

  final classNameController = TextEditingController();
  final classController = Get.put(GetClassesController());
  final userType = Get.find<UserTypeController>().userType.value;
  final permissionController = Get.put(ClassPermissionController());
  final loadingController = Get.put(LoadingController());
  final errorController = Get.put(ErrorController());
  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  @override
  Widget build(BuildContext context) {
    classController.getClasses();
    if (userType == "school") {
      permissionController.setPermission(true);
    } else {
      var userInfoController = Get.find<UserInfoController>();
      permissionController
          .setPermission(userInfoController.permissions['addClass']);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Classes")),
      body: Obx(
        () => ListView.builder(
          itemCount: classController.classes.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  AddCourse(
                    forClass: classController.classes[index]['name'],
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Text(
                    classController.classes[index]['name'],
                    style: TextStyle(
                      fontSize: large,
                    ),
                  ),
                  trailing: deleteButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return deleteAlert(
                            context: context,
                            content:
                                "Are your sure you want to delete ${classController.classes[index]['name']}",
                            onConfirm: () async {
                              Navigator.pop(context);
                              loadingController.setLoading(true);
                              await FirebaseFirestore.instance
                                  .collection('Schools')
                                  .doc(schoolEmail)
                                  .collection("Classes")
                                  .doc(classController.classes[index]['name'])
                                  .delete();
                              loadingController.setLoading(false);
                              classController.getClasses();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      floatingActionButton: GetX<SchoolEmailController>(builder: (controller1) {
        if (controller1.schoolEmail.value == "") {
          return Container();
        }
        return GetX<ClassPermissionController>(builder: (controller) {
          return (controller.permission.value == true)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Add Class"),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customTextField(
                                      controller: classNameController,
                                      labelText: "Class Name",
                                      textInputType: TextInputType.text,
                                    ),
                                    addVerticalSpace(10),
                                    GetX<ErrorController>(
                                        builder: (controller) {
                                      return errorText(controller);
                                    }),
                                    addButton(
                                      context: context,
                                      onPressed: () async {
                                        if (classNameController.text == "") {
                                          errorController.setErrorMessage(
                                              "Please enter class name");
                                        } else {
                                          errorController.setErrorMessage("");
                                          loadingController.setLoading(true);
                                          await FirebaseFirestore.instance
                                              .collection('Schools')
                                              .doc(
                                                  controller1.schoolEmail.value)
                                              .collection("Classes")
                                              .doc(classNameController.text
                                                  .trim())
                                              .set({
                                            "name":
                                                classNameController.text.trim()
                                          });
                                          loadingController.setLoading(false);
                                          classNameController.text = "";
                                          Navigator.pop(context);
                                          classController.getClasses();
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
                  label: const Text("Add Class"),
                )
              : Container();
        });
      }),
    );
  }
}
