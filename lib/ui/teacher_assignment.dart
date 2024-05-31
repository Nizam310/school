import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/profile_controller.dart';
import 'package:school/util/color.dart';

class TeacherAssignment extends StatefulWidget {
  const TeacherAssignment({super.key});

  @override
  State<TeacherAssignment> createState() => _TeacherAssignmentState();
}

class _TeacherAssignmentState extends State<TeacherAssignment> {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Assignments'.tr),
      ),
      body:*/
        Column(
      children: [
        Column(
          children: controller.assignmentList.map((e) {
            List list = e['images'];
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.onPrimary),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ImageViewingPageTeacher(
                                    list: list,
                                  )));
                    },
                    child: Column(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            list.first,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          )).paddingSymmetric(vertical: 10, horizontal: 10),
                    ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${'Name'.tr}    : ${e['name']}')
                          .paddingSymmetric(vertical: 10),
                      Text('${'Class'.tr}   : ${e['class']}')
                          .paddingSymmetric(vertical: 10),
                      Text('${'RollNo'.tr} : ${e['rollNo']}')
                          .paddingSymmetric(vertical: 10),
                    ],
                  ).paddingSymmetric(vertical: 10, horizontal: 20),
                ],
              ),
            );
          }).toList(),
        )
      ],
      // ),
    );
  }
}

class ImageViewingPageTeacher extends StatelessWidget {
  final List list;

  const ImageViewingPageTeacher({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            children: list
                .map(
                  (e) => Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          e,
                          height: 400,
                          width: 250,
                          fit: BoxFit.fill,
                        ).paddingSymmetric(vertical: 10),
                      ),
                    ],
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
