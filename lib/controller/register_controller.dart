import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/model/student_model.dart';
import 'package:school/model/teacher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/enum.dart';

class RegisterController extends GetxController {
  RxString havingAnAccount = "havingAnAccount".tr.obs;
  RxString or = "or".tr.obs;
  RxString signIn = "signIn".tr.obs;
  TS tsType = TS.student;
  RxString selected = '1'.obs;
  final studentKey = GlobalKey<FormState>();
  final teacherKey = GlobalKey<FormState>();
  RxBool classTeacherOrNot = false.obs;
  Language languageType = Language.english;
  RxBool submitted = false.obs;
  RxBool showPassword = true.obs;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final classController = TextEditingController();
  final passwordController = TextEditingController();
  final experienceController = TextEditingController();
  final mothersNameController = TextEditingController();
  final fathersNameController = TextEditingController();
  final rollNoController = TextEditingController();

  onSubmitFirstPage() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('TS', tsType.name);
    await getTS();
    await pref.setString('language', languageType.name);
    await getLanguage();

    nameController.clear();
    ageController.clear();
    addressController.clear();
    classController.clear();
    passwordController.clear();
    experienceController.clear();
    mothersNameController.clear();
    fathersNameController.clear();
    rollNoController.clear();
    image = null;
    teachingClasses.clear();

    Navigator.pushNamed(Get.context!, '/register');
  }

  List<String> classList = [
    "1",
    "2",
    "3",
    "4",
  ];
  List<String> teachingClasses = [];

  List<TeacherModel> teacherList = [];
  List<StudentModel> studentList = [];

  RxBool isRegistered = false.obs;

  studentAdd() async {
    await getStudentList();
    print(studentList.length);
    studentList.add(StudentModel(
        name: nameController.text,
        age: ageController.text,
        password: passwordController.text,
        currentClass: classController.text,
        address: addressController.text,
        father: fathersNameController.text,
        mother: mothersNameController.text,
        image: image ?? '',
        rollNo: rollNoController.text));

    final pref = await SharedPreferences.getInstance();
    isRegistered.value = true;
    await pref.setBool('registered', isRegistered.value);

    update();
    final jsonList = studentList.map((e) => jsonEncode(e.toMap())).toList();
    await pref.setStringList('studentList', jsonList);
    dialogue('registerSuccess'.tr);
    await getStudentList();

    await Navigator.pushNamedAndRemoveUntil(
        Get.context!, '/login', (route) => false);
  }

  teacherAdd() async {
    await getTeacherList();
    print(teacherList);
    teacherList.add(TeacherModel(
        name: nameController.text,
        age: ageController.text,
        password: passwordController.text,
        experience: experienceController.text,
        address: addressController.text,
        teachingClasses: teachingClasses,
        image: image ?? '',
        currentClass: classController.text));

    final pref = await SharedPreferences.getInstance();

    isRegistered.value = true;
    await pref.setBool('registered', isRegistered.value);

    final jsonList = teacherList.map((e) => jsonEncode(e.toMap())).toList();
    await pref.setStringList('teacherList', jsonList);
    await getTeacherList();
    print(teacherList);
    dialogue('registerSuccess'.tr);
    await Navigator.pushNamedAndRemoveUntil(
        Get.context!, '/login', (route) => false);
    update();
  }

  onRegister() async {
    if (tsType == TS.teacher) {
      if (nameController.text.isNotEmpty &&
          ageController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          experienceController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          image != null &&
          teachingClasses.isNotEmpty) {
        if (teacherKey.currentState!.validate()) {
          await getTeacherList();
          if (teacherList.isNotEmpty) {
            bool userExist = false;
            for (var i in teacherList) {
              if (i.name == nameController.text) {
                userExist = true;
              }
            }

            if (userExist == true) {
              dialogue("userExist".tr);
            } else {
              await teacherAdd();
            }
          } else {
            await teacherAdd();
          }
        } else {
          dialogue("validateWarning".tr);
        }
      } else {
        dialogue('msgRegWarning'.tr);
      }
    } else if (tsType == TS.student) {
      if (nameController.text.isNotEmpty &&
          image != null &&
          ageController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          classController.text.isNotEmpty &&
          fathersNameController.text.isNotEmpty &&
          mothersNameController.text.isNotEmpty) {
        if (studentKey.currentState!.validate()) {
          await getStudentList();
          if (studentList.isNotEmpty) {
            bool userExist = false;
            for (var i in studentList) {
              if (i.name == nameController.text) {
                userExist = true;
              }
            }

            if (userExist == true) {
              dialogue("userExist".tr);
            } else {
              await studentAdd();
              studentKey.currentState!.reset();
            }
          } else {
            await studentAdd();
            studentKey.currentState!.reset();
          }
        } else {
          dialogue("validateWarning".tr);
        }
      } else {
        dialogue('msgRegWarning'.tr);
      }
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

  FilePickerResult? file;
  String? image;

  Future<void> pickFiles() async {
    // final prefs = await SharedPreferences.getInstance();

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      image = result.files.single.path;

      // prefs.setString('image', result.files.single.path ?? '');
      update();
    } else {}
  }

  buildShowDialog() {
    return showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  getTS() async {
    final pref = await SharedPreferences.getInstance();
    var ts = pref.getString('TS');
    if (ts != null) {
      ts = tsType.name;
      log(ts);
      log(tsType.name);
    } else {
      log('item is null');
    }
  }

  getLanguage() async {
    final pref = await SharedPreferences.getInstance();
    var lang = pref.getString('language');
    if (lang != null) {
      lang = languageType.name;
      log(lang);
      log(languageType.name);
    } else {
      log('item is null');
    }
  }

  getStudentList() async {
    final pref = await SharedPreferences.getInstance();
    var student = pref.getStringList('studentList');
    if (student != null) {
      studentList = student.map((e) {
        var v = jsonDecode(e);
        return StudentModel.fromMap(v);
      }).toList();
    } else {
      log('student list  is empty');
    }
  }

  getTeacherList() async {
    final pref = await SharedPreferences.getInstance();
    var teacher = pref.getStringList('teacherList');
    if (teacher != null) {
      teacherList = teacher.map((e) {
        var v = jsonDecode(e);
        return TeacherModel.fromMap(v);
      }).toList();
    } else {
      log('teacher list  is empty');
    }
  }

  getRegister() async {
    final pref = await SharedPreferences.getInstance();
    var reg = pref.getBool('registered');
    if (reg != null) {
      isRegistered.value = reg;
      print(reg);
      print(reg);
      print(reg);
      reg == true
          ? Navigator.pushNamedAndRemoveUntil(
              Get.context!, '/login', (route) => false)
          : null;
    } else {
      log('Register is null');
    }
  }

  RxBool loginSignUp = false.obs;
  getLoginSignUp() async {
    final pref = await SharedPreferences.getInstance();
    var login = pref.getBool('loginSignUp');
    if (login != null) {
      loginSignUp.value = login;
    } else {
      log('signUp login is null');
    }
  }

  signIN() async {
    final pref = await SharedPreferences.getInstance();
    isRegistered.value = true;
    pref.setBool("registered", isRegistered.value);
    Navigator.pushNamedAndRemoveUntil(Get.context!, '/login', (route) => false);
  }

  @override
  void onInit() {
    super.onInit();
    Get.updateLocale(const Locale('en-US'));
    getLanguage();
    getTS();
    getRegister();
    getTeacherList();
    getStudentList();
  }
}
