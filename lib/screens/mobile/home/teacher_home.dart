import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/screens/mobile/teacher_form/teacher_form.dart';
import '../../../controllers/error_controller.dart';
import '../../../controllers/user_info_controller.dart';
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

class TeacherHome extends StatefulWidget {
  TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final userInfoController = Get.put(UserInfoController());

  List cards = [];
  var _getCards;

  Future getCards() async {
    await userInfoController.getInfo();
    userInfoController.permissions.value =
        await userInfoController.userDetails['permissions'];
    print("USER PERMISSIONS: ${userInfoController.userDetails['permissions']}");
    if (userInfoController.permissions['addClass'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/classes.svg",
          title: "Classes",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(AddClass());
          },
        ),
      );
    }
    if (userInfoController.permissions['addTeacher'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/teachers.svg",
          title: "Teachers",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(AddTeacher());
          },
        ),
      );
    }
    if (userInfoController.permissions['addManagement'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/management.svg",
          title: "Management",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(AddManagement());
          },
        ),
      );
    }
    if (userInfoController.permissions['addStudent'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/students.svg",
          title: "Students",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(AddStudent());
          },
        ),
      );
    }
    if (userInfoController.permissions['addBook'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/books.svg",
          title: "Books",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(AddBook());
          },
        ),
      );
    }
    if (userInfoController.permissions['addTeacherForm'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/teacher_forms.svg",
          title: "Teacher Forms",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(TeacherForm());
          },
        ),
      );
    }
    if (userInfoController.permissions['addStudentForm'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/student_forms.svg",
          title: "Student Forms",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(StudentForm());
          },
        ),
      );
    }
    if (userInfoController.permissions['addQuestion'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/questions.svg",
          title: "Add Questions",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(AddQuestion());
          },
        ),
      );
    }
    if (userInfoController.permissions['createPaper'] == true) {
      cards.add(
        customCard(
          imagePath: "assets/exams.svg",
          title: "Generate Exams",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(ExamTypes());
          },
        ),
      );
    }
    if (userInfoController.permissions['setCurriculum']) {
      cards.add(
        customCard(
          imagePath: "assets/curriculum.svg",
          title: "Curriculum",
          onPressed: () {
            Get.find<ErrorController>().setErrorMessage("");
            Get.to(Curriculum());
          },
        ),
      );
    }
  }

  @override
  void initState() {
    _getCards = getCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _getCards,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.count(
                crossAxisCount: 2,
                children: [
                  ...cards.map((card) => card),
                ],
              );
            }),
      ),
    );
  }
}
