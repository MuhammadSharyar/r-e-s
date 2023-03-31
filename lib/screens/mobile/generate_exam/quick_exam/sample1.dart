import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'result.dart';

void main() => runApp(quickexam());

class quickexam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Question List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        fontFamily: 'Lato',
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(144, 175, 217, 1),
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(61, 90, 128, 1),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: Color.fromRGBO(255, 255, 254, 1),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text("Person Name",
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(61, 90, 128, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        SizedBox(
                          height: 6,
                        ),
                        Text("Subject name",
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(61, 90, 128, 1),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Color.fromRGBO(247, 248, 249, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Color.fromRGBO(144, 175, 217, 1),
          child: QuestionList(),
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final int marks;

  Question({required this.questionText, required this.marks});
}

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List<Question> _questions = [
    Question(questionText: 'First statement?', marks: 5),
    Question(questionText: 'Second Statement', marks: 10),
    Question(questionText: 'Third statement', marks: 15),
    Question(questionText: 'Fourth statement?', marks: 5),
    Question(questionText: 'Fifth Statement', marks: 10),
    Question(questionText: 'Sixth statement', marks: 15),
    Question(questionText: 'First statement?', marks: 5),
    Question(questionText: 'Second Statement', marks: 10),
    Question(questionText: 'Third statement', marks: 15),
    Question(questionText: 'Fourth statement?', marks: 5),
    Question(questionText: 'Fifth Statement', marks: 10),
    Question(questionText: 'Sixth statement', marks: 15),
    Question(questionText: 'First statement?', marks: 5),
    Question(questionText: 'Second Statement', marks: 10),
    Question(questionText: 'Third statement', marks: 15),
    Question(questionText: 'Fourth statement?', marks: 5),
    Question(questionText: 'Fifth Statement', marks: 10),
  ];

  Map<int, bool> _checkboxValues = {};
  var _cardColor;
  int _totalMarks = 0;
  int target = 100;
  bool _disableCheckboxes = false;

  void _updateTotalMarks(int index, bool value, int marks) {
    setState(() {
      int newTotalMarks = _totalMarks + (value ? marks : -marks);
      if (newTotalMarks > target) {
        value = false;
        newTotalMarks = _totalMarks;
        _disableCheckboxes = false;
      } else {
        _totalMarks = newTotalMarks;
      }
      _checkboxValues[index] = value;
      _checkTotalMarks();
    });
  }

  void _checkTotalMarks() {
    if (_totalMarks >= target) {
      setState(() {
        _disableCheckboxes = true;
      });
      if (_totalMarks == target) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('You have achieved your goal'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultsList(
                              questions: _questions,
                              checkboxValues: _checkboxValues)),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _disableCheckboxes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (BuildContext context, int index) {
              int questionnumber = index + 1;
              Question question = _questions[index];
              return Card(
                elevation: 0,
                color: Color.fromRGBO(61, 90, 128, 1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    leading: Container(
                      padding: EdgeInsets.only(right: 7),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color: Color.fromARGB(255, 55, 176, 232),
                              width: 2),
                        ),
                      ),
                      child: Text(
                        ' Q#:${questionnumber}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color.fromRGBO(253, 254, 254, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: question.questionText,
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(253, 254, 254, 1),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '\nMarks: ${question.marks}',
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Color.fromRGBO(253, 254, 254, 1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    trailing: Checkbox(
                      value: _checkboxValues[index] ?? false,
                      onChanged: (bool? value) {
                        if (_totalMarks == 15 && !value!) {
                          setState(() {
                            _disableCheckboxes = false;
                          });
                        }
                        _updateTotalMarks(index, value!, question.marks);
                      },
                      activeColor: _disableCheckboxes
                          ? Colors.grey
                          : Color.fromRGBO(61, 90, 128, 1),
                      checkColor:
                          _disableCheckboxes ? Colors.grey : Colors.white,
                      // controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(144, 175, 217, 1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                'Total Marks: $_totalMarks / $target',
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: 25),
                Container(
                  height: 55.0,
                  width: 43.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      child: Icon(Icons.navigation),
                      backgroundColor: Color.fromRGBO(61, 90, 128, 1),
                      foregroundColor: Colors.white,
                      onPressed: () {
                        Color:
                        Color.fromRGBO(61, 90, 128, 1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultsList(
                                  questions: _questions,
                                  checkboxValues: _checkboxValues)),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
