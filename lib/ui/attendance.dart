import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/profile_controller.dart';

import '../util/color.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final controller = Get.put(ProfileController());
  List<DateTime?> _dates = [DateTime.now()];
  final style = const TextStyle(color: AppColor.onPrimary);
  final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColor.onPrimary));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getTeacherListLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Attendance'.tr,style: const TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: decoration,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarViewMode: DatePickerMode.day,
                selectedDayHighlightColor: AppColor.buttonColor,
                dayTextStyle: style,
                selectedDayTextStyle: style,
                weekdayLabelTextStyle: style,
                yearTextStyle: style,
                controlsTextStyle: style,
                nextMonthIcon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: AppColor.onPrimary,
                ),
                lastMonthIcon: const Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: AppColor.onPrimary,
                ),
                calendarType: CalendarDatePicker2Type.single,
              ),
              value: _dates,
              onValueChanged: (dates) {
                setState(() {
                  Random rnd = Random();
                  _dates = dates;
                  bool same = false;
                  bool isAfter = false;
                  DateTime today = DateTime.now();
                  DateTime todayDate =
                      DateTime(today.year, today.month, today.day);

                  for (DateTime? selectedDate in _dates) {
                    if (selectedDate != null) {
                      DateTime selectedDateWithoutTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day);
                      if (selectedDateWithoutTime.isAtSameMomentAs(todayDate)) {
                        setState(() {
                          same = true;
                        });
                        break;
                      }
                      if (selectedDateWithoutTime.isAfter(todayDate)) {
                        isAfter = true;
                        controller.dialogue("attendanceWarning".tr);
                      }
                    }
                  }
                  if (same == true) {
                    setState(() {
                      controller.present.value = 45;
                      controller.update();
                    });
                  } else if (same == false && isAfter == false) {
                    controller.present.value = controller.min +
                        rnd.nextInt(controller.max - controller.min);
                    controller.update();
                  }
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: decoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<ProfileController>(builder: (controller) {
                  controller.getTeacherListLogin();

                  return Obx(() => Text(
                          '${'Class'.tr} : ${controller.classController.text.obs}')
                      .paddingSymmetric(vertical: 10));
                }),
                Text('${'TotalChildren'.tr} :  50')
                    .paddingSymmetric(vertical: 10),
                Text('${'Present'.tr} :  ${_dates[0] == DateTime.now() ? 25 : controller.present}')
                    .paddingSymmetric(vertical: 10),
                Text('${'Absent'.tr} :  ${50 - controller.present.value}')
                    .paddingSymmetric(vertical: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
