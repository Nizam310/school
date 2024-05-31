import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school/controller/profile_controller.dart';
import 'package:school/util/color.dart';

class TeacherSchedule extends StatefulWidget {
  const TeacherSchedule({super.key});

  @override
  State<TeacherSchedule> createState() => _TeacherScheduleState();
}

class _TeacherScheduleState extends State<TeacherSchedule> {
  final controller = Get.put(ProfileController());
  final style = const TextStyle(color: AppColor.onPrimary);
  final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColor.onPrimary));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Schedule'.tr),
          bottom: TabBar(
            tabs: [
              Tab(text: "your".tr),
              Tab(text: "allTeacher".tr),
            ],
          ),
        ),
        backgroundColor: AppColor.primary,
        body: TabBarView(
          children: [
            /// Your
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // Text(controller.currentTime.value),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      controller.currentDate.value,
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: AppColor.onPrimary),
                    ).paddingSymmetric(horizontal: 10),
                    Text(
                      DateFormat('EEEE').format(DateTime.now()),
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: AppColor.onPrimary),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.teachingClasses
                      .asMap()
                      .entries
                      .map((classEntry) {
                        final int classIndex = classEntry.key;
                        final String className = classEntry.value;

                        if (classIndex >=
                            controller.teachingScheduleList.length) {
                          return null;
                        }

                        final scheduleItem =
                            controller.teachingScheduleList[classIndex];
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.all(10),
                                decoration: decoration,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${'Class'.tr} : $className')
                                        .paddingSymmetric(vertical: 10),
                                    Text('${"time".tr} : ${scheduleItem['startTime']} - ${scheduleItem['endTime']}')
                                        .paddingSymmetric(vertical: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                      .where((widget) => widget != null)
                      .map((widget) => widget!)
                      .toList(), // Cast to List<Widget>
                )
              ],
            ),

            /// All teacher
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Column(
                  children: controller.allTeacherScheduleList.map((data) {
                    var list = (data["schedule"]) as List;
                    return ListTileTheme(
                      iconColor: AppColor.onPrimary,
                      tileColor: AppColor.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        expandedAlignment: Alignment.topLeft,
                        backgroundColor: AppColor.secondary,
                        title: Text(
                          data["name"],
                          style: const TextStyle(color: AppColor.onPrimary),
                        ),
                        textColor: AppColor.onPrimary,
                        iconColor: AppColor.onPrimary,
                        children: [
                          Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: list
                                      .map(
                                        (e) => Container(
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColor.onPrimary)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${'Class'.tr} :${e["class"]}')
                                                  .paddingSymmetric(
                                                      vertical: 10),
                                              Text('${"time".tr} : ${e['startTime']} - ${e['endTime']}')
                                                  .paddingSymmetric(
                                                      vertical: 10),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList())
                              .paddingSymmetric(vertical: 10, horizontal: 10)
                        ],
                      ).paddingSymmetric(vertical: 10),
                    );
                  }).toList(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
