import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school/util/color.dart';
import 'package:school/util/custom_widgets/text_field.dart';

import '../controller/login_controller.dart';
import '../util/custom_widgets/cus_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Lottie.asset("assets/animations/first_submit.json"),
          CusTextField(
            label: 'newPassword'.tr,
            controller: controller.newPasswordController,
            showText: controller.showPasswordNew.value,
            suffix: InkWell(
              borderRadius: BorderRadius.circular(100),
              radius: 0.0,
              onTap: () {
                setState(() {
                  controller.showPasswordNew.value =
                      !controller.showPasswordNew.value;
                  controller.update();
                });
              },
              child: Icon(
                controller.showPasswordNew.value == true
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                color: AppColor.onPrimary,
              ),
            ),
          ).paddingSymmetric(vertical: 10),
          CusTextField(
            label: 'reEnterPassword'.tr,
            controller: controller.reEnterPasswordController,
            showText: controller.showPasswordReEnter.value,
            suffix: InkWell(
              borderRadius: BorderRadius.circular(100),
              radius: 0.0,
              onTap: () {
                setState(() {
                  controller.showPasswordReEnter.value =
                      !controller.showPasswordReEnter.value;
                  controller.update();
                });
              },
              child: Icon(
                controller.showPasswordReEnter.value == true
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                color: AppColor.onPrimary,
              ),
            ),
          ).paddingSymmetric(vertical: 10),
          CusButton(
            text: 'submit'.tr,
            onTap: () {
              setState(() {
                controller.forgotPasswordSubmit();
              });
            },
          ).paddingSymmetric(vertical: 10),
        ],
      ),
    );
  }
}
