import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import '../../../controllers/dropdown_controllers.dart';
import '../../../controllers/image_controller.dart';
import '../../../controllers/loading_controller.dart';
import '../../../controllers/user_type_controller.dart';
import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';

// ignore: must_be_immutable
class QuestionCard extends StatelessWidget {
  QuestionCard({Key? key}) : super(key: key);
  ImagePicker imagePicker = ImagePicker();

  final classController = Get.put(ClassController());
  final courseController = Get.put(CourseController());
  final chapterController = Get.put(ChapterController());
  final questionTypeController = Get.put(QuestionTypeController());
  final difficultyController = Get.put(DifficultyController());
  final imageController = Get.put(ImageController());
  final errorController = Get.put(ErrorController());
  final loadingController = Get.put(LoadingController());

  final marksController = TextEditingController();
  final questionTextController = TextEditingController();
  final imageNameController = TextEditingController();
  final option1Controller = TextEditingController(text: "");
  final option2Controller = TextEditingController(text: "");
  final option3Controller = TextEditingController(text: "");
  final option4Controller = TextEditingController(text: "");

  List difficulty = ['Easy', 'Medium', 'Hard'];
  List questionTypes = [
    "Short",
    "Long",
    "Fill in the Blanks",
    "MCQ",
    "True False",
    "Essay",
    "Letter",
    "Story",
    "Word Meanings"
  ];

