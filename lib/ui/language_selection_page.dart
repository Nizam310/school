import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/register_controller.dart';
import '../util/color.dart';
import '../util/custom_widgets/cus_button.dart';
import '../util/enum.dart';

class LanguageSubmit extends StatefulWidget {
  const LanguageSubmit({super.key});

  @override
  State<LanguageSubmit> createState() => _LanguageSubmitState();
}

class _LanguageSubmitState extends State<LanguageSubmit> {
  final controller = Get.put(RegisterController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getStudentList();
    controller.getTeacherList();
  }

  Locale locale = const Locale("en-US");

  @override
  Widget build(BuildContext context) {
    switch (controller.languageType) {
      case Language.hindi:
        locale = const Locale('hi-IN');
        Get.locale = locale;

        break;
      case Language.malayalam:
        locale = const Locale('ml-IN');
        Get.locale = locale;

        break;
      case Language.english:
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
        body: ListView(
          children: [
            Lottie.asset('assets/animations/first_submit.json'),
            Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TSQ'.tr).paddingSymmetric(vertical: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                                activeColor: AppColor.buttonColor,
                                value: TS.student,
                                groupValue: controller.tsType,
                                onChanged: (val) {
                                  setState(() {
                                    controller.tsType = val!;
                                  });
                                }),
                            Text('Student'.tr)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                activeColor: AppColor.buttonColor,
                                value: TS.teacher,
                                groupValue: controller.tsType,
                                onChanged: (val) {
                                  setState(() {
                                    controller.tsType = val!;
                                  });
                                }),
                            Text('Teacher'.tr)
                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: 10),
                    Text('langQ'.tr).paddingSymmetric(vertical: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                                activeColor: AppColor.buttonColor,
                                value: Language.english,
                                groupValue: controller.languageType,
                                onChanged: (val) async {
                                  await Get.updateLocale(const Locale('en-US'));
                                  Get.locale = const Locale('en-US');
                                  print(Get.locale);
                                  setState(() {
                                    controller.languageType = val!;

                                    controller.update();
                                  });
                                }),
                            Text('english'.tr)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                activeColor: AppColor.buttonColor,
                                value: Language.hindi,
                                groupValue: controller.languageType,
                                onChanged: (val) async {
                                  await Get.updateLocale(const Locale('hi-IN'));
                                  Get.locale = const Locale('hi-IN');
                                  print(Get.locale);
                                  setState(() {
                                    controller.languageType = val!;
                                    controller.update();
                                  });
                                }),
                            Text('hindi'.tr)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                activeColor: AppColor.buttonColor,
                                value: Language.malayalam,
                                groupValue: controller.languageType,
                                onChanged: (val) async {
                                  await Get.updateLocale(const Locale('ml-IN'));
                                  Get.locale = const Locale('ml-IN');
                                  print(Get.locale);
                                  controller.update();
                                  setState(() {
                                    controller.languageType = val!;
                                  });
                                }),
                            Text('malayalam'.tr)
                          ],
                        ),
                      ],
                    ),
                    GetBuilder<RegisterController>(builder: (controller) {
                      return CusButton(
                          text: 'submit'.tr,
                          onTap: () {
                            setState(() {
                              controller.onSubmitFirstPage();
                            });
                          }).paddingSymmetric(vertical: 10);
                    }),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                          color: AppColor.onPrimary,
                        )),
                        Text("or".tr).paddingSymmetric(horizontal: 10),
                        const Expanded(
                            child: Divider(
                          color: AppColor.onPrimary,
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("havingAnAccount".tr),
                        TextButton(
                            onPressed: () {
                              controller.signIN();
                            },
                            child: Text("signIn".tr))
                      ],
                    ).paddingSymmetric(vertical: 10),
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 20),
              ).paddingSymmetric(horizontal: 10),
            )
          ],
        ));
  }
}
