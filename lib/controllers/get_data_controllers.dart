import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:r_e_s/controllers/school_email_controller.dart';

class GetClassesController extends GetxController {
  RxList classes = [].obs;

  Future getClasses() async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    classes.value = [];

    await FirebaseFirestore.instance
        .collection('Schools')
        .doc(schoolEmail)
        .collection('Classes')
        .get()
        .then(
          (value) => classes += value.docs.map((doc) => doc.data()).toList(),
        );
  }
}

class GetCoursesController extends GetxController {
  RxList courses = [].obs;
  String className = "";

  Future getCourses({required String forClass}) async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    className = forClass;
    courses.value = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection('Classes')
        .doc(forClass)
        .collection('Courses')
        .get()
        .then(
          (value) => courses += value.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }
}

class GetChaptersController extends GetxController {
  RxList chapters = [].obs;
  String className = '', courseName = '';

  Future getChapters({
    required String forClass,
    required String forCourse,
  }) async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    className = forClass;
    courseName = forCourse;
    chapters.value = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection('Classes')
        .doc(forClass)
        .collection('Courses')
        .doc(forCourse)
        .collection('Chapters')
        .get()
        .then(
          (value) => chapters += value.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }
}

class GetBooksController extends GetxController {
  RxList books = [].obs;

  Future getBooks() async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    books.value = [];
    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection("Books")
        .get()
        .then(
          (value) => books += value.docs.map((doc) => doc.data()).toList(),
        );
  }
}

class GetQuestionsController extends GetxController {
  RxList questions = [].obs;

  Future getQuestions({
    required String forClass,
    required String forCourse,
    required String forChapter,
    required String questionType,
  }) async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    questions.value = [];

    var firebaseFirestore = FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection('Classes')
        .doc(forClass)
        .collection('Courses')
        .doc(forCourse)
        .collection('Chapters')
        .doc(forChapter)
        .collection(questionType);

    await firebaseFirestore
        .get(const GetOptions(source: Source.server))
        .then((value) {
      if (value.docs.isNotEmpty) {
        questions.value += value.docs.map((doc) => doc.data()).toList();
      } else {
        questions.value = [];
      }
    }).catchError((onError) {
      questions.value = [];
    });

    // try {
    //   var questionData =
    //       await firebaseFirestore.get(const GetOptions(source: Source.cache));
    //   if (questionData.docs.isNotEmpty) {
    //     questions.value += questionData.docs.map((doc) => doc.data()).toList();
    //   } else if (questionData.docs.isEmpty) {
    //     await firebaseFirestore
    //         .get(const GetOptions(source: Source.server))
    //         .then((value) {
    //       if (value.docs.isNotEmpty) {
    //         questions.value += value.docs.map((doc) => doc.data()).toList();
    //       } else {
    //         questions.value = [];
    //       }
    //     });
    //   }
    // } catch (_) {
    //   await firebaseFirestore
    //       .get(const GetOptions(source: Source.server))
    //       .then((value) {
    //     if (value.docs.isNotEmpty) {
    //       questions.value += value.docs.map((doc) => doc.data()).toList();
    //     } else {
    //       questions.value = [];
    //     }
    //   });
    // }
  }
}

class GetWholeBookQuestionsController extends GetxController {
  RxList questions = [].obs;

  Future getWholeBookQuestions({
    required String forClass,
    required String forCourse,
    required String questionType,
  }) async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    questions.value = [];

    var firebaseFirestore = FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection('Classes')
        .doc(forClass)
        .collection('Courses')
        .doc(forCourse)
        .collection(questionType);

    await firebaseFirestore
        .get(const GetOptions(source: Source.server))
        .then((value) {
      if (value.docs.isNotEmpty) {
        questions.value += value.docs.map((doc) => doc.data()).toList();
      }
    });

    // try {
    //   var questionData =
    //       await firebaseFirestore.get(const GetOptions(source: Source.cache));
    //   if (questionData.docs.isNotEmpty) {
    //     questions.value += questionData.docs.map((doc) => doc.data()).toList();
    //   } else if (questionData.docs.isEmpty) {
    //     await firebaseFirestore
    //         .get(const GetOptions(source: Source.server))
    //         .then((value) {
    //       if (value.docs.isNotEmpty) {
    //         questions.value += value.docs.map((doc) => doc.data()).toList();
    //       } else {
    //         questions.value = [];
    //       }
    //     });
    //   }
    // } catch (_) {
    //   await firebaseFirestore
    //       .get(const GetOptions(source: Source.server))
    //       .then((value) {
    //     if (value.docs.isNotEmpty) {
    //       questions.value += value.docs.map((doc) => doc.data()).toList();
    //     } else {
    //       questions.value = [];
    //     }
    //   });
    // }
  }
}

class GetTermQuestionsController extends GetxController {
  RxList questions = [].obs;

  Future getQuestions({
    required String forClass,
    required String forCourse,
    required String forTerm,
    required String questionType,
  }) async {
    final schoolEmail = Get.find<SchoolEmailController>().schoolEmail.value;
    questions.value = [];
    List allChapters = [];

    await FirebaseFirestore.instance
        .collection("Schools")
        .doc(schoolEmail)
        .collection('Classes')
        .doc(forClass)
        .collection('Courses')
        .doc(forCourse)
        .collection('Chapters')
        .get()
        .then((value) =>
            allChapters += value.docs.map((doc) => doc.data()).toList());

    for (int i = 0; i < allChapters.length; i++) {
      if (allChapters[i]['term'] == forTerm) {
        var firebaseFirestore = FirebaseFirestore.instance
            .collection("Schools")
            .doc(schoolEmail)
            .collection('Classes')
            .doc(forClass)
            .collection('Courses')
            .doc(forCourse)
            .collection('Chapters')
            .doc(allChapters[i]['name'])
            .collection(questionType);

        await firebaseFirestore
            .get(const GetOptions(source: Source.server))
            .then((value) {
          if (value.docs.isNotEmpty) {
            questions.value += value.docs.map((doc) => doc.data()).toList();
          }
        });

        // try {
        //   var questionData = await firebaseFirestore
        //       .get(const GetOptions(source: Source.cache));
        //   if (questionData.docs.isNotEmpty) {
        //     questions.value +=
        //         questionData.docs.map((doc) => doc.data()).toList();
        //   } else if (questionData.docs.isEmpty) {
        //     await firebaseFirestore
        //         .get(const GetOptions(source: Source.server))
        //         .then((value) {
        //       if (value.docs.isNotEmpty) {
        //         questions.value += value.docs.map((doc) => doc.data()).toList();
        //       }
        //     });
        //   }
        // } catch (_) {
        //   await firebaseFirestore
        //       .get(const GetOptions(source: Source.server))
        //       .then((value) {
        //     if (value.docs.isNotEmpty) {
        //       questions.value += value.docs.map((doc) => doc.data()).toList();
        //     }
        //   });
        // }
      }
    }
  }
}
