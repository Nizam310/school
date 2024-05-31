import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/color.dart';
import '../util/enum.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('settings'.tr,style: const TextStyle(color: Colors.white),),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Text('langQ'.tr).paddingSymmetric(vertical: 10),
          Card(
            color: AppColor.secondary,
            child: Row(
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
                            controller.submitSettings();
                            controller.update();
                          });
                        }),
                    const Text('English')
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
                            controller.submitSettings();
                            controller.update();
                          });
                        }),
                    const Text('हिंदी')
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
                            controller.submitSettings();
                          });
                        }),
                    const Text('മലയാളം')
                  ],
                ),
              ],
            ).paddingSymmetric(vertical: 10),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (builder) => AlertDialog(
                        title: Text("warning".tr),
                        content: Text('logoutWarning'.tr),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(Get.context!);
                              },
                              child: Text("cancel".tr)),
                          TextButton(
                              onPressed: () async {
                                final pref =
                                    await SharedPreferences.getInstance();
                                controller.isLogin.value = false;
                                pref.setBool(
                                    "isLogin", controller.isLogin.value);
                                Navigator.pushNamedAndRemoveUntil(
                                    Get.context!, '/logout', (route) => false);
                              },
                              child: Text("yes".tr)),
                        ],
                      ));
            },
            child: Card(
              color: AppColor.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "logout".tr,
                    style: const TextStyle(color: AppColor.onPrimary),
                  ),
                  const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                ],
              ).paddingSymmetric(vertical: 20, horizontal: 10),
            ),
          ).paddingSymmetric(vertical: 10)
        ],
      ),
    );
  }
}
