import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/student_model.dart';
import '../model/teacher_model.dart';
import 'enum.dart';

class LocalDatabase {
  static Future getRegListStudentList(
      {required List<StudentModel> studentList}) async {
    final pref = await SharedPreferences.getInstance();
    var student = pref.getStringList('studentList');
    if (student != null) {
      studentList = student.map((e) {
        var v = jsonDecode(e);
        return StudentModel.fromMap(v);
      }).toList();
      return studentList;
    } else {
      log('student list  is empty');
    }
  }

  static Future getRegListTeacherList(
      {required List<TeacherModel> teacherList}) async {
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

  static Future getLoginCredStudent() async {
    final pref = await SharedPreferences.getInstance();
    final d = pref.getString("loginCredStudent");

    if (d != null) {
      StudentModel model = StudentModel.fromMap(json.decode(d));
    }
  }

  static Future getLoginCredTeacher() async {
    final pref = await SharedPreferences.getInstance();
    final d = pref.getString("loginCredTeacher");

    if (d != null) {
      TeacherModel model = TeacherModel.fromMap(json.decode(d));
    }
  }

  static getTS({required TS tsType}) async {
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

  static getLanguages({required Language languageType}) async {
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

  static getRegister({required RxBool isRegistered}) async {
    final pref = await SharedPreferences.getInstance();
    var reg = pref.getBool('registered');
    if (reg != null) {
      isRegistered.value = reg;
      reg == true
          ? Navigator.pushNamedAndRemoveUntil(
              Get.context!, '/login', (route) => false)
          : null;
    } else {
      log('Register is null');
    }
  }
}
