import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/register_controller.dart';
import 'package:school/main.dart';
import 'package:school/util/color.dart';
import 'package:school/util/custom_widgets/cus_button.dart';
import 'package:school/util/custom_widgets/text_field.dart';
import 'package:school/util/extension.dart';

import '../util/enum.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final controller = Get.put(RegisterController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getRegister();
    controller.getStudentList();
    controller.getTeacherList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.primary,
        body: GetBuilder<RegisterController>(builder: (controller) {
          return _SecondOne(
            controller: controller,
          );
        }));
  }
}

class _SecondOne extends StatefulWidget {
  final RegisterController controller;

  const _SecondOne({required this.controller});

  @override
  State<_SecondOne> createState() => _SecondOneState();
}

class _SecondOneState extends State<_SecondOne> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      children: [
        widget.controller.tsType == TS.teacher
            ? _teacher(widget.controller)
            : widget.controller.tsType == TS.student
                ? _student(widget.controller)
                : const SizedBox(),
      ],
    );
  }

  Widget _student(RegisterController controller) {
    return Form(
      key: controller.studentKey,
      child: Column(
        children: [
          InkWell(
            radius: 0.0,
            onTap: () {
              controller.pickFiles();
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.onPrimary),
                    borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<RegisterController>(builder: (controller) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: controller.image != null
                        ? Image.file(
                            File(controller.image ?? ''),
                            fit: BoxFit.fill,
                          )
                        : Center(
                            child: Text(
                            'imageClick'.tr,
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: AppColor.onPrimary),
                          )).paddingSymmetric(horizontal: 4),
                  );
                })),
          ),
          CusTextField(
            label: 'Name'.tr,
            controller: controller.nameController,
            keyBoardType: TextInputType.text,
            showText: false,
            validator: (val) {
              if (!val!.isValidName) {
                return "nameWarning".tr;
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            label: 'Password'.tr,
            controller: controller.passwordController,
            showText: controller.showPassword.value,
            suffix: InkWell(
              borderRadius: BorderRadius.circular(100),
              radius: 0.0,
              onTap: () {
                setState(() {
                  controller.showPassword.value =
                      !controller.showPassword.value;
                  controller.update();
                });
              },
              child: Icon(
                controller.showPassword.value == true
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                color: AppColor.onPrimary,
              ),
            ),
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            keyBoardType: TextInputType.number,
            label: 'Age'.tr,
            controller: controller.ageController,
            showText: false,
            validator: (val) {
              if (val!.isNotEmpty) {
                var text = int.parse(val);
                if (text > 12) {
                  return "ageWarning".tr;
                } else if (text < 5) {
                  return "ageWarning".tr;
                }
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            keyBoardType: TextInputType.number,
            label: 'Class'.tr,
            controller: controller.classController,
            showText: false,
            validator: (val) {
              if (val!.isNotEmpty) {
                var text = int.parse(val);
                if (text > 4) {
                  return "classWarning".tr;
                } else if (text < 1) {
                  return "classWarning".tr;
                }
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            keyBoardType: TextInputType.number,
            label: 'RollNo'.tr,
            controller: controller.rollNoController,
            showText: false,
            validator: (val) {
              if (val!.isNotEmpty) {
                var text = int.parse(val);
                if (text > 50) {
                  return "rollNoWarning".tr;
                } else if (text < 1) {
                  return "rollNoWarning".tr;
                }
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
                  keyBoardType: TextInputType.text,
                  label: 'Address'.tr,
                  maxLines: 3,
                  controller: controller.addressController,
                  showText: false)
              .paddingSymmetric(vertical: 10),
          CusTextField(
            keyBoardType: TextInputType.text,
            label: 'FathersName'.tr,
            controller: controller.fathersNameController,
            showText: false,
            validator: (val) {
              if (!val!.isValidName) {
                return "nameWarning".tr;
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            keyBoardType: TextInputType.text,
            label: 'MothersName'.tr,
            controller: controller.mothersNameController,
            showText: false,
            validator: (val) {
              if (!val!.isValidName) {
                return "nameWarning".tr;
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusButton(
              text: 'submit'.tr,
              onTap: () {
                setState(() {
                  controller.onRegister();
                });
              }).paddingSymmetric(vertical: 10)
        ],
      ),
    );
  }

  Widget _teacher(RegisterController controller) {
    return Form(
      key: controller.teacherKey,
      child: Column(
        children: [
          InkWell(
            radius: 0.0,
            onTap: () {
              controller.pickFiles();
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    // color: const Color(0xFF32C4C1),
                    border: Border.all(color: AppColor.onPrimary),
                    borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<RegisterController>(builder: (controller) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: controller.image != null
                        ? Image.file(
                            File(controller.image ?? ''),
                            fit: BoxFit.fill,
                          )
                        : Center(
                            child: Text(
                            'Click to Add Image',
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: AppColor.onPrimary),
                          )).paddingSymmetric(horizontal: 2),
                  );
                })),
          ),
          CusTextField(
            label: 'Name'.tr,
            controller: controller.nameController,
            showText: false,
            validator: (val) {
              if (!val!.isValidName) {
                return "nameWarning".tr;
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            label: 'Password'.tr,
            controller: controller.passwordController,
            showText: controller.showPassword.value,
            suffix: InkWell(
              borderRadius: BorderRadius.circular(100),
              radius: 0.0,
              onTap: () {
                setState(() {
                  controller.showPassword.value =
                      !controller.showPassword.value;
                  controller.update();
                });
              },
              child: Icon(
                controller.showPassword.value == true
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                color: AppColor.onPrimary,
              ),
            ),
          ).paddingSymmetric(vertical: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.onPrimary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('classList'.tr).paddingSymmetric(vertical: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: controller.classList
                        .map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (controller.teachingClasses.isNotEmpty) {
                                    if (!controller.teachingClasses
                                        .contains(e)) {
                                      controller.teachingClasses.add(e);
                                      controller.update();
                                    } else {
                                      controller
                                          .dialogue('You already added this');
                                    }
                                  } else {
                                    controller.teachingClasses.add(e);
                                    controller.update();
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.onPrimary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(e).paddingSymmetric(horizontal: 5),
                              ),
                            ))
                        .toList()),
                controller.teachingClasses.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: controller.teachingClasses
                            .map(
                              (e) => Chip(
                                  label: Text(e),
                                  deleteIcon: const Icon(
                                    Icons.clear,
                                    color: AppColor.onPrimary,
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      controller.teachingClasses.remove(e);
                                      controller.update();
                                    });
                                  }).paddingAll(5),
                            )
                            .toList())
                    : const SizedBox()
              ],
            ),
          ),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text('classTQ'.tr)
                  .paddingSymmetric(vertical: 20, horizontal: 10)),
          Row(
            children: [
              Row(
                children: [
                  Radio(
                      activeColor: AppColor.buttonColor,
                      value: "1",
                      groupValue: controller.selected.value,
                      onChanged: (val) {
                        setState(() {
                          controller.selected.value = "1";
                          controller.classTeacherOrNot.value = false;
                          print(controller.classTeacherOrNot);
                        });
                      }),
                  Text('No'.tr)
                ],
              ),
              Row(
                children: [
                  Radio(
                      activeColor: AppColor.buttonColor,
                      value: "2",
                      groupValue: controller.selected.value,
                      onChanged: (val) {
                        setState(() {
                          controller.selected.value = "2";
                          controller.classTeacherOrNot.value = true;
                          print(controller.classTeacherOrNot);
                        });
                      }),
                  Text('Yes'.tr)
                ],
              ),
            ],
          ).paddingSymmetric(vertical: 10),
          Visibility(
            visible: controller.classTeacherOrNot.isTrue,
            child: CusTextField(
              label: 'Class'.tr,
              keyBoardType: TextInputType.number,
              controller: controller.classController,
              showText: false,
              validator: (val) {
                if (val!.isNotEmpty) {
                  var text = int.parse(val);
                  if (text > 4) {
                    return "classWarning".tr;
                  } else if (text < 1) {
                    return "classWarning".tr;
                  }
                }
                return null;
              },
            ).paddingSymmetric(vertical: 10),
          ),
          CusTextField(
            label: 'Age'.tr,
            controller: controller.ageController,
            keyBoardType: TextInputType.number,
            showText: false,
            validator: (val) {
              if (val!.isNotEmpty) {
                var text = int.parse(val);
                if (text > 60) {
                  return "ageWarning".tr;
                } else if (text < 18) {
                  return "ageWarning".tr;
                }
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextField(
                  label: 'Address'.tr,
                  controller: controller.addressController,
                  maxLines: 3,
                  showText: false)
              .paddingSymmetric(vertical: 10),
          CusTextField(
            label: 'Experience'.tr,
            controller: controller.experienceController,
            keyBoardType: TextInputType.number,
            showText: false,
            validator: (val) {
              if (val!.isNotEmpty) {
                var text = int.parse(val);
                if (text > 42) {
                  return "expWarning".tr;
                } else if (text < 0) {
                  return "expWarning".tr;
                }
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusButton(
              text: 'submit'.tr,
              onTap: () {
                setState(() {
                  controller.onRegister();
                });
              }).paddingSymmetric(vertical: 10),
        ],
      ),
    );
  }
}
