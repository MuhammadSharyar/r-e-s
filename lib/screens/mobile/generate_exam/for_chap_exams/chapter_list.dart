import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/get_data_controllers.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_chap_exams/question_types.dart';

import '../../../../theme/theme_constants.dart';

class ChapterList extends StatelessWidget {
  final String forClass, forCourse;
  ChapterList({
    super.key,
    required this.forClass,
    required this.forCourse,
  });

  final chapterController = Get.put(GetChaptersController());

  @override
  Widget build(BuildContext context) {
    chapterController.getChapters(forClass: forClass, forCourse: forCourse);
    return Scaffold(
      appBar: AppBar(title: const Text("Select Chapter")),
      body: Obx(
        () => ListView.builder(
          itemCount: chapterController.chapters.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  QuestionTypes(
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
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
