import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/profile_controller.dart';
import 'package:school/main.dart';
import 'package:school/ui/attendance.dart';
import 'package:school/ui/profile.dart';
import 'package:school/ui/settings.dart';
import 'package:school/ui/student_schedule.dart';
import 'package:school/ui/teacher_assignment.dart';
import 'package:school/ui/teacher_schedule.dart';
import 'package:school/util/color.dart';

import 'add_assignment.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    getAll();
  }

  getAll() async {
    await controller.getTS();
    await controller.getStudentListLogin();
    await controller.getTeacherListLogin();
    await controller.getLanguage();
    await getLanguage();
  }

  Locale locale = const Locale("en-US");

  @override
  Widget build(BuildContext context) {

    switch (language) {
      case "hindi":
        locale = const Locale('hi-IN');
        Get.locale = locale;

        break;
      case "malayalam":
        locale = const Locale('ml-IN');
        Get.locale = locale;

        break;
      case "english":
        locale = const Locale('en-US');
        Get.locale = locale;

        break;
      default:
        locale = const Locale('en-US');
        Get.locale = locale;
        break;
    }

    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: GetBuilder<ProfileController>(builder: (context) {
          return Text('Home'.tr);
        }),
      ),
      body: GetBuilder<ProfileController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Obx(
              () => controller.tsType.value == "student"
                  ? _student(controller)
                  : controller.tsType.value == "teacher"
                      ? _teacher(controller)
                      : const SizedBox(),
            ),
          ],
        );
      }),
    );
  }

  _teacher(ProfileController controller) {
    final prController = Get.put(ProfileController());
    Map<String, String>? currentSession =
        prController.getCurrentSessionTeacher();
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.onPrimary));
    prController.getTeacherListLogin();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: decoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${'Name'.tr} : ${prController.teacherName.value}')
                          .paddingSymmetric(vertical: 10),
                      Text('${'Class'.tr} : ${prController.teacherClass.value == "" ? controller.teacherTeachingClass.last : prController.teacherClass.value}')
                          .paddingSymmetric(vertical: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: decoration,
                child: currentSession != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'currentSession'.tr,
                            style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.onPrimary),
                          ).paddingSymmetric(vertical: 10),
                          Text('${'class/event'.tr} : ${currentSession["class"]}')
                              .paddingSymmetric(vertical: 10),
                          Text('${'Duration'.tr} : ${currentSession["startTime"]} - ${currentSession["endTime"]}')
                              .paddingSymmetric(vertical: 10),
                        ],
                      )
                    : Text('msgSession'.tr),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const Attendance()));
                },
                text: 'Attendance'.tr,
              ),
            ),
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const TeacherSchedule()));
                },
                text: 'Schedule'.tr,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 10),
        Row(
          children: [
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => const Profile()));
                },
                text: 'Profile'.tr,
              ),
            ),
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const Settings()));
                },
                text: 'settings'.tr,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 10),
        Text("Assignments".tr).paddingSymmetric(vertical: 10, horizontal: 20),
        const TeacherAssignment(),
      ],
    );
  }

  _student(ProfileController controller) {
    final prController = Get.put(ProfileController());
    Map<String, String>? currentSession =
        prController.getCurrentSessionStudent();
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.onPrimary));
    return Column(
      children: [
        Obx(() => Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: decoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('${'Name'.tr} : ${prController.studentName.value}')
                            .paddingSymmetric(vertical: 10),
                        Text('${'Class'.tr} : ${prController.studentClass.value}')
                            .paddingSymmetric(vertical: 10),
                        Text('${'RollNo'.tr} : ${prController.studentRollNo.value}')
                            .paddingSymmetric(vertical: 10),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: decoration,
                child: currentSession != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'currentSession'.tr,
                            style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColor.onPrimary),
                          ).paddingSymmetric(vertical: 10),
                          Text('${'Teacher'.tr}: ${currentSession["teacher"]}')
                              .paddingSymmetric(vertical: 10),
                          Text('${'duration'.tr}: ${currentSession["startTime"]} - ${currentSession["endTime"]}')
                              .paddingSymmetric(vertical: 10),
                        ],
                      )
                    : Text('msgSession'.tr),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const AddAssignment()));
                },
                text: 'Assignments'.tr,
              ),
            ),
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const StudentSchedule()));
                },
                text: 'Schedule'.tr,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 10),
        Row(
          children: [
            Expanded(
              child: _CusCard(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const Profile()));
                  },
                  text: 'Profile'.tr),
            ),
            Expanded(
              child: _CusCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const Settings()));
                },
                text: 'settings'.tr,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 10),
      ],
    );
  }
}

class _CusCard extends StatelessWidget {
  final Function() onTap;
  final String text;

  const _CusCard({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 0.0,
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        decoration: BoxDecoration(
            color: AppColor.secondary, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(text)),
      ),
    );
  }
}
