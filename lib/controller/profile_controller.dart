import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_model.dart';
import '../model/teacher_model.dart';
import '../util/enum.dart';

class ProfileController extends GetxController {
  RxBool showPassword = true.obs;
  RxBool isRegistered = true.obs;
  RxBool isLogin = true.obs;
  RxBool enable = false.obs;
  final formKey = GlobalKey<FormState>();
  RxString currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).obs;
  RxString currentTime = DateFormat('hh:mm a').format(DateTime.now()).obs;
  RxList<TeacherModel> teacherListReg = <TeacherModel>[].obs;
  RxList<TeacherModel> loginCredTeacher = <TeacherModel>[].obs;
  RxList<StudentModel> studentListReg = <StudentModel>[].obs;
  RxList<StudentModel> loginCredStudent = <StudentModel>[].obs;
  RxString tsType = ''.obs;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final classController = TextEditingController();
  final rollNoController = TextEditingController();
  final passwordController = TextEditingController();
  final experienceController = TextEditingController();
  final mothersNameController = TextEditingController();
  final fathersNameController = TextEditingController();
  List<String> classList = [
    "1",
    "2",
    "3",
    "4",
  ];
  List<String> teachingClasses = [];
  FilePickerResult? file;
  String? image;

  Future<void> pickFiles() async {
    if (enable.value == true) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);
      if (result != null) {
        image = result.files.single.path;
        update();
      } else {}
    } else {
      dialogue('msgEditButtonClick'.tr);
    }
  }

  getTS() async {
    final pref = await SharedPreferences.getInstance();
    var ts = pref.getString('TS');
    if (ts != null) {
      tsType.value = ts;
      log(tsType.value);
    } else {
      log('ts is null');
    }
  }

  StudentModel? studentModelLogin;
  RxString studentName = "".obs;
  RxString studentClass = "".obs;
  RxString studentRollNo = "".obs;
  getStudentListLogin() async {
    final pref = await SharedPreferences.getInstance();
    final d = pref.getString("loginCredStudent");
    if (d != null) {
      StudentModel data = StudentModel.fromMap(json.decode(d));
      nameController.text = data.name;
      studentName.value = data.name;
      studentRollNo.value = data.rollNo;
      studentClass.value = data.currentClass;
      passwordController.text = data.password;
      ageController.text = data.age;
      addressController.text = data.address;
      fathersNameController.text = data.father;
      mothersNameController.text = data.mother;
      rollNoController.text = data.rollNo;
      classController.text = data.currentClass;
      image = data.image;
      studentModelLogin = data;
    }
  }

  TeacherModel? teacherModelLogin;
  RxString teacherName = "".obs;
  RxString teacherClass = "".obs;
  RxList teacherTeachingClass = [].obs;
  getTeacherListLogin() async {
    final pref = await SharedPreferences.getInstance();
    final d = pref.getString("loginCredTeacher");

    if (d != null) {
      TeacherModel data = TeacherModel.fromMap(json.decode(d));
      nameController.text = data.name;
      teacherName.value = data.name;
      passwordController.text = data.password;
      ageController.text = data.age;
      addressController.text = data.address;
      teachingClasses = data.teachingClasses;
      teacherTeachingClass.value = data.teachingClasses;
      classController.text = data.currentClass;
      teacherClass.value = data.currentClass;
      experienceController.text = data.experience;
      image = data.image;
      teacherModelLogin = data;
    }
  }

  StudentModel? studentModelReg;

  getStudentListReg() async {
    final pref = await SharedPreferences.getInstance();
    var student = pref.getStringList('studentList');
    if (student != null) {
      studentListReg.value = student.map((e) {
        var v = jsonDecode(e);
        return StudentModel.fromMap(v);
      }).toList();

      update();
    } else {
      log('student list  is null');
    }
  }

  TeacherModel? teacherModelReg;

  getTeacherListReg() async {
    final pref = await SharedPreferences.getInstance();
    var teacher = pref.getStringList('teacherList');
    if (teacher != null) {
      teacherListReg.value = teacher.map((e) {
        var v = jsonDecode(e);
        return TeacherModel.fromMap(v);
      }).toList();
    } else {
      log('teacher list is null');
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

  onEdit() async {
    if (enable.value == false) {
      enable.value = true;
      update();
    } else {
      if (tsType.value == "teacher") {
        if (nameController.text.isNotEmpty &&
            ageController.text.isNotEmpty &&
            passwordController.text.isNotEmpty &&
            experienceController.text.isNotEmpty &&
            addressController.text.isNotEmpty &&
            image != null &&
            teachingClasses.isNotEmpty) {
          if (formKey.currentState!.validate()) {
            await getTeacherListReg();
            final updatedTeacherList = teacherListReg.map((element) {
              if (element.name == teacherModelLogin?.name &&
                  element.password == teacherModelLogin?.password) {
                return TeacherModel(
                    name: nameController.text,
                    age: ageController.text,
                    password: passwordController.text,
                    currentClass: classController.text,
                    address: addressController.text,
                    experience: experienceController.text,
                    teachingClasses: teachingClasses,
                    image: image ?? "");
              } else {
                return element;
              }
            }).toList();
            final data = TeacherModel(
                name: nameController.text,
                age: ageController.text,
                password: passwordController.text,
                currentClass: classController.text,
                address: addressController.text,
                teachingClasses: teachingClasses,
                image: image ?? '',
                experience: experienceController.text);
            final pref = await SharedPreferences.getInstance();
            final jsonList =
                updatedTeacherList.map((e) => jsonEncode(e.toMap())).toList();
            await pref.setStringList('teacherList', jsonList);

            pref.setString("loginCredTeacher", json.encode(data.toMap()));
            update();
            await getTeacherListLogin();
            await getTeacherListReg();
            enable.value = false;
            showPassword.value = true;
            dialogue("updateSuccess".tr);
          } else {
            dialogue("validateWarning".tr);
          }
        } else {
          dialogue('msgRegWarning'.tr);
        }
      } else if (tsType.value == 'student') {
        if (nameController.text.isNotEmpty &&
            image != null &&
            ageController.text.isNotEmpty &&
            passwordController.text.isNotEmpty &&
            addressController.text.isNotEmpty &&
            classController.text.isNotEmpty &&
            fathersNameController.text.isNotEmpty &&
            mothersNameController.text.isNotEmpty) {
          if (formKey.currentState!.validate()) {
            await getStudentListReg();
            final updatedStudentList = studentListReg.map((element) {
              if (element.name == studentModelLogin?.name &&
                  element.password == studentModelLogin?.password) {
                return StudentModel(
                    name: nameController.text,
                    age: ageController.text,
                    password: passwordController.text,
                    currentClass: classController.text,
                    rollNo: rollNoController.text,
                    address: addressController.text,
                    father: fathersNameController.text,
                    mother: mothersNameController.text,
                    image: image ?? "");
              } else {
                return element;
              }
            }).toList();
            final data = StudentModel(
                name: nameController.text,
                age: ageController.text,
                password: passwordController.text,
                currentClass: classController.text,
                address: addressController.text,
                father: fathersNameController.text,
                mother: mothersNameController.text,
                image: image ?? '',
                rollNo: rollNoController.text);

            final pref = await SharedPreferences.getInstance();
            final jsonList =
                updatedStudentList.map((e) => jsonEncode(e.toMap())).toList();
            await pref.setStringList('studentList', jsonList);

            pref.setString("loginCredStudent", json.encode(data.toMap()));
            update();
            await getStudentListLogin();
            enable.value = false;
            showPassword.value = true;
            dialogue("updateSuccess".tr);
          } else {
            dialogue("validateWarning".tr);
          }
        } else {
          dialogue('msgRegWarning'.tr);
        }
      }
    }
  }

  ///Teacher Schedule List
  List teachingScheduleList = [
    {"startTime": "10:00 AM", "endTime": "11:00 AM", "class": "1"},
    {"startTime": "11:00 AM", "endTime": "12:00 PM", "class": "2"},
    {"startTime": "12:00 PM", "endTime": "01:00 PM", "class": "3"},
    {"startTime": "01:00 PM", "endTime": "02:00 PM", "class": "Lunch"},
    {"startTime": "02:00 PM", "endTime": "03:00 PM", "class": "4"},
    {"startTime": "03:00 PM", "endTime": "04:00 PM", "class": "1"},
  ];

  Map<String, String>? getCurrentSessionTeacher() {
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    for (var session in teachingScheduleList) {
      if (currentTime.compareTo(session["startTime"] ?? '') >= 0 &&
          currentTime.compareTo(session["endTime"] ?? '') <= 0) {
        return session;
      }
    }
    return null;
  }

  List allTeacherScheduleList = [
    {
      "name": "Manju",
      "schedule": [
        {"class": "1", "startTime": "10:00 AM", "endTime": "11:00 AM"},
        {"class": "1", "startTime": "11:00 AM", "endTime": "12:00 PM"},
        {"class": "3", "startTime": "12:00 PM", "endTime": "01:00 PM"},
        {"class": "4", "startTime": "02:00 PM", "endTime": "03:00 PM"},
        {"class": "2", "startTime": "03:00 PM", "endTime": "04:00 PM"},
      ]
    },
    {
      "name": "Ranju",
      "schedule": [
        {"class": "2", "startTime": "10:00 AM", "endTime": "11:00 AM"},
        {"class": "3", "startTime": "11:00 AM", "endTime": "12:00 PM"},
        {"class": "3", "startTime": "12:00 PM", "endTime": "01:00 PM"},
        {"class": "4", "startTime": "02:00 PM", "endTime": "03:00 PM"},
        {"class": "2", "startTime": "03:00 PM", "endTime": "04:00 PM"},
      ]
    },
    {
      "name": "Kinju",
      "schedule": [
        {"class": "4", "startTime": "10:00 AM", "endTime": "11:00 AM"},
        {"class": "3", "startTime": "11:00 AM", "endTime": "12:00 PM"},
        {"class": "2", "startTime": "12:00 PM", "endTime": "01:00 PM"},
        {"class": "1", "startTime": "02:00 PM", "endTime": "03:00 PM"},
        {"class": "2", "startTime": "03:00 PM", "endTime": "04:00 PM"},
      ]
    },
    {
      "name": "Bindhu",
      "schedule": [
        {"class": "3", "startTime": "10:00 AM", "endTime": "11:00 AM"},
        {"class": "2", "startTime": "11:00 AM", "endTime": "12:00 PM"},
        {"class": "1", "startTime": "12:00 PM", "endTime": "01:00 PM"},
        {"class": "4", "startTime": "02:00 PM", "endTime": "03:00 PM"},
        {"class": "4", "startTime": "03:00 PM", "endTime": "04:00 PM"},
      ]
    },
  ];

  ///Teacher viewing Assignments
  List assignmentList = [
    {
      "name": 'Ishitha',
      "class": "2",
      "rollNo": "9",
      "images": ["assets/images/assignment1.webp"]
    },
    {
      "name": 'Ishan',
      "class": "1",
      "rollNo": "10",
      "images": [
        "assets/images/assignment2.jpg",
        "assets/images/assignment22.jpg"
      ]
    },
  ];

  /// student adding assignment
  RxList<String?> studentAssignment = <String?>[].obs;
  String? assignmentImage;

  addAssignment() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      assignmentImage = result.files.single.path;
      update();
      studentAssignment.add(assignmentImage);
      assignmentImage = null;
    } else {}
    update();
  }

  List submittedAssignmentsList = [];

  submitAssignment() async {
    final pref = await SharedPreferences.getInstance();
    if (studentAssignment.isNotEmpty) {
      final jsonList =
          studentAssignment.map((element) => jsonEncode(element)).toList();
      getSubmittedAssignments();
      if (submittedAssignmentsList.isNotEmpty) {
        final json = jsonList.map((e) => jsonDecode(e)).toList();
        submittedAssignmentsList.addAll(json);
        List<String> submitList =
            submittedAssignmentsList.map((e) => jsonEncode(e)).toList();
        pref.setStringList('submittedAssignments', submitList);
      } else {
        pref.setStringList('submittedAssignments', jsonList);
      }
      update();
      studentAssignment.clear();
    } else {
      dialogue("addImageWaring".tr);
    }
  }

  getSubmittedAssignments() async {
    final pref = await SharedPreferences.getInstance();
    var jsonList = pref.getStringList("submittedAssignments");
    if (jsonList != null) {
      submittedAssignmentsList = jsonList.map((e) => jsonDecode(e)).toList();
      update();
    }
  }

  /// Student Schedule
  static String startTime = 'startTime';
  static String endTime = 'endTime';
  static String teacher = 'teacher';
  List studentScheduleList = [
    {startTime: "10:00 AM ", endTime: "11:00 AM", teacher: "Bindhu"},
    {startTime: "11:00 AM ", endTime: "12:30 PM", teacher: "Manju"},
    {startTime: "12:30 PM ", endTime: "01:30 PM", teacher: "Lunch"},
    {startTime: "01:30 PM ", endTime: "02:30 PM", teacher: "Manju"},
    {startTime: "02:30 PM", endTime: "03:30 PM", teacher: "Ranju"},
    {startTime: "03:30 PM", endTime: "04:30 PM", teacher: "Kinju"},
  ];

  Map<String, String>? getCurrentSessionStudent() {
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    for (var session in studentScheduleList) {
      if (currentTime.compareTo(session["startTime"] ?? '') >= 0 &&
          currentTime.compareTo(session["endTime"] ?? '') <= 0) {
        return session;
      }
    }
    return null;
  }

  ///  change language settings
  Language languageType = Language.english;

  submitSettings() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('language', languageType.name);
    await getLanguage();
    update();
  }

  getLanguage() async {
    final pref = await SharedPreferences.getInstance();
    var lang = pref.getString('language');
    if (lang != null) {
      if (lang == "malayalam") {
        languageType = Language.malayalam;
      } else if (lang == "hindi") {
        languageType = Language.hindi;
      } else if (lang == "english") {
        languageType = Language.english;
      }
    } else {
      log('item is null');
    }
  }

  /// attendance
  RxInt present = 45.obs;
  RxInt absent = 0.obs;

  int min = 39;
  int max = 50;

  @override
  void onInit() {
    super.onInit();
    getStudentListLogin();
    getTeacherListLogin();
    getTS();
    getLanguage();
  }
}
