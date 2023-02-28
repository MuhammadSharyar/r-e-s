import 'package:get/get.dart';

class QuestionListController extends GetxController {
  RxList questionList = [].obs;

  void setQuestionList(List newList) {
    questionList.value = newList;
  }
}
