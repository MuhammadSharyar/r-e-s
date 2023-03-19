import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:r_e_s/controllers/count_controller.dart';
import 'package:r_e_s/controllers/error_controller.dart';
import 'package:r_e_s/controllers/get_data_controllers.dart';
import 'package:r_e_s/controllers/get_school_details.dart';
import 'package:r_e_s/controllers/loading_controller.dart';
import 'package:r_e_s/theme/theme_constants.dart';
import 'package:r_e_s/utils/helper_widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class GenerateExam1 extends StatelessWidget {
  final String forClass, forCourse, forChapter;
  final List questionTypes;
  GenerateExam1({
    super.key,
    required this.questionTypes,
    required this.forClass,
    required this.forCourse,
    required this.forChapter,
  });

  final mcqController = TextEditingController();
  final shortController = TextEditingController();
  final longController = TextEditingController();
  final blanksController = TextEditingController();
  final trueFalseController = TextEditingController();
  final letterController = TextEditingController();
  final essayController = TextEditingController();
  final storyController = TextEditingController();
  final meaningController = TextEditingController();
  final countController = Get.put(CountController());
  final questionController = Get.put(GetQuestionsController());
  final loadingController = Get.put(LoadingController());
  final errorController = Get.put(ErrorController());
  final schoolDetails = Get.find<GetSchoolDetails>().schoolDetails;

  final titleTextSize = 22.0;
  final headingTextSize = 21.0;
  final normalTextSize = 17.0;
  final smallTextSize = 16.0;

  void setCount() {
    countController.count.value = 0;
    if (mcqController.text != "") {
      countController.count.value += int.parse(mcqController.text);
    } else {
      countController.count.value += 0;
    }
    if (shortController.text != "") {
      countController.count.value += int.parse(shortController.text);
    } else {
      countController.count.value += 0;
    }
    if (longController.text != "") {
      countController.count.value += int.parse(longController.text);
    } else {
      countController.count.value += 0;
    }
    if (blanksController.text != "") {
      countController.count.value += int.parse(blanksController.text);
    } else {
      countController.count.value += 0;
    }
    if (trueFalseController.text != "") {
      countController.count.value += int.parse(trueFalseController.text);
    } else {
      countController.count.value += 0;
    }
    if (letterController.text != "") {
      countController.count.value += int.parse(letterController.text);
    } else {
      countController.count.value += 0;
    }
    if (essayController.text != "") {
      countController.count.value += int.parse(essayController.text);
    } else {
      countController.count.value += 0;
    }
    if (storyController.text != "") {
      countController.count.value += int.parse(storyController.text);
    } else {
      countController.count.value += 0;
    }
    if (meaningController.text != "") {
      countController.count.value += int.parse(meaningController.text);
    } else {
      countController.count.value += 0;
    }
  }

  Future selectQuestions({
    required questionTextController,
    required List questionList,
  }) async {
    List selectedQuestions = [];
    if (questionTextController.text != "" && questionList.isNotEmpty) {
      loadingController.setLoading(true);
      Random random = Random();
      List addedQuestions = [];
      int totalMarks = int.parse(questionTextController.text);
      int currentMarks = 0;
      int checkedValues = 0;
      int continueCount = 0;

      while (true) {
        int randomValue = random.nextInt(questionList.length);
        if (addedQuestions.length == questionList.length ||
            currentMarks == totalMarks ||
            checkedValues == questionList.length) {
          break;
        } else if ((currentMarks +
                int.parse(await questionList[randomValue]['marks'])) >
            totalMarks) {
          continueCount += 1;
          if (continueCount < 20) {
            continue;
          } else {
            break;
          }
        } else if (!(addedQuestions.contains(randomValue))) {
          addedQuestions.add(randomValue);
          selectedQuestions.add(await questionList[randomValue]);
          currentMarks += int.parse(await questionList[randomValue]['marks']);
          checkedValues += 1;
          continueCount = 0;
        }
      }
      loadingController.setLoading(false);
    }

    return selectedQuestions;
  }

  pw.Widget getMcqs(List mcqs, List images) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Text(
              "Mcqs",
              style: pw.TextStyle(
                fontSize: headingTextSize,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          for (int i = 0; i < mcqs.length; i++) ...{
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(children: [
                  pw.Text(
                    "${i + 1})",
                    style: pw.TextStyle(
                      fontSize: normalTextSize,
                    ),
                  ),
                  pw.SizedBox(width: 7),
                  (images[i]['image'] != 'none')
                      ? pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(
                              width: 300,
                              child: pw.Image(images[i]['image']),
                            ),
                            pw.SizedBox(height: 1),
                            pw.Text(
                              "${mcqs[i]['question']}",
                              style: pw.TextStyle(
                                fontSize: normalTextSize,
                              ),
                            ),
                          ],
                        )
                      : pw.Text(
                          "${mcqs[i]['question']}",
                          style: pw.TextStyle(
                            fontSize: normalTextSize,
                          ),
                        ),
                ]),
                pw.Text(
                  "( ${mcqs[i]['marks']}",
                  style: pw.TextStyle(
                    fontSize: smallTextSize,
                  ),
                ),
              ],
            ),
            pw.Text(
              "\n     a) ${mcqs[i]['option1']}",
              style: pw.TextStyle(
                fontSize: normalTextSize,
              ),
            ),
            pw.Text(
              "     b) ${mcqs[i]['option2']}",
              style: pw.TextStyle(
                fontSize: normalTextSize,
              ),
            ),
            (mcqs[i]['option3'] == "")
                ? pw.Container()
                : pw.Text(
                    "     c) ${mcqs[i]['option3']}",
                    style: pw.TextStyle(
                      fontSize: normalTextSize,
                    ),
                  ),
            (mcqs[i]['option4'] == "")
                ? pw.Container()
                : pw.Text(
                    "     ${(mcqs[i]['option3'] == "") ? "c)" : "d)"} ${mcqs[i]['option4']}",
                    style: pw.TextStyle(
                      fontSize: normalTextSize,
                    ),
                  ),
            pw.SizedBox(height: 10),
          }
        ]);
  }

  pw.Widget getShortQuestions(List shorts, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Short Questions",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < shorts.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${shorts[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${shorts[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${shorts[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getLongQuestions(List longs, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Long Questions",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < longs.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${longs[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${longs[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${longs[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getBlanks(List blanks, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Fill in the blanks",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < blanks.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != "none")
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            "${blanks[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${blanks[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${blanks[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getTrueFalse(List truefalse, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "True False",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < truefalse.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${truefalse[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${truefalse[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Row(children: [
                pw.Text(
                  "True  False",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.Text(
                  "    ( ${truefalse[i]['marks']}",
                  style: pw.TextStyle(
                    fontSize: smallTextSize,
                  ),
                ),
              ]),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getEssays(List essays, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Essays",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < essays.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${essays[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${essays[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${essays[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getLetters(List letters, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Letters",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < letters.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${letters[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${letters[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${letters[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getStories(List stories, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Stories",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < stories.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${stories[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${stories[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${stories[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  pw.Widget getWordMeanings(List meanings, List images) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            "Word Meanings",
            style: pw.TextStyle(
              fontSize: headingTextSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (int i = 0; i < meanings.length; i++) ...{
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(children: [
                pw.Text(
                  "${i + 1})",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.SizedBox(width: 7),
                (images[i]['image'] != 'none')
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Image(images[i]['image']),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            "${meanings[i]['question']}",
                            style: pw.TextStyle(
                              fontSize: normalTextSize,
                            ),
                          ),
                        ],
                      )
                    : pw.Text(
                        "${meanings[i]['question']}",
                        style: pw.TextStyle(
                          fontSize: normalTextSize,
                        ),
                      ),
              ]),
              pw.Text(
                "( ${meanings[i]['marks']}",
                style: pw.TextStyle(
                  fontSize: smallTextSize,
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  Future generateExam1({
    required List mcqs,
    required List shorts,
    required List longs,
    required List blanks,
    required List truefalse,
    required List essays,
    required List letters,
    required List stories,
    required List meanings,
  }) async {
    var pdf = pw.Document();
    List mcqImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        shortImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        longImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        blankImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        tfImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        essayImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        letterImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        storyImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true),
        meaningImages = List.filled(1000, {"image": "none", "index": "none"},
            growable: true);

    for (int i = 0; i < mcqs.length; i++) {
      if (mcqs[i]['imageLink'] != "") {
        await http.get(Uri.parse(await mcqs[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          mcqImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < shorts.length; i++) {
      if (shorts[i]['imageLink'] != "") {
        await http.get(Uri.parse(await shorts[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          shortImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < longs.length; i++) {
      if (longs[i]['imageLink'] != "") {
        await http.get(Uri.parse(await longs[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          longImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < blanks.length; i++) {
      if (blanks[i]['imageLink'] != "") {
        await http.get(Uri.parse(await blanks[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          blankImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < truefalse.length; i++) {
      if (truefalse[i]['imageLink'] != "") {
        await http
            .get(Uri.parse(await truefalse[i]['imageLink']))
            .then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          tfImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < essays.length; i++) {
      if (essays[i]['imageLink'] != "") {
        await http.get(Uri.parse(await essays[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          essayImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < letters.length; i++) {
      if (letters[i]['imageLink'] != "") {
        await http.get(Uri.parse(await letters[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          letterImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < stories.length; i++) {
      if (stories[i]['imageLink'] != "") {
        await http.get(Uri.parse(await stories[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          storyImages[i] = {"image": image, "index": i};
        });
      }
    }
    for (int i = 0; i < meanings.length; i++) {
      if (meanings[i]['imageLink'] != "") {
        await http.get(Uri.parse(await meanings[i]['imageLink'])).then((value) {
          var bytes = value.bodyBytes;
          final image = pw.MemoryImage(bytes);
          meaningImages[i] = {"image": image, "index": i};
        });
      }
    }

    final netImage = await networkImage(await schoolDetails['schoolLogo']);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 100,
                  child: pw.Image(netImage),
                ),
                pw.SizedBox(width: 30),
                pw.Text(
                  "${schoolDetails['schoolName']}",
                  style: pw.TextStyle(
                    fontSize: titleTextSize,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                )
              ],
            ),
            pw.SizedBox(height: 7),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "$forCourse ($forChapter)",
                  style: pw.TextStyle(
                    fontSize: titleTextSize,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 27),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Student Name: ________________",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 17),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Student Rollno: ______________",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
                pw.Text(
                  "Date: ___________",
                  style: pw.TextStyle(
                    fontSize: normalTextSize,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 37),
            (mcqs.isNotEmpty) ? getMcqs(mcqs, mcqImages) : pw.Container(),
            pw.SizedBox(height: 25),
            (shorts.isNotEmpty)
                ? getShortQuestions(shorts, shortImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (longs.isNotEmpty)
                ? getLongQuestions(longs, longImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (blanks.isNotEmpty)
                ? getBlanks(blanks, blankImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (truefalse.isNotEmpty)
                ? getTrueFalse(truefalse, tfImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (essays.isNotEmpty)
                ? getEssays(essays, essayImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (letters.isNotEmpty)
                ? getLetters(letters, letterImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (stories.isNotEmpty)
                ? getStories(stories, storyImages)
                : pw.Container(),
            pw.SizedBox(height: 25),
            (meanings.isNotEmpty)
                ? getWordMeanings(meanings, meaningImages)
                : pw.Container(),
          ];
        },
      ),
    );
    var filePath = "/storage/emulated/0/Download/${forCourse}_$forChapter.pdf";
    File pdfFile = File(filePath);
    await pdfFile.writeAsBytes(await pdf.save());
    OpenFile.open(pdfFile.path);
  }

  Future generateExam({
    required List mcqs,
    required List shorts,
    required List longs,
    required List blanks,
    required List truefalse,
    required List essays,
    required List letters,
    required List stories,
    required List meanings,
  }) async {
    for (int i = 0; i < 5; i++) {
      mcqs.shuffle(Random());
      shorts.shuffle(Random());
      longs.shuffle(Random());
      blanks.shuffle(Random());
      truefalse.shuffle(Random());
      essays.shuffle(Random());
      letters.shuffle(Random());
      stories.shuffle(Random());
      meanings.shuffle(Random());

      generateExam(
        mcqs: mcqs,
        shorts: shorts,
        longs: longs,
        blanks: blanks,
        truefalse: truefalse,
        essays: essays,
        letters: letters,
        stories: stories,
        meanings: meanings,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(questionTypes);
    return WillPopScope(
      onWillPop: () async {
        errorController.setErrorMessage("");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Generate Exam"),
          actions: [
            Align(
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Obx(
                  () {
                    return Text(
                      "${countController.count.value}% Completed",
                      style: TextStyle(fontSize: large),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                (questionTypes.contains("MCQ Questions"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: mcqController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "MCQs %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Short Questions"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: shortController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Short Q's %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Long Questions"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: longController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Long Q's %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Fill in the Blanks"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: blanksController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Fill in the blanks %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("True False"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: trueFalseController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "True False %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Letters"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: letterController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Letters %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Essays"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: essayController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Essays %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Stories"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: storyController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Stories %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                (questionTypes.contains("Word Meanings"))
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customTextField2(
                          controller: meaningController,
                          onChanged: (value) {
                            setCount();
                          },
                          labelText: "Word Meanings %",
                          textInputType: TextInputType.number,
                        ),
                      )
                    : Container(),
                Obx(() => errorText(errorController)),
                customButton1(
                  context: context,
                  title: "Generate Exam",
                  onPressed: () async {
                    if (countController.count.value != 100) {
                      errorController
                          .setErrorMessage("Marks weightage should be 100%");
                    } else {
                      errorController.setErrorMessage("");
                      loadingController.setLoading(true);
                      List mcqs = [],
                          short = [],
                          long = [],
                          blanks = [],
                          truefalse = [],
                          letters = [],
                          essays = [],
                          stories = [],
                          meanings = [];

                      List selectedMcqs = [],
                          selectedShort = [],
                          selectedLong = [],
                          selectedBlanks = [],
                          selectedTruefalse = [],
                          selectedLetters = [],
                          selectedEssays = [],
                          selectedStories = [],
                          selectedMeanings = [];

                      for (int i = 0; i < questionTypes.length; i++) {
                        await questionController.getQuestions(
                          forClass: forClass,
                          forCourse: forCourse,
                          forChapter: forChapter,
                          questionType: questionTypes[i],
                        );
                        if (questionTypes[i] == "MCQ Questions" &&
                            int.parse(mcqController.text) != 0 &&
                            mcqController.text != "") {
                          mcqs = questionController.questions;
                          await selectQuestions(
                            questionTextController: mcqController,
                            questionList: mcqs,
                          ).then((value) {
                            selectedMcqs = value;
                          });
                        } else if (questionTypes[i] == "Short Questions" &&
                            int.parse(shortController.text) != 0 &&
                            shortController.text != "") {
                          short = questionController.questions;
                          await selectQuestions(
                            questionTextController: shortController,
                            questionList: short,
                          ).then((value) {
                            selectedShort = value;
                          });
                        } else if (questionTypes[i] == "Long Questions" &&
                            int.parse(longController.text) != 0 &&
                            longController.text != "") {
                          long = questionController.questions;
                          await selectQuestions(
                            questionTextController: longController,
                            questionList: long,
                          ).then((value) {
                            selectedLong = value;
                          });
                        } else if (questionTypes[i] == "Fill in the Blanks" &&
                            int.parse(blanksController.text) != 0 &&
                            blanksController.text != "") {
                          blanks = questionController.questions;
                          await selectQuestions(
                            questionTextController: blanksController,
                            questionList: blanks,
                          ).then((value) {
                            selectedBlanks = value;
                          });
                        } else if (questionTypes[i] == "True False" &&
                            int.parse(trueFalseController.text) != 0 &&
                            trueFalseController.text != "") {
                          truefalse = questionController.questions;
                          await selectQuestions(
                            questionTextController: trueFalseController,
                            questionList: truefalse,
                          ).then((value) {
                            selectedTruefalse = value;
                          });
                        } else if (questionTypes[i] == "Letters" &&
                            int.parse(letterController.text) != 0 &&
                            letterController.text != "") {
                          letters = questionController.questions;
                          await selectQuestions(
                            questionTextController: letterController,
                            questionList: letters,
                          ).then((value) {
                            selectedLetters = value;
                          });
                        } else if (questionTypes[i] == "Essays" &&
                            int.parse(essayController.text) != 0 &&
                            essayController.text != "") {
                          essays = questionController.questions;
                          await selectQuestions(
                            questionTextController: essayController,
                            questionList: essays,
                          ).then((value) {
                            selectedEssays = value;
                          });
                        } else if (questionTypes[i] == "Stories" &&
                            int.parse(storyController.text) != 0 &&
                            storyController.text != "") {
                          stories = questionController.questions;
                          await selectQuestions(
                            questionTextController: storyController,
                            questionList: stories,
                          ).then((value) {
                            selectedStories = value;
                          });
                        } else if (questionTypes[i] == "Word Meanings" &&
                            int.parse(meaningController.text) != 0 &&
                            meaningController.text != "") {
                          meanings = questionController.questions;
                          await selectQuestions(
                            questionTextController: meaningController,
                            questionList: meanings,
                          ).then((value) {
                            selectedMeanings = value;
                          });
                        }
                      }
                      if (await Permission.storage.isDenied) {
                        await Permission.storage.request();
                        if (await Permission.storage.isGranted) {
                          int _numPapers = 1;
                          _numPapers = (await showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              int _n = 1;
                              return AlertDialog(
                                title: const Text('Generate Auto Papers'),
                                content: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: '1',
                                  onChanged: (value) =>
                                      _n = int.tryParse(value) ?? _n,
                                  decoration: const InputDecoration(
                                    labelText: 'Number of Papers',
                                    hintText:
                                        'Enter number of papers to generate',
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('CANCEL'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(_n),
                                  ),
                                ],
                              );
                            },
                          ))!;
                          await generateExam(
                            mcqs: selectedMcqs,
                            shorts: selectedShort,
                            longs: selectedLong,
                            blanks: selectedBlanks,
                            essays: selectedEssays,
                            letters: selectedLetters,
                            stories: selectedStories,
                            truefalse: selectedTruefalse,
                            meanings: selectedMeanings,
                          );
                        }
                      } else if (await Permission.storage.isGranted) {
                        int _numPapers = 1;
                        _numPapers = (await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            int _n = 1;
                            return AlertDialog(
                              title: const Text('Generate Auto Papers'),
                              content: TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: '1',
                                onChanged: (value) =>
                                    _n = int.tryParse(value) ?? _n,
                                decoration: const InputDecoration(
                                  labelText: 'Number of Papers',
                                  hintText:
                                      'Enter number of papers to generate',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(_n),
                                ),
                              ],
                            );
                          },
                        ))!;
                        await generateExam(
                          mcqs: selectedMcqs,
                          shorts: selectedShort,
                          longs: selectedLong,
                          blanks: selectedBlanks,
                          essays: selectedEssays,
                          letters: selectedLetters,
                          stories: selectedStories,
                          truefalse: selectedTruefalse,
                          meanings: selectedMeanings,
                        );
                      }
                      loadingController.setLoading(false);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
