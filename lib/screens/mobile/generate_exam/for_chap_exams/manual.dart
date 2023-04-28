import 'package:flutter/material.dart';

class QuestionListPage extends StatefulWidget {
  final List<dynamic> questions;

  const QuestionListPage({Key? key, required this.questions}) : super(key: key);

  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  List<dynamic> _selectedQuestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Questions'),
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          final question = widget.questions[index];
          return Card(
            child: ListTile(
              title: Text(
                question['question'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Difficulty: ${question['difficulty']}'),
                  Text('Chapter: ${question['chapter']}'),
                  Text('Type: ${question['type']}'),
                  Text('Marks: ${question['marks']}'),
                  if (question['imagelink'] != null)
                    Image.network(
                      question['imagelink'],
                      height: 100,
                    ),
                ],
              ),
              trailing: Checkbox(
                value: _selectedQuestions.contains(question),
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedQuestions.add(question);
                    } else {
                      _selectedQuestions.remove(question);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_selectedQuestions);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
