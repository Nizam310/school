import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school/controller/register_controller.dart';
import 'package:school/util/color.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final controller = Get.put(RegisterController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Lottie.asset("assets/animations/school.json", height: 400)
              .paddingSymmetric(vertical: 10),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.onPrimary),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
            child: Column(
              children: [
                const Text("Welcome to the KCM LP School App!")
                    .paddingSymmetric(vertical: 10),
                const Text(
                    textAlign: TextAlign.start,
                    'At KCM LP School,we pride ourselves on providing a nurturing and enriching educational experience for young minds.\n\nOur school is home to four vibrant classes, each brimming with 50 eager students ready to embark on their educational journey.\n \nWith our school app, you\'ll have access to a world of information, communication, and resources to keep you connected with our school community.\n \nStay tuned to stay informed, engaged, and inspired as we explore the exciting world of learning together!'),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      Get.context!,
                      '/regFirst',
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 30, right: 10, left: 10, bottom: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.onPrimary)),
                          child: const Text(
                            "Okay",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
