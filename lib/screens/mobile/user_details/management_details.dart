import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/checkbox_controllers.dart';
import '../../../theme/theme_constants.dart';
import '../../../utils/helper_widgets.dart';

class ManagementDetails extends StatefulWidget {
  var name, email, contact, address, gender, permissions;

  ManagementDetails({
    Key? key,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.gender,
    required this.permissions,
  }) : super(key: key);

  @override
  State<ManagementDetails> createState() => _ManagementDetailsState();
}

class _ManagementDetailsState extends State<ManagementDetails> {
  final addClassController = Get.put(AddClassCheckBoxController());
  final addManagementController = Get.put(AddManagementCheckBoxController());
  final addTeacherController = Get.put(AddTeacherCheckBoxController());
  final addStudentController = Get.put(AddStudentCheckBoxController());
  final addCourseController = Get.put(AddCourseCheckBoxController());
  final addQuestionController = Get.put(AddQuestionCheckBoxController());
  final addTeacherFormController = Get.put(AddTeacherFormCheckBoxController());
  final addStudentFormController = Get.put(AddStudentFormCheckBoxController());
  final addBooksController = Get.put(AddBookCheckBoxController());
  final addPaperPatternController =
      Get.put(AddPaperPatternCheckBoxController());
  final createPaperController = Get.put(CreatePaperCheckBoxController());
  final curriculumController = Get.put(SetCurriculumCheckBoxController());

  Future getPermissions() async {
    addClassController.setCheck(widget.permissions['addClass']);
    addManagementController.setCheck(widget.permissions['addManagement']);
    addManagementController.setCheck(widget.permissions['addManagement']);
    addStudentController.setCheck(widget.permissions['addStudent']);
    addCourseController.setCheck(widget.permissions['addCourse']);
    addQuestionController.setCheck(widget.permissions['addQuestion']);
    addTeacherFormController.setCheck(widget.permissions['addTeacherForm']);
    addStudentFormController.setCheck(widget.permissions['addStudentForm']);
    addBooksController.setCheck(widget.permissions['addBook']);
    addPaperPatternController.setCheck(widget.permissions['addPaperPattern']);
    createPaperController.setCheck(widget.permissions['createPaper']);
    curriculumController.setCheck(widget.permissions['setCurriculum']);
  }

  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Management Details"),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(18.0),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name : \t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.name,
                        maxLines: 3,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: large,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contact :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      widget.contact,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Address :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.address,
                        maxLines: 3,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: large,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gender :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      widget.gender,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Permissions",
                    style: TextStyle(
                      fontSize: xlarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => customCheckBox(
                    title: "Add Classes",
                    value: addClassController.addClass.value,
                    onChange: (newValue) async {
                      widget.permissions['addClass'] =
                          !(widget.permissions['addClass']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addClassController
                          .setCheck(widget.permissions['addClass']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Management",
                    value: addManagementController.addManagement.value,
                    onChange: (newValue) async {
                      widget.permissions['addManagement'] =
                          !(widget.permissions['addManagement']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addManagementController
                          .setCheck(widget.permissions['addManagement']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Students",
                    value: addStudentController.addStudent.value,
                    onChange: (newValue) async {
                      widget.permissions['addStudent'] =
                          !(widget.permissions['addStudent']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addStudentController
                          .setCheck(widget.permissions['addStudent']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Courses & Chapters",
                    value: addCourseController.addCourse.value,
                    onChange: (newValue) async {
                      widget.permissions['addCourse'] =
                          !(widget.permissions['addCourse']);
                      widget.permissions['addClass'] =
                          !(widget.permissions['addClass']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addCourseController
                          .setCheck(widget.permissions['addCourse']);
                      addClassController
                          .setCheck(widget.permissions['addClass']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Questions",
                    value: addQuestionController.addQuestion.value,
                    onChange: (newValue) async {
                      widget.permissions['addQuestion'] =
                          !(widget.permissions['addQuestion']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addQuestionController
                          .setCheck(widget.permissions['addQuestion']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Teacher Forms",
                    value: addTeacherFormController.addTeacherForm.value,
                    onChange: (newValue) async {
                      widget.permissions['addTeacherForm'] =
                          !(widget.permissions['addTeacherForm']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addTeacherFormController
                          .setCheck(widget.permissions['addTeacherForm']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Student Forms",
                    value: addStudentFormController.addStudentForm.value,
                    onChange: (newValue) async {
                      widget.permissions['addStudentForm'] =
                          !(widget.permissions['addStudentForm']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addStudentFormController
                          .setCheck(widget.permissions['addStudentForm']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Books",
                    value: addBooksController.addBook.value,
                    onChange: (newValue) async {
                      widget.permissions['addBook'] =
                          !(widget.permissions['addBook']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addBooksController
                          .setCheck(widget.permissions['addBook']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Add Paper Pattern",
                    value: addPaperPatternController.addPaperPattern.value,
                    onChange: (newValue) async {
                      widget.permissions['addPaperPattern'] =
                          !(widget.permissions['addPaperPattern']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      addPaperPatternController
                          .setCheck(widget.permissions['addPaperPattern']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Create Paper",
                    value: createPaperController.createPaper.value,
                    onChange: (newValue) async {
                      widget.permissions['createPaper'] =
                          !(widget.permissions['createPaper']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      createPaperController
                          .setCheck(widget.permissions['createPaper']);
                    },
                  ),
                ),
                Obx(
                  () => customCheckBox(
                    title: "Set Curriculum",
                    value: curriculumController.curriculum.value,
                    onChange: (newValue) async {
                      widget.permissions['setCurriculum'] =
                          !(widget.permissions['setCurriculum']);
                      await FirebaseFirestore.instance
                          .collection('Management')
                          .doc(widget.email)
                          .update({
                        "permissions": {
                          "addClass": widget.permissions['addClass'],
                          "addManagement": widget.permissions['addManagement'],
                          "addTeacher": widget.permissions['addTeacher'],
                          "addStudent": widget.permissions['addStudent'],
                          "addCourse": widget.permissions['addCourse'],
                          "addQuestion": widget.permissions['addQuestion'],
                          "addTeacherForm":
                              widget.permissions['addTeacherForm'],
                          "addStudentForm":
                              widget.permissions['addStudentForm'],
                          "addBook": widget.permissions['addBook'],
                          "addPaperPattern":
                              widget.permissions['addPaperPattern'],
                          "createPaper": widget.permissions['createPaper'],
                          "setCurriculum": widget.permissions['setCurriculum'],
                        }
                      });
                      curriculumController
                          .setCheck(widget.permissions['setCurriculum']);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
