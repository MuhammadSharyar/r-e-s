import 'package:get/get.dart';
import 'package:r_e_s/controllers/get_data_controllers.dart';

class ClassController extends GetxController {
  final getClassesController = Get.put(GetClassesController());

  RxString currentClass = "Select Class".obs;
  RxList classList = [].obs;

  Future getClasses() async {
    classList.value = [];
    if (getClassesController.classes.isEmpty) {
      await getClassesController.getClasses();
    }
    classList.value = getClassesController.classes;
  }

  void setClass(String newClass) {
    currentClass.value = newClass;
  }
}

class CourseController extends GetxController {
  final getCoursesController = Get.put(GetCoursesController());
  RxString currentCourse = "Select Course".obs;
  RxList courseList = [].obs;

  Future getCourses({required String forClass}) async {
    courseList.value = [];
    await getCoursesController.getCourses(forClass: forClass);
    courseList.value = getCoursesController.courses;
  }

  void setCourse(String newCourse) {
    currentCourse.value = newCourse;
  }

  void setCourseList(List newList) {
    courseList.value = newList;
  }
}

class ChapterController extends GetxController {
  RxString currentChapter = "Select Chapter".obs;
  RxList chapterList = [].obs;

  final getChaptersController = Get.put(GetChaptersController());

  Future getChapters({
    required String forClass,
    required String forCourse,
  }) async {
    chapterList.value = [];
    await getChaptersController.getChapters(
      forClass: forClass,
      forCourse: forCourse,
    );
    chapterList.value = getChaptersController.chapters;
  }

  void setChapter(String newChapter) {
    currentChapter.value = newChapter;
  }

  void setChapterList(List newList) {
    chapterList.value = newList;
  }
}

class GenderController extends GetxController {
  List genders = ['Select gender', 'Male', 'Female'];
  RxString selectedGender = "Select gender".obs;

  void setGender(String newGender) {
    selectedGender.value = newGender;
  }
}

class QuestionTypeController extends GetxController {
  RxString currentQuestionType = "Select Question Type".obs;

  void setQuestionType(String newType) {
    currentQuestionType.value = newType;
  }
}

class DifficultyController extends GetxController {
  RxString currentDifficulty = "Select Difficulty".obs;

  void setDifficulty(String newDifficulty) {
    currentDifficulty.value = newDifficulty;
  }
}

class TermController extends GetxController {
  RxString currentTerm = "Select Term".obs;

  void setTerm(String newTerm) {
    currentTerm.value = newTerm;
  }
}
