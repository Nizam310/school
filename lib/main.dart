import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/ui/forgot_password.dart';
import 'package:school/ui/home.dart';
import 'package:school/ui/introduction.dart';
import 'package:school/ui/language_selection_page.dart';
import 'package:school/ui/login.dart';
import 'package:school/ui/profile.dart';
import 'package:school/ui/register.dart';
import 'package:school/util/color.dart';
import 'package:school/util/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getLanguage();
  runApp(const MyApp());
}

String language = '';

getLanguage() async {
  final pref = await SharedPreferences.getInstance();
  var lang = pref.getString('language');
  if (lang != null) {
    language = lang;
  } else {
    log('item is null');
  }
}

Locale locale = const Locale("en-US");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School',
        translations: Languages(),
        locale: locale,
        theme: ThemeData(
            textTheme: const TextTheme(
                bodyMedium: TextStyle(color: AppColor.onSecondary))),
        getPages: [
          GetPage(name: '/', page: () => const IntroductionPage()),
          GetPage(name: '/regFirst', page: () => const LanguageSubmit()),
          GetPage(name: '/register', page: () => const Register()),
          GetPage(name: '/login', page: () => const Login()),
          GetPage(name: '/home', page: () => const Home()),
          GetPage(name: '/profile', page: () => const Profile()),
          GetPage(name: '/forgotPassword', page: () => const ForgotPassword()),
        ],
      ),
    );
  }
}
