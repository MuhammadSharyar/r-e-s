import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/dropdown_controllers.dart';
import 'package:r_e_s/controllers/get_data_controllers.dart';
import 'package:r_e_s/controllers/get_school_details.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

class Curriculum extends StatefulWidget {
  Curriculum({Key? key}) : super(key: key);

  @override
  State<Curriculum> createState() => _CurriculumState();
}

class _CurriculumState extends State<Curriculum> {
  final schoolDetailsController = Get.put(GetSchoolDetails());

  final schoolEmail = Get.put(SchoolEmailController()).schoolEmail.value;

  final termsInputController = TextEditingController();

  final getClassesController = Get.put(GetClassesController());

  final getCoursesController = Get.put(GetCoursesController());

  final getChaptersController = Get.put(GetChaptersController());

  final termDropdownController = Get.put(TermController());

  List chapterNames = [];

  List<String> currentTerm = [];

  Future updateTerms(
    BuildContext context,
    GetSchoolDetails controller,
  ) async {
    var schoolDetails = controller.schoolDetails;

    await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolEmail)
        .set({
      "keyForManagement": schoolDetails["keyForManagement"],
      "keyForStudents": schoolDetails["keyForStudents"],
      "keyForTeachers": schoolDetails["keyForTeachers"],
      "position": schoolDetails["position"],
      "schoolAddress": schoolDetails["schoolAddress"],
      "schoolLogo": schoolDetails["schoolLogo"],
      "schoolName": schoolDetails["schoolName"],
      "totalTerms": int.parse(termsInputController.text),
    });
    controller.getSchoolDetails();
    termsInputController.text = "";
  }

  Widget updateTermsAlert(BuildContext context, GetSchoolDetails controller) {
    return AlertDialog(
      content: const Text("Enter total number of terms:"),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: termsInputController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: xlarge,
                ),
              ),
            ),
            addHorizontalSpace(10),
            ElevatedButton(
              onPressed: () async {
                if (termsInputController.text != "") {
                  updateTerms(context, controller);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Confirm",
                style: TextStyle(
                  fontSize: large,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    schoolDetailsController.getSchoolDetails();
    getClassesController.getClasses();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Curriculum"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: GetX<GetSchoolDetails>(
            builder: (controller) {
              if (controller.schoolDetails == {}) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        "Total no. of terms: ${controller.schoolDetails['totalTerms']}",
                      ),
                      trailing: OutlinedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return updateTermsAlert(context, controller);
                              });
                        },
                        child: const Text("Update"),
                      ),
                    ),
                  ),
                  addVerticalSpace(10),
                  GetX<GetClassesController>(builder: (controller) {
                    if (controller.classes.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: ListView.builder(
                        itemCount: controller.classes.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  getCoursesController.getCourses(
                                      forClass: controller.classes[index]
                                          ['name']);
                                },
                                child: Card(
                                  child: ListTile(
                                    title:
                                        Text(controller.classes[index]['name']),
                                  ),
                                ),
                              ),
                              GetX<GetCoursesController>(
                                  builder: (controller1) {
                                if (controller1.courses.isNotEmpty &&
                                    controller1.className ==
                                        controller.classes[index]['name']) {
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: ListView.builder(
                                        itemCount: controller1.courses.length,
                                        itemBuilder: (context, course) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await getChaptersController
                                                      .getChapters(
                                                          forClass: controller
                                                                  .classes[
                                                              index]['name'],
                                                          forCourse: controller1
                                                                  .courses[
                                                              course]['name']);
                                                  currentTerm = [
                                                    for (int i = 0;
                                                        i <
                                                            getChaptersController
                                                                .chapters
                                                                .length;
                                                        i++) ...{
                                                      (getChaptersController
                                                                      .chapters[
                                                                  i]['term'] !=
                                                              "")
                                                          ? getChaptersController
                                                                  .chapters[i]
                                                              ['term']
                                                          : "Select Term"
                                                    }
                                                  ];
                                                },
                                                child: Card(
                                                  color: Colors.blue[200],
                                                  child: ListTile(
                                                    title: Text(
                                                      "    ${controller1.courses[course]['name']}",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GetX<GetChaptersController>(
                                                  builder: (controller2) {
                                                if (controller2
                                                        .chapters.isNotEmpty &&
                                                    controller2.className ==
                                                        controller
                                                                .classes[index]
                                                            ['name'] &&
                                                    controller2.courseName ==
                                                        controller1
                                                                .courses[course]
                                                            ['name']) {
                                                  return SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3,
                                                    child: ListView.builder(
                                                        itemCount: controller2
                                                            .chapters.length,
                                                        itemBuilder:
                                                            (context, chap) {
                                                          return GestureDetector(
                                                            onTap: () {},
                                                            child: Card(
                                                              color: Colors
                                                                  .yellow[200],
                                                              child: ListTile(
                                                                title: Text(
                                                                    "        ${controller2.chapters[chap]['name']}"),
                                                                trailing:
                                                                    DropdownButton(
                                                                  value:
                                                                      currentTerm[
                                                                          chap],
                                                                  items: [
                                                                    const DropdownMenuItem(
                                                                      value:
                                                                          "Select Term",
                                                                      child: Text(
                                                                          "Select Term"),
                                                                    ),
                                                                    for (int i =
                                                                            1;
                                                                        i <=
                                                                            schoolDetailsController.schoolDetails['totalTerms'];
                                                                        i++) ...{
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            "Term ${i.toString()}",
                                                                        child: Text(
                                                                            "Term ${i.toString()}"),
                                                                      ),
                                                                    }
                                                                  ],
                                                                  onChanged:
                                                                      (newValue) async {
                                                                    setState(
                                                                        () {
                                                                      currentTerm[
                                                                              chap] =
                                                                          newValue
                                                                              .toString();
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Schools')
                                                                        .doc(
                                                                            schoolEmail)
                                                                        .collection(
                                                                            'Classes')
                                                                        .doc(controller2
                                                                            .className)
                                                                        .collection(
                                                                            'Courses')
                                                                        .doc(controller2
                                                                            .courseName)
                                                                        .collection(
                                                                            'Chapters')
                                                                        .doc(controller2.chapters[chap]
                                                                            [
                                                                            'name'])
                                                                        .set({
                                                                      'name': controller2
                                                                              .chapters[chap]
                                                                          [
                                                                          'name'],
                                                                      'term': currentTerm[
                                                                          chap],
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  );
                                                }
                                                return Container();
                                              }),
                                            ],
                                          );
                                        }),
                                  );
                                }
                                return Container();
                              }),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
