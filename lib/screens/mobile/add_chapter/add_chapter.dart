import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

import '../../../controllers/get_data_controllers.dart';
import '../../../controllers/permission_controller.dart';
import '../../../controllers/school_email_controller.dart';
import '../../../controllers/user_info_controller.dart';
import '../../../controllers/user_type_controller.dart';
import '../../../theme/theme_constants.dart';
import '../question_list/question_list.dart';

class AddChapter extends StatelessWidget {
  final String forClass, forCourse;
  AddChapter({
    Key? key,
    required this.forClass,
    required this.forCourse,
  }) : super(key: key);

  final chapterNameController = TextEditingController();
  final chapterController = Get.put(GetChaptersController());
  final permissionController = Get.put(ChapterPermissionController());
  final loadingController = Get.put(LoadingController());
  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
  final userType = Get.find<UserTypeController>().userType.value;

  @override
  Widget build(BuildContext context) {
    chapterController.getChapters(
      forClass: forClass,
      forCourse: forCourse,
    );
    if (userType == "school") {
      permissionController.setPermission(true);
    } else {
      var userInfoController = Get.find<UserInfoController>();
      permissionController
          .setPermission(userInfoController.permissions['addCourse']);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Chapters")),
      body: Obx(
        () => ListView.builder(
          itemCount: chapterController.chapters.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  QuestionList(
                    forClass: forClass,
                    forCourse: forCourse,
                    forChapter: chapterController.chapters[index]['name'],
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Text(
                    chapterController.chapters[index]['name'],
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
                                "Are you sure you want to delete ${chapterController.chapters[index]['name']}",
                            onConfirm: () async {
                              Navigator.pop(context);
                              loadingController.setLoading(true);
                              await FirebaseFirestore.instance
                                  .collection("Schools")
                                  .doc(schoolEmail)
                                  .collection('Classes')
                                  .doc(forClass)
                                  .collection('Courses')
                                  .doc(forCourse)
                                  .collection('Chapters')
                                  .doc(
                                      chapterController.chapters[index]['name'])
                                  .delete();
                              loadingController.setLoading(false);
                              chapterController.getChapters(
                                forClass: forClass,
                                forCourse: forCourse,
                              );
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
          GetX<ChapterPermissionController>(builder: (controller) {
        return (controller.permission.value == true)
            ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add Chapter"),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customTextField(
                                    controller: chapterNameController,
                                    labelText: "Chapter Name",
                                    textInputType: TextInputType.text,
                                  ),
                                  addVerticalSpace(10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Schools')
                                            .doc(schoolEmail)
                                            .collection('Classes')
                                            .doc(forClass)
                                            .collection("Courses")
                                            .doc(forCourse)
                                            .collection("Chapters")
                                            .doc(chapterNameController.text
                                                .trim())
                                            .set({
                                          "name":
                                              chapterNameController.text.trim(),
                                          "term": "",
                                        });
                                        chapterNameController.text = "";
                                        Navigator.pop(context);
                                        chapterController.getChapters(
                                          forClass: forClass,
                                          forCourse: forCourse,
                                        );
                                      },
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                          fontSize: medium,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                label: const Text("Add Chapter"),
              )
            : Container();
      }),
    );
  }
}
