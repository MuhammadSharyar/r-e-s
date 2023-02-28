import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../screens/mobile/all_screens/all_screens.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<String?> createSchoolAccount({
    required logo,
    required name,
    required address,
    required email,
    required password,
  }) async {
    String downloadLink = "";
    String currentUserId = "";
    String teacherKey = const Uuid().v4();
    String managementKey = const Uuid().v4();
    String studentKey = const Uuid().v4();

    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((res) async {
      await res.user!.updateDisplayName(name);
      currentUserId = res.user!.uid;
    });
    await storage
        .ref()
        .child("School Logos/$currentUserId")
        .putFile(File(logo));
    downloadLink = await storage
        .ref()
        .child("School Logos/$currentUserId")
        .getDownloadURL();

    await firestore.collection('Schools').doc(email).set({
      "schoolName": name,
      "schoolLogo": downloadLink,
      "schoolAddress": address,
      "position": "school",
      "keyForTeachers": teacherKey,
      "keyForManagement": managementKey,
      "keyForStudents": studentKey,
      "totalTerms": 2,
    });

    if (auth.currentUser != null) {
      Get.offAll(AllScreens());
    }

    return "Request Successful";
  }

  Future<Object> createTeacherAccount({
    required key,
    required schoolEmail,
    required name,
    required email,
    required password,
    required phone,
    required address,
    required gender,
  }) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((res) async {
      await res.user!.updateDisplayName(name);
    });
    await firestore.collection('Teachers').doc(email).set({
      "position": "teacher",
      "school_email": schoolEmail,
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
      "gender": gender,
      "permissions": {
        "addClass": false,
        "addTeacher": false,
        "addManagement": false,
        "addStudent": false,
        "addCourse": false,
        "addQuestion": false,
        "addTeacherForm": false,
        "addStudentForm": false,
        "addBook": false,
        "addPaperPattern": false,
        "createPaper": false,
        "setCurriculum": false,
      },
    });

    if (auth.currentUser != null) {
      Get.offAll(AllScreens());
    }

    return "Request Successful";
  }

  Future<Object> createManagementAccount({
    required key,
    required schoolEmail,
    required name,
    required email,
    required password,
    required phone,
    required address,
    required gender,
  }) async {
    bool schoolAccountExists = false;

    await firestore.collection('Schools').doc(schoolEmail).get().then((value) {
      if (value.exists) {
        schoolAccountExists = true;
      } else {
        schoolAccountExists = false;
      }
    });
    if (schoolAccountExists) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((res) async {
        await res.user!.updateDisplayName(name);
      });
      await firestore.collection('Management').doc(email).set({
        "position": "management",
        "school_email": schoolEmail,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
        "gender": gender,
        "permissions": {
          "addClass": false,
          "addTeacher": false,
          "addManagement": false,
          "addStudent": false,
          "addCourse": false,
          "addQuestion": false,
          "addTeacherForm": false,
          "addStudentForm": false,
          "addBook": false,
          "addPaperPattern": false,
          "createPaper": false,
          "setCurriculum": false,
        },
      });

      if (auth.currentUser != null) {
        Get.offAll(AllScreens());
      }

      return "Request Successful";
    } else {
      return FirebaseAuthException(
          message: "Please enter a valid school email", code: '');
    }
  }

  Future<Object> createStudentAccount({
    required key,
    required schoolEmail,
    required name,
    required email,
    required password,
    required phone,
    required address,
    required gender,
  }) async {
    bool schoolAccountExists = false;

    await firestore.collection('Schools').doc(schoolEmail).get().then((value) {
      if (value.exists) {
        schoolAccountExists = true;
      } else {
        schoolAccountExists = false;
      }
    });
    if (schoolAccountExists) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((res) async {
        await res.user!.updateDisplayName(name);
      });
      await firestore.collection('Student').doc(email).set({
        "position": "student",
        "school_email": schoolEmail,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
        "gender": gender,
        "permissions": {
          "addClass": false,
          "addTeacher": false,
          "addManagement": false,
          "addStudent": false,
          "addCourse": false,
          "addQuestion": false,
          "addTeacherForm": false,
          "addStudentForm": false,
          "addBook": false,
          "addPaperPattern": false,
          "createPaper": false,
          "setCurriculum": false,
        },
      });

      if (auth.currentUser != null) {
        Get.offAll(AllScreens());
      }

      return "Request Successful";
    } else {
      return "Email not found";
    }
  }

  Future<String?> userLogin({required email, required password}) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    if (auth.currentUser != null) {
      Get.offAll(AllScreens());
    }
    return "Request Successful";
  }
}
