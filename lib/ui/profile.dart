import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/profile_controller.dart';
import 'package:school/util/extension.dart';

import '../util/color.dart';
import '../util/custom_widgets/cus_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getTS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Obx(() =>
            Text(controller.enable.value == false ? "Profile".tr : 'edit'.tr)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          Obx(() => controller.tsType.value == "student"
              ? _student(controller)
              : controller.tsType.value == "teacher"
                  ? _teacher(controller)
                  : const Text("No Value Available"))
        ],
      ),
    );
  }

  _teacher(ProfileController controller) {
    return Form(
      key: controller.formKey,
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
                    border: Border.all(
                        color: controller.enable.value == false
                            ? Colors.transparent
                            : AppColor.onPrimary),
                    borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<ProfileController>(builder: (controller) {
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            enable: controller.enable.value,
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            enable: controller.enable.value,
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
                Visibility(
                    visible: controller.enable.value == true,
                    child: Text('classList'.tr).paddingSymmetric(vertical: 10)),
                Visibility(
                  visible: controller.enable.value == true,
                  child: Row(
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
                                    border:
                                        Border.all(color: AppColor.onPrimary),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      Text(e).paddingSymmetric(horizontal: 5),
                                ),
                              ))
                          .toList()),
                ),
                controller.teachingClasses.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: controller.teachingClasses
                            .map(
                              (e) => Chip(
                                  label: Text(e),
                                  deleteIcon: Visibility(
                                    visible: controller.enable.value == true,
                                    child: const Icon(
                                      Icons.clear,
                                      color: AppColor.onPrimary,
                                    ),
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
          controller.classController.text.isNotEmpty
              ? CusTextFieldProfile(
                      edit: controller.enable.value,
                      keyBoardType: TextInputType.number,
                      enable: controller.enable.value,
                      label: 'Class'.tr,
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          var text = int.parse(val);
                          if (text > 4) {
                            return "This school only having LP section so choose 1 - 4 classes";
                          } else if (text < 1) {
                            return "This school only having LP section so choose 1 - 4 classes";
                          }
                        }
                        return null;
                      },
                      controller: controller.classController,
                      showText: false)
                  .paddingSymmetric(vertical: 10)
              : const SizedBox(),
          CusTextFieldProfile(
                  edit: controller.enable.value,
                  keyBoardType: TextInputType.number,
                  enable: controller.enable.value,
                  label: 'Age'.tr,
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
                  controller: controller.ageController,
                  showText: false)
              .paddingSymmetric(vertical: 10),
          CusTextFieldProfile(
                  edit: controller.enable.value,
                  enable: controller.enable.value,
                  label: 'Address'.tr,
                  controller: controller.addressController,
                  showText: false)
              .paddingSymmetric(vertical: 10),
          CusTextFieldProfile(
                  edit: controller.enable.value,
                  enable: controller.enable.value,
                  keyBoardType: TextInputType.number,
                  label: 'Experience'.tr,
                  controller: controller.experienceController,
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
                  showText: false)
              .paddingSymmetric(vertical: 10),
          Obx(
            () => CusButton(
                text:
                    controller.enable.value == false ? "edit".tr : 'submit'.tr,
                onTap: () {
                  setState(() {
                    controller.onEdit();
                  });
                }).paddingSymmetric(vertical: 10),
          ),
        ],
      ),
    );
  }

  _student(ProfileController controller) {
    return Form(
      key: controller.formKey,
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
                    border: Border.all(
                        color: controller.enable.value == false
                            ? Colors.transparent
                            : AppColor.onPrimary),
                    borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<ProfileController>(builder: (controller) {
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            enable: controller.enable.value,
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            enable: controller.enable.value,
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            keyBoardType: TextInputType.number,
            enable: controller.enable.value,
            label: 'Age'.tr,
            controller: controller.ageController,
            showText: false,
            validator: (val) {
              if (val!.isNotEmpty) {
                var text = int.parse(val);
                if (text > 15) {
                  val = "";
                  return "ageWarning".tr;
                } else if (text < 5) {
                  val = "";
                  return "ageWarning".tr;
                }
              }
              return null;
            },
          ).paddingSymmetric(vertical: 10),
          CusTextFieldProfile(
            edit: controller.enable.value,
            keyBoardType: TextInputType.number,
            enable: controller.enable.value,
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
          CusTextFieldProfile(
                  edit: controller.enable.value,
                  enable: controller.enable.value,
                  label: 'Address'.tr,
                  controller: controller.addressController,
                  showText: false)
              .paddingSymmetric(vertical: 10),
          CusTextFieldProfile(
            edit: controller.enable.value,
            keyBoardType: TextInputType.number,
            label: 'RollNo'.tr,
            controller: controller.rollNoController,
            showText: false,
            enable: controller.enable.value,
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            enable: controller.enable.value,
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
          CusTextFieldProfile(
            edit: controller.enable.value,
            enable: controller.enable.value,
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
          Obx(
            () => CusButton(
                text:
                    controller.enable.value == false ? "edit".tr : 'submit'.tr,
                onTap: () {
                  setState(() {
                    controller.onEdit();
                  });
                }).paddingSymmetric(vertical: 10),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.enable.value = false;
  }
}

class CusTextFieldProfile extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool showText;
  final Widget? suffix;
  final int? maxLines;
  final bool? enable;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;
  final bool edit;

  const CusTextFieldProfile({
    super.key,
    required this.label,
    required this.controller,
    required this.showText,
    this.suffix,
    this.enable,
    this.keyBoardType,
    this.validator,
    this.maxLines,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
          color: edit == false ? Colors.transparent : AppColor.onPrimary),
      borderRadius: BorderRadius.circular(10),
    );

    return TextFormField(
      maxLines: maxLines ?? 1,
      enabled: enable ?? true,
      obscureText: showText,
      controller: controller,
      keyboardType: keyBoardType ?? TextInputType.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColor.onPrimary),
      decoration: InputDecoration(
        errorMaxLines: 3,
        enabled: true,
        labelText: label,
        labelStyle: const TextStyle(color: AppColor.onPrimary),
        fillColor: AppColor.secondary,
        filled: edit == false ? true : false,
        border: border,
        suffix: suffix,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
      ),
      onTapOutside: (val) {
        Get.focusScope?.unfocus();
      },
      validator: validator,
    );
  }
}
