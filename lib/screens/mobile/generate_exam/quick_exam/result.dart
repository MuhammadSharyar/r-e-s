import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'sample1.dart';

class ResultsList extends StatelessWidget {
  final List<Question> questions;
  final Map<int, bool> checkboxValues;

  ResultsList({required this.questions, required this.checkboxValues});

  @override
  Widget build(BuildContext context) {
    List<Question> attemptedQuestions = [];
    checkboxValues.forEach((index, value) {
      if (value) {
        attemptedQuestions.add(questions[index]);
      }
    });

    int totalMarks = 0;
    attemptedQuestions.forEach((question) {
      totalMarks += question.marks;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attempted Questions: $totalMarks',
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 8, 32, 43),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.yellow[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Total Marks: $totalMarks',
                  style: GoogleFonts.aBeeZee(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: attemptedQuestions.length,
                itemBuilder: (BuildContext context, int index) {
                  Question attempt = attemptedQuestions[index];
                  return Card(
                    color: Color.fromARGB(255, 176, 172, 137),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attempt.questionText,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Marks: ${attempt.marks}',
                            style: TextStyle(fontSize: 8),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Yep!');
              },
              child: Text('Go Back'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
