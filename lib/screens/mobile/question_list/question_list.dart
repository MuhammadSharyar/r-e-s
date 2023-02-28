import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/utils/helper_widgets.dart';
import '../../../controllers/school_email_controller.dart';

class QuestionList extends StatefulWidget {
  final String forClass, forCourse, forChapter;
  const QuestionList({
    super.key,
    required this.forClass,
    required this.forCourse,
    required this.forChapter,
  });

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List mcqList = [];
  List shortList = [];
  List longList = [];
  List blanks = [];
  List trueFalse = [];
  List letterList = [];
  List essayList = [];
  List storyList = [];
  List meaningList = [];

  String schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  Future getMCQs() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("MCQ Questions")
        .get()
        .then(
          (value) => mcqList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getShortQuestions() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Short Questions")
        .get()
        .then(
          (value) => shortList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getLongQuestions() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Long Questions")
        .get()
        .then(
          (value) => longList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getBlanks() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Fill in the Blanks")
        .get()
        .then(
          (value) => blanks.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getTrueFalse() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("True False")
        .get()
        .then(
          (value) => trueFalse.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getEssays() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Essays")
        .get()
        .then(
          (value) => essayList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getLetters() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Letters")
        .get()
        .then(
          (value) => letterList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getStories() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Stories")
        .get()
        .then(
          (value) => storyList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  Future getWordMeanings() async {
    mcqList = [];
    shortList = [];
    longList = [];
    blanks = [];
    trueFalse = [];
    letterList = [];
    essayList = [];
    storyList = [];
    meaningList = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Classes")
        .doc(widget.forClass)
        .collection("Courses")
        .doc(widget.forCourse)
        .collection("Chapters")
        .doc(widget.forChapter)
        .collection("Word Meanings")
        .get()
        .then(
          (value) => meaningList.add(
            value.docs
                .map(
                  (doc) => doc.data(),
                )
                .toList(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Question List")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: Column(
            children: [
              questionButton(
                context: context,
                title: "MCQs",
                onPressed: () async {
                  await getMCQs();
                  setState(() {});
                },
              ),
              (mcqList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: mcqList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title: Text("${mcqList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Short Q's",
                onPressed: () async {
                  await getShortQuestions();
                  setState(() {});
                },
              ),
              (shortList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: shortList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${shortList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Long Q's",
                onPressed: () async {
                  await getLongQuestions();
                  setState(() {});
                },
              ),
              (longList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: longList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${longList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Fill in the blanks",
                onPressed: () async {
                  await getBlanks();
                  setState(() {});
                },
              ),
              (blanks.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: blanks[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title: Text("${blanks[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "True False",
                onPressed: () async {
                  await getTrueFalse();
                  setState(() {});
                },
              ),
              (trueFalse.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: trueFalse[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${trueFalse[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Letters",
                onPressed: () async {
                  await getLetters();
                  setState(() {});
                },
              ),
              (letterList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: letterList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${letterList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Essays",
                onPressed: () async {
                  await getEssays();
                  setState(() {});
                },
              ),
              (essayList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: essayList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${essayList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Stories",
                onPressed: () async {
                  await getStories();
                  setState(() {});
                },
              ),
              (storyList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: storyList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title:
                                    Text("${storyList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
              addVerticalSpace(10),
              questionButton(
                context: context,
                title: "Word Meanings",
                onPressed: () async {
                  await getWordMeanings();
                  setState(() {});
                },
              ),
              (meaningList.isNotEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          itemCount: meaningList[0].length,
                          itemBuilder: ((context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                    "${meaningList[0][index]['question']}"),
                              ),
                            );
                          })),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
