import 'package:flutter/material.dart';
import 'package:r_e_s/screens/mobile/add_question/question_card.dart';

class AddQuestion extends StatelessWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Question"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              QuestionCard(),
            ],
          ),
        ),
      ),
    );
  }
}
