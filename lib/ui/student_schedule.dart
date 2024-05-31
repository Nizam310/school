import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/util/color.dart';

import '../controller/profile_controller.dart';

class StudentSchedule extends StatefulWidget {
  const StudentSchedule({super.key});

  @override
  State<StudentSchedule> createState() => _StudentScheduleState();
}

class _StudentScheduleState extends State<StudentSchedule> {
  final controller = Get.put(ProfileController());
  final style = const TextStyle(color: AppColor.onPrimary);
  final decoration = BoxDecoration(
    color: AppColor.secondary,
    borderRadius: BorderRadius.circular(10),
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text("Schedule".tr),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "student".tr,
                ),
                Tab(
                  text: "teacher".tr,
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              /// student
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                children: [
                  Column(
                    children: [
                      for (var i in controller.studentScheduleList)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.all(10),
                                decoration: decoration,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${'time'.tr} : ${i["startTime"]} - ${i['endTime'] ?? ''}')
                                        .paddingSymmetric(vertical: 10),
                                    Text('${'tutor/event'.tr} : ${i['teacher']}')
                                        .paddingSymmetric(vertical: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),

              /// ///////////////////////////////
              /// teacher
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
        ));
  }
}
