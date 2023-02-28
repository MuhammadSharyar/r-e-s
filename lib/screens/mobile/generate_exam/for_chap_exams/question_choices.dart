import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/checkbox_controllers.dart';
import 'package:r_e_s/utils/helper_widgets.dart';

class QuestionChoices extends StatelessWidget {
  QuestionChoices({Key? key}) : super(key: key);

  final mcqController = Get.put(AddMCQController());
  final shortController = Get.put(AddShortController());
  final longController = Get.put(AddLongController());
  final blanksController = Get.put(AddBlanksController());
  final trueFalseController = Get.put(AddTrueFalseController());
  final letterController = Get.put(AddLetterController());
  final essayController = Get.put(AddEssayController());
  final storyController = Get.put(AddStoryController());
  final meaningController = Get.put(AddMeaningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chapter Wise")),
      body: SingleChildScrollView(
        child: Obx(() {
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
              ],
            ),
          );
        }),
      ),
    );
  }
}
