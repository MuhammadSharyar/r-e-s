import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/get_data_controllers.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_book_exams/question_choices.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_book_exams/question_types.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_term_exams/select_term.dart';

import '../../../../theme/theme_constants.dart';

class CourseList extends StatelessWidget {
  final String forClass;
  CourseList({super.key, required this.forClass});

  final courseController = Get.put(GetCoursesController());
  final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  @override
  Widget build(BuildContext context) {
    courseController.getCourses(forClass: forClass);
    return Scaffold(
      appBar: AppBar(title: const Text("Select Course")),
      body: Obx(
        () => ListView.builder(
          itemCount: courseController.courses.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  SelectTerm(
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
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
