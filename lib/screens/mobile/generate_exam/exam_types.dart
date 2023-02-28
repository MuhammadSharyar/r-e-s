import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_chap_exams/class_list.dart';
import 'package:r_e_s/screens/mobile/generate_exam/for_book_exams/class_list.dart'
    as wb;
import 'package:r_e_s/screens/mobile/generate_exam/for_term_exams/class_list.dart'
    as tw;

import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';

class ExamTypes extends StatelessWidget {
  const ExamTypes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Types"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 55,
            child: OutlinedButton(
              onPressed: () {
                Get.to(ClassList());
              },
              child: Text(
                "Chapter Wise",
                style: TextStyle(
                  fontSize: medium,
                ),
              ),
            ),
          ),
          addVerticalSpace(10),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 55,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(),
              onPressed: () {
                Get.to(tw.ClassList());
              },
              child: Text(
                "Term Wise",
                style: TextStyle(
                  fontSize: medium,
                ),
              ),
            ),
          ),
          addVerticalSpace(10),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 55,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(),
              onPressed: () {
                Get.to(wb.ClassList());
              },
              child: Text(
                "Whole Book",
                style: TextStyle(
                  fontSize: medium,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
