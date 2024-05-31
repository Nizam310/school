import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/profile_controller.dart';
import 'package:school/ui/submitted_assignemts.dart';
import 'package:school/util/color.dart';

class AddAssignment extends StatefulWidget {
  const AddAssignment({super.key});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment>
    with TickerProviderStateMixin {
  final controller = Get.put(ProfileController());
  TabController? tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getSubmittedAssignments();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_switchTabIndex);
  }

  void _switchTabIndex() {
    print(tabController?.index);
    setState(() {});
  }

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
          title: Text("Assignments".tr),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                text: "addAssignments".tr,
              ),
              Tab(
                text: "submittedAssignments".tr,
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                GetBuilder<ProfileController>(builder: (controller) {
                  return Wrap(children: [
                    for (var i in controller.studentAssignment)
                      ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(File(i ?? ''),
                                  height: 200, width: 200, /*fit: BoxFit.fill*/))
                          .paddingSymmetric(horizontal: 10, vertical: 10),
                    InkWell(
                      radius: 0.0,
                      onTap: () {
                        controller.addAssignment();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.secondary,
                        ),
                        height: 200,
                        width: 200,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]);
                }),
              ],
            ),
            GetBuilder<ProfileController>(builder: (controller) {
              return controller.submittedAssignmentsList.isNotEmpty
                  ? const SubmittedAssignments()
                  : Center(
                      child: Text(
                        "noData".tr,
                        style: context.textTheme.labelLarge
                            ?.copyWith(color: AppColor.onPrimary),
                      ),
                    );
            }),
          ],
        ),
        floatingActionButton: Visibility(
          visible: tabController?.index == 0,
          child: FloatingActionButton.extended(
            backgroundColor: AppColor.buttonColor,
            onPressed: () {
              setState(() {
                controller.submitAssignment();
              });
            },
            label: Text("submit".tr),
          ),
        ),
      ),
    );
  }
}
