import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/screens/mobile/teacher_form/teacher_form.dart';

import '../../../controllers/error_controller.dart';
import '../../../utils/helper_widgets.dart';
import '../add_book/add_book.dart';
import '../add_class/add_class.dart';
import '../add_management/add_management.dart';
import '../add_question/add_question.dart';
import '../add_student/add_student.dart';
import '../add_teacher/add_teacher.dart';
import '../curriculum/curriculum.dart';
import '../generate_exam/exam_types.dart';
import '../student_form/student_form.dart';

class SchoolHome extends StatelessWidget {
  const SchoolHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [
            customCard(
              imagePath: "assets/classes.svg",
              title: "Classes",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(AddClass());
              },
            ),
            customCard(
              imagePath: "assets/teachers.svg",
              title: "Teachers",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(AddTeacher());
              },
            ),
            customCard(
              imagePath: "assets/management.svg",
              title: "Management",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(AddManagement());
              },
            ),
            customCard(
              imagePath: "assets/students.svg",
              title: "Students",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(AddStudent());
              },
            ),
            customCard(
              imagePath: "assets/books.svg",
              title: "Books",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(AddBook());
              },
            ),
            customCard(
              imagePath: "assets/teacher_forms.svg",
              title: "Teacher Forms",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(TeacherForm());
              },
            ),
            customCard(
              imagePath: "assets/student_forms.svg",
              title: "Student Forms",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(StudentForm());
              },
            ),
            customCard(
              imagePath: "assets/questions.svg",
              title: "Add Questions",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(AddQuestion());
              },
            ),
            customCard(
              imagePath: "assets/exams.svg",
              title: "Generate Exams",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(ExamTypes());
              },
            ),
            customCard(
              imagePath: "assets/curriculum.svg",
              title: "Curriculum",
              onPressed: () {
                Get.find<ErrorController>().setErrorMessage("");
                Get.to(Curriculum());
              },
            ),
          ],
        ),
      ),
    );
  }
}
