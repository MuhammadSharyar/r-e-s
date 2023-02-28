import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_e_s/controllers/checkbox_controllers.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_book_exams/generate_exam.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

class QuestionTypes extends StatelessWidget {
  final String forClass, forCourse;
  QuestionTypes({
    Key? key,
    required this.forClass,
    required this.forCourse,
  }) : super(key: key);

  final mcqController = Get.put(AddMCQController());
  final shortController = Get.put(AddShortController());
  final longController = Get.put(AddLongController());
  final blanksController = Get.put(AddBlanksController());
  final trueFalseController = Get.put(AddTrueFalseController());
  final letterController = Get.put(AddLetterController());
  final essayController = Get.put(AddEssayController());
  final storyController = Get.put(AddStoryController());
  final meaningController = Get.put(AddMeaningController());
  final loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Question Types")),
      body: WillPopScope(
        onWillPop: () async {
          final cacheDir = await getTemporaryDirectory();
          Directory(cacheDir.path).delete(recursive: true);
          return true;
        },
        child: SingleChildScrollView(
          child: Obx(
            () {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    customCheckBox(
                      title: "MCQs",
                      value: mcqController.addMCQ.value,
                      onChange: (newValue) {
                        mcqController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Short Questions",
                      value: shortController.addShort.value,
                      onChange: (newValue) {
                        shortController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Long Questions",
                      value: longController.addLong.value,
                      onChange: (newValue) {
                        longController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Fill in the blanks",
                      value: blanksController.addBlanks.value,
                      onChange: (newValue) {
                        blanksController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "True False",
                      value: trueFalseController.addTrueFalse.value,
                      onChange: (newValue) {
                        trueFalseController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Letters",
                      value: letterController.addLetters.value,
                      onChange: (newValue) {
                        letterController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Essays",
                      value: essayController.addEssay.value,
                      onChange: (newValue) {
                        essayController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Stories",
                      value: storyController.addStory.value,
                      onChange: (newValue) {
                        storyController.setCheck(newValue);
                      },
                    ),
                    customCheckBox(
                      title: "Word Meanings",
                      value: meaningController.addMeaning.value,
                      onChange: (newValue) {
                        meaningController.setCheck(newValue);
                      },
                    ),
                    addVerticalSpace(20),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          List questionTypes = [];
                          if (mcqController.addMCQ.value) {
                            questionTypes.add("All Mcqs");
                          }
                          if (shortController.addShort.value) {
                            questionTypes.add("All Short Questions");
                          }
                          if (longController.addLong.value) {
                            questionTypes.add("All Long Questions");
                          }
                          if (blanksController.addBlanks.value) {
                            questionTypes.add("All Fill in the Blanks");
                          }
                          if (trueFalseController.addTrueFalse.value) {
                            questionTypes.add("All True False");
                          }
                          if (letterController.addLetters.value) {
                            questionTypes.add("All Letters");
                          }
                          if (essayController.addEssay.value) {
                            questionTypes.add("All Essays");
                          }
                          if (storyController.addStory.value) {
                            questionTypes.add("All Stories");
                          }
                          if (meaningController.addMeaning.value) {
                            questionTypes.add("All Word Meanings");
                          }
                          Get.to(
                            GenerateExam(
                              questionTypes: questionTypes,
                              forClass: forClass,
                              forCourse: forCourse,
                            ),
                          );
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(fontSize: large),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
