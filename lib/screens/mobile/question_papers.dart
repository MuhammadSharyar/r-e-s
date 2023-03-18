import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

class Question {
  final String questionText;

  Question({required this.questionText});
}

class AutoPaperGenerator {
  final List<Question> questions;

  AutoPaperGenerator({required this.questions});

  List<Question> generateAutoPaper() {
    List<Question> shuffledQuestions = List.from(questions)..shuffle(Random());
    return shuffledQuestions;
  }
}

class AutoPaperPage extends StatefulWidget {
  @override
  _AutoPaperPageState createState() => _AutoPaperPageState();
}

class _AutoPaperPageState extends State<AutoPaperPage> {
  int _numPapers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Auto Paper Generator'),
        ),
        body: Center(
            child: ElevatedButton(
                child: Text('Generate Auto Papers'),
                onPressed: () async {
                  _numPapers = (await showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      int _n = 1;
                      return AlertDialog(
                        title: const Text('Generate Auto Papers'),
                        content: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: '1',
                          onChanged: (value) => _n = int.tryParse(value) ?? _n,
                          decoration: InputDecoration(
                            labelText: 'Number of Papers',
                            hintText: 'Enter number of papers to generate',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('CANCEL'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(_n),
                          ),
                        ],
                      );
                    },
                  ))!;
                  if (_numPapers != null) {
                    // Define the list of 10 questions
                    List<Question> questions = [
                      Question(questionText: 'Question 1'),
                      Question(questionText: 'Question 2'),
                      Question(questionText: 'Question 3'),
                      Question(questionText: 'Question 4'),
                      Question(questionText: 'Question 5'),
                      Question(questionText: 'Question 6'),
                      Question(questionText: 'Question 7'),
                      Question(questionText: 'Question 8'),
                      Question(questionText: 'Question 9'),
                      Question(questionText: 'Question 10'),
                    ];

                    // Generate n number of auto papers
                    for (int i = 1; i <= _numPapers; i++) {
                      AutoPaperGenerator generator =
                          AutoPaperGenerator(questions: questions);
                      List<Question> autoPaper = generator.generateAutoPaper();

                      // Create a PDF document with the auto paper
                      pdfLib.Document document = pdfLib.Document();
                      document.addPage(
                        pdfLib.Page(
                          build: (context) {
                            return pdfLib.Column(
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Text(
                                  'Auto Paper $i',
                                  style: pdfLib.TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                pdfLib.SizedBox(height: 10),
                                for (int j = 0; j < autoPaper.length; j++)
                                  pdfLib.Container(
                                    margin: pdfLib.EdgeInsets.only(bottom: 10),
                                    child: pdfLib.Column(
                                      crossAxisAlignment:
                                          pdfLib.CrossAxisAlignment.start,
                                      children: [
                                        pdfLib.Text(
                                          'Q${j + 1}: ${autoPaper[j].questionText}',
                                          style: pdfLib.TextStyle(
                                            fontWeight: pdfLib.FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                      final Directory? directory =
                          await getExternalStorageDirectory();
                      final String path =
                          '${directory!.path}/Auto Paper $i.pdf';
                      final File file = File(path);
                      await file.writeAsBytes(await document.save());
                      print(path);
                    }
                  }
                })));

// Save the PDF file in the mobile device's local storage
  }
}
