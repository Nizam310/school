import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_model.dart';
import '../model/teacher_model.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showPasswordNew = true.obs;
  RxBool showPasswordReEnter = true.obs;
  RxBool isLogin = false.obs;
  RxBool isRegistered = false.obs;
  List<TeacherModel> teacherList = [];
  List<StudentModel> studentList = [];
  RxString tsType = 'student'.obs;
  StudentModel? model;
  bool userExist = false;
  RxBool studentOrTeacher = false.obs;
  final formKey = GlobalKey<FormState>();
  final loginForm = GlobalKey<FormState>();

  studentOrTeacherCheck() {
    studentOrTeacher.value = !studentOrTeacher.value;
    update();
  }

  onLogin() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if (tsType.value == 'student') {
        await getStudentList();
        if (studentList.isNotEmpty) {
          for (var i in studentList) {
            if (usernameController.text == i.name &&
                passwordController.text == i.password) {
              userExist = true;
              final pref = await SharedPreferences.getInstance();
              final data = StudentModel(
                  name: i.name,
                  age: i.age,
                  password: i.password,
                  currentClass: i.currentClass,
                  rollNo: i.rollNo,
                  address: i.address,
                  father: i.father,
                  mother: i.mother,
                  image: i.image);
              pref.setString("loginCredStudent", json.encode(data.toMap()));
            }
          }
          if (userExist) {
            Navigator.pushNamedAndRemoveUntil(
                Get.context!, '/home', (route) => false);
            final pref = await SharedPreferences.getInstance();
            pref.setString("TS", tsType.value);
            isLogin.value = true;
            pref.setBool('isLogin', isLogin.value);
            dialogue('loginSuccess'.tr);
          } else {
            dialogue('loginErrorWaring'.tr);
          }
        } else {
          dialogue('loginErrorWaring'.tr);
        }
      } else if (tsType.value == "teacher") {
        await getTeacherList();
        if (teacherList.isNotEmpty) {
          for (var i in teacherList) {
            if (usernameController.text == i.name &&
                passwordController.text == i.password) {
              userExist = true;
              final pref = await SharedPreferences.getInstance();
              final data = TeacherModel(
                  name: i.name,
                  age: i.age,
                  password: i.password,
                  experience: i.experience,
                  address: i.address,
                  currentClass: i.currentClass,
                  image: i.image,
                  teachingClasses: i.teachingClasses);
              pref.setString("loginCredTeacher", json.encode(data.toMap()));
            }
          }
          if (userExist == true) {
            Navigator.pushNamedAndRemoveUntil(
                Get.context!, '/home', (route) => false);
            final pref = await SharedPreferences.getInstance();
            pref.setString("TS", tsType.value);
            isLogin.value = true;
            pref.setBool('isLogin', isLogin.value);
            dialogue('loginSuccess'.tr);
          } else {
            dialogue('loginErrorWaring'.tr);
          }
        } else {
          dialogue('loginErrorWaring'.tr);
        }
      }
    } else {
      dialogue('emptyWarning'.tr);
    }
  }

  forgotPassword() async {
    bool userExist = false;
    await getStudentList();
    await getTeacherList();

    if (usernameController.text.isNotEmpty) {
      if (tsType.value == "student") {
        for (var i in studentList) {
          if (i.name == usernameController.text) {
            userExist = true;
          }
        }
        if (userExist == true) {
          Navigator.pushNamed(Get.context!, '/forgotPassword');
        } else {
          dialogue("userNotExist".tr);
        }
      } else if (tsType.value == "teacher") {
        for (var i in teacherList) {
          if (i.name == usernameController.text) {
            userExist = true;
          }
        }
        if (userExist == true) {
          Navigator.pushNamed(Get.context!, '/forgotPassword');
        } else {
          dialogue("userNotExist".tr);
        }
      }
    } else {
      dialogue('userNameNotEmpty'.tr);
    }
  }

  forgotPasswordSubmit() async {
    if (newPasswordController.text.isNotEmpty &&
        reEnterPasswordController.text.isNotEmpty) {
      if (newPasswordController.text == reEnterPasswordController.text) {
        if (tsType.value == 'student') {
          final updatedStudentList = studentList.map((element) {
            if (element.name == usernameController.text) {
              return StudentModel(
                  name: element.name,
                  age: element.age,
                  password: reEnterPasswordController.text,
                  currentClass: element.currentClass,
                  address: element.address,
                  father: element.father,
                  mother: element.mother,
                  rollNo: element.rollNo,
                  image: element.image);
            } else {
              return element;
            }
          }).toList();
          final pref = await SharedPreferences.getInstance();
          final jsonList =
              updatedStudentList.map((e) => jsonEncode(e.toMap())).toList();
          await pref.setStringList('studentList', jsonList);

          isRegistered.value = true;
          await pref.setBool('registered', isRegistered.value);
          dialogue('passwordChangedSuccess'.tr);
          await Navigator.pushNamedAndRemoveUntil(
              Get.context!, '/login', (route) => false);
          update();
        }

        /// Teacher
        else if (tsType.value == "teacher") {
          final updatedTeacherList = teacherList.map((element) {
            if (element.name == usernameController.text) {
              return TeacherModel(
                  name: element.name,
                  age: element.age,
                  password: reEnterPasswordController.text,
                  currentClass: element.currentClass,
                  address: element.address,
                  experience: element.experience,
                  teachingClasses: element.teachingClasses,
                  image: element.image);
            } else {
              return element;
            }
          }).toList();
          final pref = await SharedPreferences.getInstance();
          final jsonList =
              updatedTeacherList.map((e) => jsonEncode(e.toMap())).toList();
          await pref.setStringList('teacherList', jsonList);
          isRegistered.value = true;
          await pref.setBool('registered', isRegistered.value);
          dialogue('passwordChangedSuccess'.tr);
          await Navigator.pushNamedAndRemoveUntil(
              Get.context!, '/login', (route) => false);
          update();
        }
      } else {
        dialogue("passwordsNotMatch".tr);
      }
    } else {
      dialogue("emptyWarning".tr);
    }
  }

  signUp() async {
    final pref = await SharedPreferences.getInstance();
    isRegistered.value = false;
    await pref.setBool('registered', isRegistered.value);
    await pref.setBool('loginSignUp', true);
    update();
    await Navigator.pushNamedAndRemoveUntil(
        Get.context!, '/regFirst', (route) => false);
  }

  getStudentList() async {
    final pref = await SharedPreferences.getInstance();
    var student = pref.getStringList('studentList');
    if (student != null) {
      studentList = student.map((e) {
        var v = jsonDecode(e);
        return StudentModel.fromMap(v);
      }).toList();
      studentModel = studentList.last;
      update();
    } else {
      log('item is null');
    }
  }

  StudentModel? studentModel;
  TeacherModel? teacherModel;

  getTeacherList() async {
    final pref = await SharedPreferences.getInstance();
    var teacher = pref.getStringList('teacherList');
    if (teacher != null) {
      var list = teacher.map((e) {
        var v = jsonDecode(e);
        return TeacherModel.fromMap(v);
      }).toList();
      teacherList = list;
      teacherModel = teacherList.last;
      update();
    } else {
      log('item is null');
    }
  }

  dialogue(String message) {
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.TOP,
      messageText: Text(message,
          textAlign: TextAlign.start,
          style:
              Get.context!.textTheme.bodySmall?.copyWith(color: Colors.white)),
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      borderRadius: 10,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black,
    ));
  }

  getLogin() async {
    final pref = await SharedPreferences.getInstance();
    var login = pref.getBool('isLogin');
    if (login != null) {
      isLogin.value = login;

      login == true
          ? Navigator.pushNamedAndRemoveUntil(
              Get.context!, '/home', (route) => false)
          : null;
    } else {
      log('Register is null');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getLogin();
  }
}
