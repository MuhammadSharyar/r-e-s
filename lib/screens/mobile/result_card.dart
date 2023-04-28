import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isTeacher = false;

  List<Map<String, dynamic>> _results = [
    {
      'name': 'John',
      'subject': 'Maths',
      'marks': 90,
    },
    {
      'name': 'John',
      'subject': 'Science',
      'marks': 80,
    },
    {
      'name': 'Mary',
      'subject': 'Maths',
      'marks': 95,
    },
    {
      'name': 'Mary',
      'subject': 'Science',
      'marks': 85,
    },
  ];

  late List<Map<String, dynamic>> _filteredResults;

  @override
  void initState() {
    super.initState();

    // Get the Firebase database reference
    //_resultsRef = FirebaseDatabase.instance.reference().child('results');

    _isTeacher = true;

    // Filter the results based on the user type
    if (_isTeacher) {
      _filteredResults = _results;
    } else {
      // In this example, we're hardcoding the student name
      // In a real app, you would use Firebase Authentication to get the student name
      String studentName = 'John';
      _filteredResults =
          _results.where((result) => result['name'] == studentName).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isTeacher)
              DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'subject',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Marks',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: _filteredResults
                    .map((result) => DataRow(cells: [
                          DataCell(Text(result['name'])),
                          DataCell(Text(result['subject'])),
                          DataCell(Text(result['marks'].toString())),
                        ]))
                    .toList(),
              ),
            if (!_isTeacher)
              DataTable(
                columns: const [
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Marks')),
                ],
                rows: _filteredResults
                    .map((result) => DataRow(cells: [
                          DataCell(Text(result['subject'])),
                          DataCell(Text(result['marks'].toString())),
                        ]))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
