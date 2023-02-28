import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/get_school_details.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_term_exams/question_types.dart';

class SelectTerm extends StatelessWidget {
  final String forClass, forCourse;
  SelectTerm({
    Key? key,
    required this.forClass,
    required this.forCourse,
  }) : super(key: key);

  final schoolDetailsController = Get.put(GetSchoolDetails());

  @override
  Widget build(BuildContext context) {
    schoolDetailsController.getSchoolDetails();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Term"),
      ),
      body: Center(
        child: GetX<GetSchoolDetails>(
          builder: (controller) {
            if (controller.schoolDetails.isEmpty) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0;
                      i < controller.schoolDetails['totalTerms'];
                      i++) ...{
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(
                            QuestionTypes(
                              forClass: forClass,
                              forCourse: forCourse,
                              forTerm: "Term ${i + 1}",
                            ),
                          );
                        },
                        child: Text(
                          "Term ${i + 1}",
                          style: TextStyle(
                            fontSize: medium,
                          ),
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                  }
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
