import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/get_data_controllers.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_chap_exams/course_list.dart';

import '../../../../theme/theme_constants.dart';

class ClassList extends StatelessWidget {
  ClassList({super.key});

  final classController = Get.put(GetClassesController());
  final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;

  @override
  Widget build(BuildContext context) {
    classController.getClasses();
    return Scaffold(
      appBar: AppBar(title: const Text("Select Class")),
      body: Obx(
        () => ListView.builder(
          itemCount: classController.classes.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  CourseList(
                    forClass: classController.classes[index]['name'],
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Text(
                    classController.classes[index]['name'],
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