  final userType = Get.find<UserTypeController>().userType.value;
  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  @override
  Widget build(BuildContext context) {
    classController.getClasses();
    return WillPopScope(
      onWillPop: () async {
        loadingController.setLoading(false);
        return true;
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
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
                              courseController.currentCourse.value =
                                  "Select Course";
                              chapterController.currentChapter.value =
                                  "Select Chapter";
                              await courseController.getCourses(
                                forClass: classController.currentClass.value,
                              );
                              // courseController.setCourseList(courseList);
                            }),
                      );
                    }),
                    const SizedBox(width: 7),
                    GetX<CourseController>(builder: (controller) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: controller.currentCourse.value,
                            items: [
                              const DropdownMenuItem(
                                value: "Select Course",
                                child: Text("Select Course"),
                              ),
                              ...controller.courseList.map(
                                (c) => DropdownMenuItem(
                                  value: c['name'],
                                  child: Text(c['name']),
                                ),
                              ),
                            ],
                            onChanged: (value) async {
                              controller.setCourse(value.toString());
                              chapterController.currentChapter.value =
                                  "Select Chapter";
                              await chapterController.getChapters(
                                forClass: classController.currentClass.value,
                                forCourse: courseController.currentCourse.value,
                              );
                              // chapterController.setChapterList(chapterList);
                            }),
                      );
                    }),
                    const SizedBox(width: 7),
                    GetX<ChapterController>(builder: (controller) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: controller.currentChapter.value,
                            items: [
                              const DropdownMenuItem(
                                value: "Select Chapter",
                                child: Text("Select Chapter"),
                              ),
                              ...controller.chapterList.map(
                                (c) => DropdownMenuItem(
                                  value: c['name'],
                                  child: Text(c['name']),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              controller.setChapter(value.toString());
                            }),
                      );
                    }),
                  ],
                ),
              ),
              addVerticalSpace(10),
              Row(
                children: [
                  GetX<QuestionTypeController>(builder: (controller) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: controller.currentQuestionType.value,
                          items: [
                            const DropdownMenuItem(
                              value: "Select Question Type",
                              child: Text("Select Question Type"),
                            ),
                            ...questionTypes.map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            controller.setQuestionType(value.toString());
                          }),
                    );
                  }),
                  const SizedBox(width: 5),
                  Expanded(
                    child: customTextField(
                      controller: marksController,
                      labelText: "Marks",
                      textInputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              addVerticalSpace(10),
              SizedBox(
                child: customTextField(
                  controller: questionTextController,
                  labelText: "Enter Question",
                  textInputType: TextInputType.text,
                ),
              ),
              GetX<QuestionTypeController>(builder: (controller) {
                if (controller.currentQuestionType.value == "MCQ") {
                  return Column(
                    children: [
                      addVerticalSpace(10),
                      customTextField(
                        controller: option1Controller,
                        labelText: "Option 1",
                        textInputType: TextInputType.text,
                      ),
                      addVerticalSpace(10),
                      customTextField(
                        controller: option2Controller,
                        labelText: "Option 2",
                        textInputType: TextInputType.text,
                      ),
                      addVerticalSpace(10),
                      customTextField(
                        controller: option3Controller,
                        labelText: "Option 3",
                        textInputType: TextInputType.text,
                      ),
                      addVerticalSpace(10),
                      customTextField(
                        controller: option4Controller,
                        labelText: "Option 4",
                        textInputType: TextInputType.text,
                      ),
                    ],
                  );
                }
                return Container();
              }),
              addVerticalSpace(10),
              Align(
                alignment: Alignment.centerLeft,
                child: GetX<DifficultyController>(builder: (controller) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: controller.currentDifficulty.value,
                        items: [
                          const DropdownMenuItem(
                            value: "Select Difficulty",
                            child: Text("Select Difficulty"),
                          ),
                          ...difficulty.map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          controller.setDifficulty(value.toString());
                        }),
                  );
                }),
              ),
              addVerticalSpace(10),
              Row(
                children: [
                  Expanded(
                    child: customTextField(
                      controller: imageNameController,
                      labelText: "Image name",
                      textInputType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        var pickedImage = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedImage != null) {
                          imageController.setPickedImage(pickedImage.path);
                        }
                      },
                      child: GetX<ImageController>(builder: (controller) {
                        return (controller.pickedImage.value != '')
                            ? SizedBox(
                                height: 90,
                                child: Image.file(
                                  File(controller.pickedImage.value),
                                ),
                              )
                            : const Icon(
                                Icons.image,
                                size: 27,
                              );
                      }),
                    ),
                  )
                ],
              ),
              addVerticalSpace(10),
              GetX<ErrorController>(builder: (controller) {
                return errorText(controller);
              }),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: GetX<LoadingController>(builder: (controller) {
                  return ElevatedButton(
                    style: (controller.loading.value)
                        ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          )
                        : null,
                    onPressed: () async {
                      if (controller.loading.value == false) {
                        if (classController.currentClass.value ==
                            "Select Class") {
                          errorController
                              .setErrorMessage("Please select a class");
                        } else if (courseController.currentCourse.value ==
                            "Select Course") {
                          errorController
                              .setErrorMessage("Please select a course");
                        } else if (chapterController.currentChapter.value ==
                            "Select Chapter") {
                          errorController
                              .setErrorMessage("Please select a chapter");
                        } else if (questionTypeController
                                .currentQuestionType.value ==
                            "Select Question Type") {
                          errorController
                              .setErrorMessage("Please select a question type");
                        } else if (marksController.text.isEmpty) {
                          errorController
                              .setErrorMessage("Please put question marks");
                        } else if (questionTextController.text.isEmpty) {
                          errorController
                              .setErrorMessage("Please write a question");
                        } else if (difficultyController
                                .currentDifficulty.value ==
                            "Select Difficulty") {
                          errorController.setErrorMessage(
                              "Please select question difficulty");
                        } else if (imageNameController.text.isEmpty &&
                            imageController.pickedImage.value != "") {
                          errorController
                              .setErrorMessage("Please write the image name");
                        } else if (imageNameController.text.isNotEmpty &&
                            imageController.pickedImage.value == "") {
                          errorController
                              .setErrorMessage("Please pick an image");
                        } else {
                          errorController.setErrorMessage("");
                          controller.setLoading(true);
                          String imageDownloadLink = "";
                          if (imageNameController.text.isNotEmpty &&
                              imageController.pickedImage.value != "") {
                            await FirebaseStorage.instance
                                .ref()
                                .child(
                                    "Question Images/$schoolEmail/${FirebaseAuth.instance.currentUser!.email}/${imageNameController.text.trim()}")
                                .putFile(
                                    File(imageController.pickedImage.value))
                                .whenComplete(() async {
                              await FirebaseStorage.instance
                                  .ref()
                                  .child(
                                      "Question Images/$schoolEmail/${FirebaseAuth.instance.currentUser!.email}/${imageNameController.text.trim()}")
                                  .getDownloadURL()
                                  .then((value) => imageDownloadLink = value);
                            });
                          }
                          if (questionTypeController
                                  .currentQuestionType.value ==
                              "MCQ") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("MCQ Questions")
                                .doc();

                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Mcqs")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                                "option1": option1Controller.text.trim(),
                                "option2": option2Controller.text.trim(),
                                "option3": option3Controller.text.trim(),
                                "option4": option4Controller.text.trim(),
                              },
                            );

                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                                "option1": option1Controller.text.trim(),
                                "option2": option2Controller.text.trim(),
                                "option3": option3Controller.text.trim(),
                                "option4": option4Controller.text.trim(),
                              },
                            );

                            option1Controller.text = "";
                            option2Controller.text = "";
                            option3Controller.text = "";
                            option4Controller.text = "";
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Short") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Short Questions")
                                .doc();
                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Short Questions")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );

                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Long") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Long Questions")
                                .doc();

                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Long Questions")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Fill in the Blanks") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Fill in the Blanks")
                                .doc();
                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Fill in the Blanks")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "True False") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("True False")
                                .doc();
                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All True False")
                                .doc();
                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Essay") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Essays")
                                .doc();
                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Essays")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Letter") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Letters")
                                .doc();

                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Letters")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Story") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Stories")
                                .doc();

                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Stories")
                                .doc();

                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          } else if (questionTypeController
                                  .currentQuestionType.value ==
                              "Word Meanings") {
                            var savingLocation1 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("Chapters")
                                .doc(chapterController.currentChapter.value)
                                .collection("Word Meanings")
                                .doc();

                            var savingLocation2 = FirebaseFirestore.instance
                                .collection("Schools")
                                .doc(schoolEmail)
                                .collection("Classes")
                                .doc(classController.currentClass.value)
                                .collection("Courses")
                                .doc(courseController.currentCourse.value)
                                .collection("All Word Meanings")
                                .doc();
                            await savingLocation1.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                            await savingLocation2.set(
                              {
                                "type": questionTypeController
                                    .currentQuestionType.value,
                                "marks": marksController.text.trim(),
                                "question": questionTextController.text.trim(),
                                "difficulty": difficultyController
                                    .currentDifficulty.value,
                                "chapter":
                                    chapterController.currentChapter.value,
                                "imageLink": imageDownloadLink,
                              },
                            );
                          }
                          Get.snackbar(
                            "",
                            "",
                            messageText: Text(
                              "Question has been added successfully",
                              style: TextStyle(
                                fontSize: medium,
                                color: Colors.green[800],
                              ),
                            ),
                          );
                          questionTextController.text = "";
                          imageNameController.text = "";
                          imageController.pickedImage.value = "";
                          controller.setLoading(false);
                        }
                      }
                    },
                    child: (controller.loading.value == true)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Add Question",
                            style: TextStyle(
                              fontSize: medium,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
