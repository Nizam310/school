import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school/controller/login_controller.dart';
import 'package:school/util/custom_widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../util/color.dart';
import '../util/custom_widgets/cus_button.dart';
import '../util/enum.dart';
import '../util/local_db.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
  }

  Locale locale = const Locale("en-US");

  @override
  Widget build(BuildContext context) {
    switch (language) {
      case "hindi":
        locale = const Locale('hi-IN');
        Get.locale = locale;

        break;
      case "malayalam":
        locale = const Locale('ml-IN');
        Get.locale = locale;

        break;
      case "english":
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
        padding: const EdgeInsets.all(10),
        children: [
          Lottie.asset('assets/animations/first_submit.json'),
          Text('TSQ'.tr).paddingSymmetric(vertical: 10),
          Row(
            children: [
              Row(
                children: [
                  Radio(
                      activeColor: AppColor.buttonColor,
                      value: "student",
                      groupValue: controller.tsType.value,
                      onChanged: (val) async {
                        setState(() {
                          controller.tsType.value = val!;

                        });
                      }),
                  Text('Student'.tr)
                ],
              ),
              Row(
                children: [
                  Radio(
                      activeColor: AppColor.buttonColor,
                      value: "teacher",
                      groupValue: controller.tsType.value,
                      onChanged: (val)  {
                        setState(() {
                          controller.tsType.value = val!;
                        });
                      }),
                  Text('Teacher'.tr)
                ],
              ),
            ],
          ).paddingSymmetric(vertical: 10),
          CusTextField(
                  label: 'Name'.tr,
                  controller: controller.usernameController,
                  showText: false)
              .paddingSymmetric(vertical: 10),
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
          ).paddingOnly(top: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    controller.forgotPassword();
                  },
                  child: Text(
                    "forgotPassword".tr,
                    style: const TextStyle(color: AppColor.buttonColor),
                  )).paddingSymmetric(vertical: 10),
            ],
          ),
          CusButton(
            text: 'login'.tr,
            onTap: () async {
              setState(() {
                controller.onLogin();
              });
            },
          ).paddingSymmetric(vertical: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("signUpMessage".tr),
              TextButton(
                  onPressed: () {
                    controller.signUp();
                  },
                  child: Text(
                    "signUp".tr,
                    style: const TextStyle(color: AppColor.buttonColor),
                  )),
            ],
          ).paddingSymmetric(vertical: 10),
        ],
      ),
    );
  }
}
