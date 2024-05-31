import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/student_model.dart';
import '../model/teacher_model.dart';
import '../util/enum.dart';

class HomeController extends GetxController {
  List<TeacherModel> teacherList = [];
  List<StudentModel> studentList = [];
  RxString tsType = ''.obs;

  getTS() async {
    final pref = await SharedPreferences.getInstance();
    var ts = pref.getString('TS');
    if (ts != null) {
      tsType.value = ts;
      log(tsType.value);
    } else {
      log('item is null');
    }
  }

  StudentModel? model;

  getStudentList() async {
    final pref = await SharedPreferences.getInstance();
    var student = pref.getStringList('studentList');
    if (student != null) {
      studentList = student.map((e) {
        var v = jsonDecode(e);
        return StudentModel.fromMap(v);
      }).toList();
      print(studentList.last.name);
      model = studentList.last;
      print(model?.name);
    } else {
      log('Student list is null');
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
      print(teacherList.last.teachingClasses);
    } else {
      log('item is null');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getTeacherList();
    getStudentList();
    getTS();
    getLanguage();
  }


}
