import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/loading_controller.dart';
import '../../../controllers/question_list_controller.dart';
import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';

class QuestionList extends StatelessWidget {
  final String schoolEmail, forClass, forCourse, forChapter;
  QuestionList({
    Key? key,
    required this.schoolEmail,
    required this.forClass,
    required this.forCourse,
    required this.forChapter,
  }) : super(key: key);

  final loadingController = Get.put(LoadingController());
  List mcqList = [];
  List shortList = [];
  List longList = [];
  List blanks = [];
  List trueFalse = [];
  List letterList = [];
  List essayList = [];
  List storyList = [];
  List meaningList = [];

  Future getQuestions() async {
    loadingController.setLoading(true);
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    var firestore = FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(forClass)
        .collection("Courses")
        .doc(forCourse)
        .collection("Chapters")
        .doc(forChapter);

    await firestore.collection("Short Questions").get().then(
          (value) => shortList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("MCQ Questions").get().then(
          (value) => mcqList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("Long Questions").get().then(
          (value) => longList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("Fill in the Blanks").get().then(
          (value) => blanks.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("True False").get().then(
          (value) => trueFalse.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("Essays").get().then(
          (value) => essayList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("Letters").get().then(
          (value) => letterList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("Stories").get().then(
          (value) => storyList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    await firestore.collection("Word Meanings").get().then(
          (value) => meaningList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
    loadingController.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    getQuestions();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questions"),
        leading: IconButton(
          onPressed: () {
            Get.back();
            loadingController.setLoading(false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GetX<LoadingController>(
        builder: (controller) {
          if (loadingController.loading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MCQs",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < mcqList[0].length; i++) ...{
                    questionCard(
                      list: mcqList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Short Questions",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < shortList[0].length; i++) ...{
                    questionCard(
                      list: shortList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Long Questions",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < longList[0].length; i++) ...{
                    questionCard(
                      list: longList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Fill in the blanks",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < blanks[0].length; i++) ...{
                    questionCard(
                      list: blanks,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "True False",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < trueFalse[0].length; i++) ...{
                    questionCard(
                      list: trueFalse,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Essays",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < essayList[0].length; i++) ...{
                    questionCard(
                      list: essayList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Letters",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < letterList[0].length; i++) ...{
                    questionCard(
                      list: letterList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Stories",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < storyList[0].length; i++) ...{
                    questionCard(
                      list: storyList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                  Text(
                    "Word Meanings",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (int i = 0; i < meaningList[0].length; i++) ...{
                    questionCard(
                      list: meaningList,
                      item: i,
                      onPressed: () {},
                    ),
                  },
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
