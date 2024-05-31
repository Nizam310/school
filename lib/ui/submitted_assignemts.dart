import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/util/color.dart';

import '../controller/profile_controller.dart';

class SubmittedAssignments extends StatefulWidget {
  const SubmittedAssignments({super.key});

  @override
  State<SubmittedAssignments> createState() => _SubmittedAssignmentsState();
}

class _SubmittedAssignmentsState extends State<SubmittedAssignments> {
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    controller.getSubmittedAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return ListView(
        children: [
          for (var i in controller.submittedAssignmentsList)
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            ImageViewingPageStudent(image: i)));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration: BoxDecoration(
                color: AppColor.secondary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(i ?? ''),
                            height: 200, width: 200, /*fit: BoxFit.fill*/))
                    .paddingSymmetric(horizontal: 10, vertical: 10),
              ),
            )
        ],
      );
    });
  }
}

class ImageViewingPageStudent extends StatelessWidget {
  final String image;

  const ImageViewingPageStudent({
    super.key,
    required this.image,
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
          Image.file(
            File(image),
          ).paddingSymmetric(vertical: 10),
        ],
      ),
    );
  }
}
